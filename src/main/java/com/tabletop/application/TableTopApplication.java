package com.tabletop.application;

import com.codahale.metrics.health.HealthCheckRegistry;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tabletop.admin.TableTopHealthCheck;
import com.tabletop.config.TableTopConfiguration;
import com.tabletop.resource.TableTopResource;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

import java.io.File;
import java.io.IOException;


public class TableTopApplication extends Application<TableTopConfiguration> {


    @Override
    public void initialize(Bootstrap<TableTopConfiguration> bootstrap) {
        registerModules(bootstrap.getObjectMapper());
    }

    private static void registerModules(ObjectMapper mapper) {
    }

    @Override
    public void run(TableTopConfiguration configuration, Environment environment) throws Exception {
        setupHealthChecks(environment.healthChecks());
        registerResources(environment);
    }

    private void registerResources(Environment environment) {
        environment.jersey().register(new TableTopResource());
    }

    private void setupHealthChecks(HealthCheckRegistry healthChecks) throws IOException {
        healthChecks.register("TableTopHealthCheck", new TableTopHealthCheck());
    }

    public static void main(String[] args) throws Exception {
        final String yml = "tableTopService.yml";
        if (args.length > 1) {
            new TableTopApplication().run(args);
        } else if (new File(yml).exists()) {
            new TableTopApplication().run(new String[]{"server", yml});
        } else if (new File("artefacts/" + yml).exists()) {
            new TableTopApplication().run(new String[]{"server", "artefacts/" + yml});
        } else {
            new TableTopApplication().run(args);
        }
    }
}
