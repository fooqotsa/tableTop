package com.tabletop.resource;

import com.codahale.metrics.annotation.Timed;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/")
public class TableTopResource {


    @GET
    @Timed
    public String test() {
        return new String("AMG THIS WORKS");
    }


}
