package com.tabletop.config;

import javax.security.auth.login.AppConfigurationEntry;
import javax.security.auth.login.Configuration;

public class TableTopConfiguration extends Configuration {


    @Override
    public AppConfigurationEntry[] getAppConfigurationEntry(String name) {
        return new AppConfigurationEntry[0];
    }


}
