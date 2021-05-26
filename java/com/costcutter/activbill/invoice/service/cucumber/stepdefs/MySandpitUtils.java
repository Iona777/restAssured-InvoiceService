package com.costcutter.activbill.invoice.service.cucumber.stepdefs;

import com.costcutter.cucumber.utils.api.ApiCalls;
import com.costcutter.cucumber.utils.database.DatabaseItems;
import com.costcutter.cucumber.utils.database.MySqlDatabase;
import com.costcutter.cucumber.utils.database.RedshiftDatabase;
import com.costcutter.cucumber.utils.files.FileUtilities;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.jayway.jsonpath.PathNotFoundException;
import io.restassured.path.json.JsonPath;
import org.apache.commons.io.IOUtils;
import org.assertj.core.api.Assertions;
import org.junit.Assert;

import java.io.IOException;
import java.io.InputStream;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.*;

import static org.assertj.core.api.Assertions.fail;

public class MySandpitUtils
{


    /*
    ##### JSON Validation Methods        ###############
     */

    /*
    validationRow is a whole row with headers, e.g.
    | node                   | value   | status | message |
    | header.invoiceNumber   | 1928572 | VALID  | null    |

    keyset, is the set of keys, i.e. the header row, e.g.
    | item                   | value   | status | message |
    */
    public static void myVerifyJsonPathSubItems(Map<String, String> validationRow)
    {
        //Will create a new hashMap containing the path to each subnode in turn and its expected value
        //So in this case we would have:
        //header.invoiceNumber.value,1928572
        //header.invoiceNumber.status,VALID
        //header.invoiceNumber.message,null
        //Each key, value pair will be passed in turn to the verifyAsubNode() method for checking
        //expected value against actual value for each pair.

        Map<String, String> validationSet = new HashMap<>();
        Set<String> keySet = validationRow.keySet();

        //We loop foreach key in key set, so item, value, status, message (and any others that are present)
        //if the key is node then jump over it using the first if()
        for (String key : keySet)
        {
            if (!key.equals("node"))
            {
                //Checks that the contents of the "node" key is not null (header.invoiceNumber in this case)
                if (validationRow.get("node") != null)
                //Then it will put the string "node" and the contents of the "node" key plus "." plus the current key from keyset
                //into the first map entry of the new validationSet map. This is then a path to the subnode
                //e.g. node.header.invoiceNumber.message
                validationSet.put("node", validationRow.get("node") + "." + key);
                else
                    fail("'node' column not found in table");

                //In order to get the expected value for the subnode, it then puts the contents of the current key
                //(e.g. message) for validationRow and puts it into validationMapValue string
                String validationMapValue = validationRow.get(key);

                //Then it puts the string "value" and the contents of validationMapValue into the second map entry
                //of the new validationSet map
                // e.g. for message key it would be
                //value, null
                validationSet.put("value", validationMapValue);

                //It then passes this validationSet map to the verifyIndividualJsonItem() method so it can verify
                //(in this case) that in the response the header.invoiceNumber.value node contains 1928572:
                //It then repeats this for each key in keyset. So, the next one would add an entry in validationSet map of:
                //item, header.invoiceNumber.status
                //value, VALID

                //This method would be called again in each pass of the loop in the calling method
                //FollowingValuesArePresentInTheResponse(), so that the process is repeated for each line in the table

                verifyAsubNode(validationSet, ApiCalls.getResponseBody());
            }
        }
    }


    //Receives a HashMap(node,value pair) in the form of <"node", some content, "value", some content> and  response
    //to search for the node,value pair
    public static void verifyAsubNode(Map<String, String> validationItem, String responseToSearch)
    {
        JsonPath jsp;
        Object nodeObject = null;
        String nodePath;
        String expectedItemValue;
        String actualItemValue;

        //Jsonpath (bit like an xpath for JSON, used to search through the response)
        jsp = new JsonPath(responseToSearch);

        //The value of the 'node' column. this will be a json path like header.invoice
        nodePath = validationItem.get("node");

        //Gets expected value
         expectedItemValue = validationItem.get("value");

        //Gets actual value
        try
        { nodeObject = jsp.get(nodePath);}
        catch (PathNotFoundException e)
        { Assertions.fail("Json item {} not found", nodePath); }

        //Does not work properly if the node = null
        if (nodeObject == null)
            actualItemValue = "null";
        else
            actualItemValue = nodeObject.toString();

        //Could return a boolen and assert at higher level, but just do assert here for now
        Assert.assertEquals("Expected value of node does not match actual",expectedItemValue,actualItemValue);
    }

    /*//This will get the value of the given node from the given response, if response already a string
    public static String getNodeValueFromResponse(String node,String response)
    {
        JsonPath js = new JsonPath(response);
        Object nodeObject = js.get(node);
        if (nodeObject == null)
            return null;
        return nodeObject.toString();
    }

    //This will get the value of the given node from the given response, if response already a string
    public static Object getNodeObjectFromResponse(String node,String response)
    {
        JsonPath js = new JsonPath(response);
        return js.get(node);
    }*/


    /*
    ####### Database Validation Methods ###############
     */

    public static void myExecuteQueryAndStoreResultsInFile(Map<String, String> fileCollection) {

        final String BASEPATH  = "src/test/resources/";
        final String QUERYPATH = fileCollection.get("queryfilepath");
        final String SAVEPATH  = fileCollection.get("savefilepath");

        //extract query from txt file
        String query = extractQueryFromTxtFile(QUERYPATH);

        //execute query
        selectDbAndExecuteQuery(query);

        //delete results files if they exists
        FileUtilities.deleteFileIfItExists(BASEPATH + SAVEPATH);

        //save results to results file
        saveQueryResultsInJsonFile(BASEPATH + SAVEPATH);
    }


    private static String extractQueryFromTxtFile(String filePath) {

        String query = getStringFromResource(filePath);

        return query;
    }


    private static void selectDbAndExecuteQuery(String query)
    {
        //This sets up the connection
        MyDatabaseItems.setDbJdbcConnection();


        //switch (MyDatabaseItems.getDbType()) { //Do my own version later
        switch (MyDatabaseItems.getDbType()) {
            case "MySql":
                mySQLExecuteDbSelectStatement(query);
                break;
            case "RedShift":
                RedshiftDatabase.executeDbSelectStatement(query);
                break;
            default:
                Assertions.fail("Database Type specified (" + DatabaseItems.getDbType() + ") is not recognised");
                break;
        }
        DatabaseItems.closeDbJdbcConnection();
    }


    private static void saveQueryResultsInJsonFile(String filePath) {

        List<Map<String, Object>> queryResults = DatabaseItems.getDbQueryResults();
        Gson gson    = new GsonBuilder().serializeNulls().create();
        JsonArray tableData    = gson.toJsonTree(queryResults).getAsJsonArray();

        try {
            Writer writer = Files.newBufferedWriter(Paths.get(filePath));
            gson.toJson(tableData, writer);
            writer.close();
        } catch (IOException e) {

            Assertions.fail("File system error - saving to file");
        }
    }

    //IS THERE A BETTER WAY OF WRITING THIS??
    public static String getStringFromResource(String resourceFilePath) {

        ClassLoader classLoader = FileUtilities.class.getClassLoader();

        InputStream resourceStream = classLoader.getResourceAsStream(resourceFilePath);
        try {
            return IOUtils.toString(resourceStream, StandardCharsets.UTF_8);
        } catch (IOException e) {

            fail("Failed to read resource document <" + resourceFilePath + ">", e);
        }
        return null;
    }

    public static void mySQLExecuteDbSelectStatement(String dbStatement)
    {
        //Looks like this just checks that the input parameter is not null
        Objects.requireNonNull(dbStatement, "dbStatement must not be null");

        //Java class that represents query results on a database
        ResultSet resultSet = null;

        //PreparedStatement is special type of statement is derived from the more general class, Statement,
        //and it allows you to use parameters. You call it using
        //executeQuery (if it returns one result set. This is the most common situation)
        //executeUpdate  (if it does not return a result set, e.g. such as a SQL UPDATE)
        //execute  (if it might return more than 1 result set )

        //This is a automatic resource statement. The resource declared in try(..) will automatically be closed when
        //no longer required
        try (PreparedStatement preparedStatement =

                //Gets the database connection that was created earlier by MyDatabaseItems.setDbJdbcConnection();
                //called from selectDbAndExecuteQuery()
                     MyDatabaseItems.getDbJdbcConnection().prepareStatement(dbStatement,
                             ResultSet.TYPE_SCROLL_INSENSITIVE,
                             ResultSet.CONCUR_READ_ONLY))

        {
            //Runs the query and puts the results into resultSet variable
            resultSet = preparedStatement.executeQuery();


            //Gets the number of columns returned by the query. This is is used below to set array size
            //and in the while loop
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
            int columnCount = resultSetMetaData.getColumnCount();

            //Don't know what this is for
            resultSet.last();
            resultSet.beforeFirst();

            //Creates a new  list of maps, to represent the query results?
            ArrayList<Map<String, Object>> queryResults = new ArrayList<>(columnCount);

            //Loops through the resultSet and puts each column and its value into the hashMap variable rowResult
            //Looks like the out while loops through the rows and the inner loops through the columns on the row.
            while (resultSet.next())
            {
                int i = 1;
                Map<String, Object> rowResult = new HashMap<>();
                while (i <= columnCount) {
                    rowResult.put(resultSetMetaData.getColumnName(i), resultSet.getString(i));
                    i++;
                }
                //rowResult variable just holds info on the current row of the loop. Each row is aded into turn
                //to queryResult which is a list of maps, so it represents all the rows
                queryResults.add(rowResult);
            }
            //Sets the DatabaseItems class variable queryResults to the queryResults variable set in above code.
            DatabaseItems.setDbQueryResults(queryResults);

        } //End of try section
        catch (SQLException e) {
            //Closes the connection. Not sure if this is really required since the getDbJdbcConnection() method is
            //inside the automatic resource statement in the try()
            DatabaseItems.closeDbJdbcConnection();
            fail("Error occurred executing query");
        }
        finally //Will always execute a finally
        {
            try
            {
                assert resultSet != null;
                resultSet.close();
            }
            catch (SQLException e) {

                DatabaseItems.closeDbJdbcConnection();
            }
        }
    }

    /*
    ####### Database Utility Methods
     */

    //See MyDatabaseItems.java file



}
