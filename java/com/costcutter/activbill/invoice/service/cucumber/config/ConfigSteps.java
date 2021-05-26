package com.costcutter.activbill.invoice.service.cucumber.config;

import cucumber.api.java.Before;
import org.springframework.test.context.ContextConfiguration;

@ContextConfiguration(classes = CucumberConfig.class)
public class ConfigSteps {

    @Before // This is the Cucumber @Before rather than the JUnit @Before.
    public void givenIHaveConfiguredSpring() {
        // Need this so Cucumber can pick up the Spring configuration.
    }
}
