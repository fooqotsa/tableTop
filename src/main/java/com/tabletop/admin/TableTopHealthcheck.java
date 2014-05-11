package com.tabletop.admin;

import com.codahale.metrics.health.HealthCheck;

public class TableTopHealthCheck extends HealthCheck {

    @Override
    protected Result check() throws Exception {
        return Result.healthy();
    }
}
