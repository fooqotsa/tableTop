#!/bin/bash -e
cd $(dirname $0)
rm -f tableTop.tar.gz artefacts/*.jar

[ -f .banner ] && cat .banner

nice gradle clean build fatJar $@

cp -vf build/libs/tableTop-1.0-fat.jar artefacts/tableTop-1.0-fat.jar

./artefacts/tableTopService.sh restart
sleep 3

cd artefacts; tar zcvf ../tableTop.tar.gz *
echo
