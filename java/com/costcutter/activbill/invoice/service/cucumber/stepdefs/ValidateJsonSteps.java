package com.costcutter.activbill.invoice.service.cucumber.stepdefs;

import com.costcutter.cucumber.utils.api.ApiCalls;
import com.costcutter.cucumber.utils.dates.DateAdjustment;
import com.costcutter.cucumber.utils.files.FileUtilities;
import com.costcutter.cucumber.utils.json.VerifyJson;
import com.google.gson.Gson;
import com.jayway.jsonpath.JsonPath;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.http.Method;
import net.javacrumbs.jsonunit.core.Option;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import static net.javacrumbs.jsonunit.assertj.JsonAssertions.assertThatJson;
import static net.javacrumbs.jsonunit.assertj.JsonAssertions.json;
import static org.assertj.core.api.Assertions.assertThat;

public class ValidateJsonSteps {

    @Autowired
    private Logger logger;

    @Then("the following health check entries are listed:")
    public void allHealthCheckEntriesAreListed(List<Map<String, String>> expectedItems) {

        List<Map<String, String>> actualItems = JsonPath.read(ApiCalls.getResponseBody(), "$.checks");

        logger.info("I check the number of actual health check results is the same as I expect");
        assertThat(expectedItems.size()).withFailMessage("Expected %d health check entries, but found %d", expectedItems.size(), actualItems.size())
                .isEqualTo(actualItems.size());

        logger.info("I check the actual health check results are the ones I expect");
        assertThat(actualItems).containsAll(expectedItems);
    }

    @Then("I verify the following values are present in the response:")
    public void verifyValuesArePresentInTheResponse(List<Map<String, String>> validationItems) {

        logger.info("The following values are present in the response:");

        String responseBody = ApiCalls.getResponseBody();

        // A JSON list starts with a [ character.  If we see that at the start of the
        // body we parse the data into a list of maps.  Otherwise the data is a single
        // entry and can be parsed into a single map.
        if (responseBody.startsWith("[")) {
            verifyListValues(validationItems, responseBody);
        } else {
            verifySingleEntry(validationItems, responseBody);
        }
    }


    @And("I should receive a list of {int} entries")
    public void countSearchResults(int count) {

        logger.info("I should receive {} entries", count);

        List<?> jsonBody = new Gson().fromJson(ApiCalls.getResponseBody(), List.class);
        assertThat(jsonBody).hasSize(count);
    }

    private void verifyListValues(List<Map<String, String>> validationItems, String responseBody) {

        List<Map<String, Object>> jsonBody = new Gson().fromJson(responseBody, List.class);

        // Convert the list of JSON entries into a map keyed on the id column.  In the case
        // where there is a mix of transferred and EDI invoices, an EDI key has 'EDI'
        // appended to it so that is unique.
        Map<String, Map<String, Object>> jsonAsMap = jsonBody.stream().collect(
                Collectors.toMap(m -> {
                    String key = convertIdToString(m);
                    return m.get("ediInvoice").equals("Y") ? key + "EDI" : key;
                }, m -> m)
        );

        validateValues(validationItems, jsonAsMap);
    }

    private void verifySingleEntry(List<Map<String, String>> validationItems, String responseBody) {

        Map<String, Object> jsonBody = new Gson().fromJson(responseBody, Map.class);

        // Flattens the JSON structure into a single map rather than a collection of nested
        // maps.  The key is the path to the value.  Null values are removed.
        // e.g. { "a" : 1, b: [ "c" : 2 ] } is flattened to { "a" : 1, "b.c" : 2 }
        Map<String, Object> flattened = jsonBody.entrySet()
                .stream()
                .flatMap(this::flatten)
                .filter(e -> e.getValue() != null)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        String key = convertIdToString(flattened);

        Map<String, Map<String, Object>> asMap = Collections.singletonMap(key, flattened);

        validateValues(validationItems, asMap);
    }

    private Stream<Map.Entry<String, Object>> flatten(Map.Entry<String, Object> entry) {
        if (entry.getValue() instanceof Map<?, ?>) {
            Map<String, Object> nested = (Map<String, Object>) entry.getValue();

            return nested.entrySet().stream()
                    .map(e -> new AbstractMap.SimpleEntry<>(entry.getKey() + "." + e.getKey(), e.getValue()))
                    .flatMap(this::flatten);
        }

        if (entry.getValue() instanceof List<?>) {
            List<Map<String, Object>> nested = (List<Map<String, Object>>) entry.getValue();

            List<Map.Entry<String, Object>> list = new ArrayList<>();

            // Flatten each list element and give it a unique name based on
            // the index of the element in the list.  For this to work reliably
            // the lists should be ordered in some way.
            IntStream.range(0, nested.size()).forEach(i -> {
                List<Map.Entry<String, Object>> flattenedList =
                        nested.get(i)
                                .entrySet().stream()
                                .map(e -> new AbstractMap.SimpleEntry<>(entry.getKey() + "[" + i + "]." + e.getKey(), e.getValue()))
                                .flatMap(this::flatten)
                                .collect(Collectors.toList());
                list.addAll(flattenedList);
            });

            return list.stream();
        }

        return Stream.of(entry);
    }

    private String convertIdToString(Map<String, Object> map) {
        return String.valueOf(Double.valueOf(String.valueOf(map.get("id"))).longValue());
    }

    private void validateValues(List<Map<String, String>> validationItems, Map<String, Map<String, Object>> responseAsMap) {
        validationItems.forEach(validationItem -> {
            String id = validationItem.get("id");
            String property = validationItem.get("item");
            String expected = validationItem.get("value");

            // Converts the string <null> into an actual null value.  Otherwise cucumber
            // will assume that you want to look for the string "null".
            if (expected.equals("<null>")) {
                expected = null;
            }

            logger.info("\t{}: {} => {}", id, property, expected);

            Map<String, Object> actual = responseAsMap.get(id);
            assertThat(actual).withFailMessage("Invoice %s not found in list of results", id).isNotNull();

            // Allows features to specify the .value string or not.
            // i.e. invoiceNumber and invoiceNumber.value are treated the same.
            Object actualValue = actual.get(property);
            if (actualValue == null) {
                actualValue = actual.get(property + ".value");
            }

            // GSON converts all numbers to be Doubles.  This means if we want an integer
            // we would have to write 1.0 in the feature file to get a match.  This code
            // checks whether the a Double or the Long value match.
            if (actualValue instanceof Double && expected != null) {
                Double asDouble = (Double) actualValue;
                assertThat(asDouble).withFailMessage("The '%s' value in invoice %s is '%s' and should be '%s'", property, id, actualValue, expected)
                        .isEqualByComparingTo(Double.valueOf(expected));
            } else if (actualValue instanceof Boolean && expected != null) {
                assertThat(String.valueOf(actualValue)).withFailMessage("The '%s' value in invoice %s is '%s' and should be '%s'", property, id, actualValue, expected)
                        .isEqualTo(expected);
            } else {
                assertThat(actualValue).withFailMessage("The '%s' value in invoice %s is '%s' and should be '%s'", property, id, actualValue, expected)
                        .isEqualTo(expected);
            }
        });

    }



    @And("The following values for the given search item are present in the response:")
    /*
    The validation items parameter is the table in the feature. The Map<String, String> represents
    the key value pairs of each column header and it value, e.g column 1 header and its value as one pair
    column 2 header and its value and so on. The List<Map> will hold however many columns and rows exist on the table.
    The for (Map<String, String> row : validationItems) is actually a foreach and so is saying for each row in
    validationItems (the table), do this.
    So for a table like this:
     | item           | memberCode                       | value         |
     | memberName     | 113335                           | CDMK NEWS LTD |
    myMap is a new map
    seachTerm is a new string that will look like this[?(@.memberCode == '113335')].memberName
    The two myMap.put() methods will populate the map so that it looks like this:
    [?(@.memberCode == '113335')].memberName, CDMK NEWS LTD
    ApiCalls.getResponseBody() will get the body of the response
    So the map and the response body get passed to the existing  VerifyJson.verifyIndividualJsonItem() method
    */
    public void theFollowingValuesForTheGivenSearchItemArePresentInTheResponse(List<Map<String, String>> validationItems) {
        logger.info("The following values for the given search item are present in the response:");

        for (Map<String, String> row : validationItems) {

            String searchTerm = "[?(@.memberCode == '" + row.get("memberCode") + "')]." + row.get("item");
            Map<String, String> myMap = new HashMap<>();
            myMap.put("item", searchTerm);
            myMap.put("value", row.get("value"));
            VerifyJson.verifyIndividualJsonItem(myMap, ApiCalls.getResponseBody());
        }
    }

    @Given("request body is set to contents of JSON format file: ([^\"]*)$")
    public void requestBodyIsSetToContentsOfJSONFormatFileTestdataSavePayloadsSaveValidTransferredJson(String filepath)
    {
        logger.info("Request Content Type is set to: application/Json");
        ApiCalls.setRequestContentType("application/json");

        logger.info("*** \"request body is set to contents of file: {} ***", filepath);
        String body = FileUtilities.getStringFromResource(filepath);
        ApiCalls.setRequestBody(body);

    }

    /**
     * Verify that the response body of an API call matches the contents of a specified file.
     *
     * @param filePath Path to the verification file . base is the test/resources directory.
     */
    @And("^response body contains items in JSON file ([^\"]*)$")
    public void responseBodyMatchesJsonFile(String filePath) {
        logger.info("*** response body matches Json file {} ***", filePath);
        String expected = FileUtilities.getStringFromResource(filePath);
        expected = DateAdjustment.replaceRelativeDatesInString(expected);
        assertThatJson(ApiCalls.getResponseBody())
                .as("Response body is not as expected")
                .withTolerance(0)
                .when(Option.IGNORING_ARRAY_ORDER)
                .isEqualTo(json(expected));
    }

    @And("The response body contains the following text {string}")
    public void theResponseBodyContainsTheFollowingText(String text)
    {
        Assertions.assertThat(ApiCalls.getResponseBody())
                .as("Response body does not contain expected text"+text)
                .contains(text);

    }

}
