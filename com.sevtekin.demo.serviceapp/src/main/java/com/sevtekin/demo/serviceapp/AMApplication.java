package com.sevtekin.demo.serviceapp;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.core.Application;

public class AMApplication extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<Class<?>>();
        classes.add(AMResource.class);
        return classes;
    }

}
