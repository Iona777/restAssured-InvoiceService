package com.costcutter.activbill.invoice.service.cucumber.stepdefs;

import com.costcutter.cucumber.utils.api.ApiCalls;
import com.costcutter.cucumber.utils.files.FileUtilities;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import io.restassured.http.Method;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.File;

public class ApiSteps {

    @Autowired
    private Logger logger;

    @Value("${cucumber.cas.username}")
    private String casUsername;

    @Value("${cucumber.cas.password}")
    private String casPassword;

    @Value("${ws.cas.oauth.accessToken}")
    private String casAccessTokenUrl;

    @Value("${ws.activbill-invoice-service}")
    private String activbillInvoiceServiceBaseEndpoint;

    @Autowired
    private RestTemplate restTemplate;

    private String bearerToken;

    @And("I set oAuth")
    public void iSetOAuth() {
        generateAuthToken();
        ApiCalls.resetAllRequestAndResponseParameters();
        ApiCalls.setRequestHeaders("Authorization", bearerToken);
    }

    @And("^I set OAuth for user ([^\"]*)$")
    public void iSetOAuthForUserUser(String user) {
        String token = generateAuthTokenForUser(user);
        ApiCalls.resetAllRequestAndResponseParameters();
        ApiCalls.setRequestHeaders("Authorization", token);
    }

    @When("I query GET endpoint {string}")
    public void queryGetEndpoint(String endpoint) {

        // Strip the request parameters out of the endpoint string so that
        // they'll be properly encoded by the REST call.  This is a very
        // simple approach and there are plenty of ways to break it.
        // Adding extra '=' characters to your query, for example.
        String actualEndpoint = StringUtils.substringBefore(endpoint, "?");
        String params = StringUtils.substringAfter(endpoint, "?");

        while (StringUtils.contains(params, "=")) {
            String value = StringUtils.substringAfterLast(params, "=");
            params = StringUtils.substringBeforeLast(params, "=");

            String key = StringUtils.defaultIfEmpty(StringUtils.substringAfterLast(params, "&"), params);
            params = StringUtils.substringBeforeLast(params, "&");

            ApiCalls.setRequestQueryParameter(key, value);
        }

        logger.info("I query the endpoint {}{}", activbillInvoiceServiceBaseEndpoint, endpoint);
        ApiCalls.setRequestUrl(activbillInvoiceServiceBaseEndpoint + actualEndpoint);
        ApiCalls.sendApiCall(Method.GET);
    }

    @Given("I start a new test")
    public void startNewTest() {
        logger.info("--- Starting new test ---");
        ApiCalls.resetAllRequestAndResponseParameters();
    }

    private String generateAuthTokenForUser(String user) {

        UriComponents components = UriComponentsBuilder.fromHttpUrl(casAccessTokenUrl)
                                                       .queryParam("grant_type", "password")
                                                       .queryParam("client_id", "activbill")
                                                       .queryParam("username", user)
                                                       .queryParam("password", casPassword)
                                                       .build();

        String body = restTemplate.getForObject(components.toUri(), String.class);

        body = StringUtils.substringAfter(body, "access_token=");
        return "Bearer " + StringUtils.substringBefore(body, "&expires");
    }

    private void generateAuthToken() {
        if (bearerToken == null) {
            bearerToken = generateAuthTokenForUser(casUsername);
        }
    }

    @And("^I set the query URL to ([^\"]*)$")
    public void iSetTheQueryURLTo(String endpoint) {
        logger.info("--- I set the query URL to {} ---", endpoint);
        ApiCalls.setRequestUrl(activbillInvoiceServiceBaseEndpoint + endpoint);
    }

    @When("I query POST endpoint {string}")
    public void queryPOSTEndpoint(String endpoint) {

        ApiCalls.setRequestContentType("application/json");

        logger.info("I query the endpoint {}/{}", activbillInvoiceServiceBaseEndpoint, endpoint);
        ApiCalls.setRequestUrl(activbillInvoiceServiceBaseEndpoint + endpoint);
        ApiCalls.sendApiCall(Method.POST);
    }

    @When("I query {string} endpoint {string} with request body from file: {string}")
    public void queryEndpointWithFilePath(String httpMethod, String endpoint, String filepath) {

        ApiCalls.setRequestContentType("application/json");

        ApiCalls.setRequestBody(FileUtilities.getStringFromResource(filepath));
        logger.info("*** \"request body is set to contents of file: {} ***", filepath);

        ApiCalls.setRequestUrl(activbillInvoiceServiceBaseEndpoint + endpoint);
        ApiCalls.sendApiCall(Method.valueOf(httpMethod));
        logger.info("I query the endpoint {}{}", activbillInvoiceServiceBaseEndpoint, endpoint);
    }

    @And("I create directory {string}")
    public void iCreateDirectorySrcTestResourcesTestdataSqlActualResults(String pathName) {
        new File(pathName).mkdirs();
    }
}
