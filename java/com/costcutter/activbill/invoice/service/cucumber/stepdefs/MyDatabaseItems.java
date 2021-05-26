package com.costcutter.activbill.invoice.service.cucumber.stepdefs;

//package com.costcutter.cucumber.utils.database; - old package location

import com.costcutter.cucumber.utils.database.DatabaseUtilities;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Used to store generic database items
 */
@Component
public final class MyDatabaseItems
{

    private static volatile String                    dbPassword;
    private static volatile String                    dbType;
    private static volatile String                    dbUri;
    private static volatile String                    dbUsername;
    private static volatile Connection                jdbcConnection;
    private static volatile List<Map<String, Object>> queryResults;

    //The class constructor, is it really required if blank?
    private MyDatabaseItems()
    {}

    public static Connection getDbJdbcConnection() {
        return jdbcConnection;
    }

    public static String getDbPassword() {
        return dbPassword;
    }

    public static void setDbPassword(String password) {
        dbPassword = password;
    }

    public static String getDbType() {
        return dbType;
    }

    public static void setDbType(String type) {
        dbType = type;
    }

    public static String getDbUri() {
        return dbUri;
    }

    public static void setDbUri(String uri) {
        dbUri = uri;
    }

    public static String getDbUsername() {
        return dbUsername;
    }

    public static void setDbUsername(String username) {
        dbUsername = username;
    }

    /**
     * Open a Jdbc connection using the set configuration items.
     */
    public static void setDbJdbcConnection() {

        if (jdbcConnection != null) {
            DatabaseUtilities.closeJdbcConnection(jdbcConnection);
        }

        jdbcConnection = DatabaseUtilities
                .openJdbcConnection(
                        com.costcutter.cucumber.utils.database.DatabaseItems.getDbType(),
                        com.costcutter.cucumber.utils.database.DatabaseItems.getDbUri(),
                        com.costcutter.cucumber.utils.database.DatabaseItems.getDbUsername(),
                        com.costcutter.cucumber.utils.database.DatabaseItems.getDbPassword()
                );
    }

    /**
     * Close the currently established database connection.
     */
    public static void closeDbJdbcConnection() {
        jdbcConnection = DatabaseUtilities.closeJdbcConnection(jdbcConnection);
    }

    public static List<Map<String, Object>> getDbQueryResults() {
        return new ArrayList<>(queryResults);
    }

    public static void setDbQueryResults(List<Map<String, Object>> queryResultsToSet) {
        queryResults = new ArrayList<>(queryResultsToSet);
    }

}

