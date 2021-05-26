package com.costcutter.activbill.invoice.service.cucumber.stepdefs;

import com.costcutter.cucumber.utils.api.ApiCalls;
import com.costcutter.cucumber.utils.database.DatabaseUtilities;
import com.costcutter.cucumber.utils.files.FileUtilities;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import org.apache.commons.io.IOUtils;

import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import static com.costcutter.cucumber.utils.json.VerifyJson.verifyJsonPathSubItems;
import static org.assertj.core.api.Assertions.fail;

public class MySandpitSteps
{
    @And("The following values are checked using hashmap:")
    public void theFollowingValuesAreCheckedUsingHashmap(List<Map<String, String>> validationItems)
    {
        //Takes a list of hashmaps as input parameter.
        //The represents a table. The map representing a series of  column header, value pairs and each line
        //represented by a new list item
        for (Map<String, String> validationRow : validationItems)
        {
            MySandpitUtils.myVerifyJsonPathSubItems(validationRow);
        }
    }


    @When("I runs SQL query and save results:")
    public void iRunsSQLQueryAndSaveResults(List<Map<String, String>> fileCollections)
    {
        for (Map<String, String> fileCollection: fileCollections) {
            MySandpitUtils.myExecuteQueryAndStoreResultsInFile(fileCollection);
        }
    }
}
