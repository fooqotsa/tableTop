#!/bin/bash -e
# Launches the TableTop service as a Unix process

here=$(dirname $0)
memOpts="-Xmx512M"
httpPort=9540
dbgPort=9502
jmxPort=9503
ymlConfigFile="$here/tableTopService.yml"
jar=$here/sal-service-fat.jar
out=logs/sal-service.out

usage()
{
  echo "Usage: $0 [-jmx] [-dbg] start | stop | restart | status [Yaml-file]"
  echo "  -j  enable Java management support (JMX)"
  echo "  -d  enable debugging support (JPDA)"
  exit 1
}

function startService
{
  if [ "$DBG" ]; then
    dbgOpts="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=$dbgPort"
  fi

  # Configure JMX (via unsecured listener on port 1099)
  if [ "$JMX" ]; then
    inetAddr=`ifconfig | grep 'inet addr' | awk '{print $2}' | cut -d: -f2 | grep -v 127.0.0.1`
    jmx=com.sun.management.jmxremote
    jmxOpts="-D$jmx -D$jmx.port=$jmxPort -D$jmx.ssl=false -D$jmx.authenticate=false -Djava.rmi.server.hostname=$inetAddr"
  fi

  mkdir -p $(dirname $out)
  nohup java $memOpts $dbgOpts $jmxOpts -jar $jar server $ymlConfigFile > $out 2>&1 &
  sleep 3
  ps -ef |grep $ymlConfigFile |grep -v grep
}

function stopService
{
  pid=$(lsof -i tcp:$httpPort -s tcp:LISTEN | awk 'NR!=1 {print $2}')
  if  [ "$pid" != "" ]; then
    kill $pid
    sleep 1
  fi
}

function serviceStatus
{
  pid=$(lsof -i tcp:$httpPort -s tcp:LISTEN | awk 'NR!=1 {print $2}')
  name=$(basename $0 .sh)
  if  [ "$pid" = "" ]; then
    echo "$name is not running."
  else
    echo "$name is running (pid=$pid)."
  fi
  ps -ef |grep "$ymlConfigFile" |grep -v grep
}

for opt in $*; do
  case $opt in
    -j*) JMX=1 ;;
    -d*) DBG=1 ;;
    start | stop | status | restart) ;;
    *) if [ -f $opt ]; then ymlConfigFile=$opt
       else usage
       fi ;;
  esac
done

for opt in $*; do
  case $opt in
    start|restart)
      stopService
      startService ;;
    stop)
      stopService
      serviceStatus ;;
    status)
      serviceStatus ;;
  esac
done

