package com.costcutter.activbill.invoice.service.cucumber;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
    features = {
        "src/test/resources/features"
    },
    glue = {
        "com.costcutter.activbill.invoice.service.cucumber.config",
        "cucumber.api.spring",
        "com.costcutter.cucumber.utils.stepdefs",
        "com.costcutter.activbill.invoice.service.cucumber.stepdefs"
    },
    plugin = {
        "pretty", "html:target/cucumber",
        "json:target/cucumber/report.json",
        "junit:target/cucumber/junit.xml"
    }

)

public class RunAllFeatures
{

}
