package com.costcutter.activbill.invoice.service.cucumber.stepdefs;

import com.costcutter.cucumber.utils.database.DatabaseItems;
import com.costcutter.cucumber.utils.files.FileUtilities;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;

import static java.time.format.DateTimeFormatter.ISO_LOCAL_DATE;

public class DatabaseSteps {

    @Value("${db.billing.rw.password}")
    public String password;

    @Value("${db.billing.rw.url}")
    private String url;

    @Value("${db.billing.rw.username}")
    private String username;

    @Autowired
    private Logger logger;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Autowired
    private ExecutorService executorService;

    private static long timer;

    @And("I start a timer")
    public void startTimer() {
        timer = System.currentTimeMillis();
    }

    @And("I stop a timer")
    public void stopTimer() {
        logger.error("Scenario took {}ms", System.currentTimeMillis() - timer);
    }

    @Given("I quickly empty the following tables:")
    public void emptyTables(List<Map<String, String>> tables) {

        logger.info("I empty the following tables:");

        transactionTemplate.execute(status -> {
            jdbcTemplate.execute("set FOREIGN_KEY_CHECKS=0");

            for (Map<String, String> table : tables) {
                String tableName = table.get("table");
                logger.info("\t{}", tableName);
                String query = String.format("truncate table %s", tableName);
                jdbcTemplate.update(query);
            }

            jdbcTemplate.execute("set FOREIGN_KEY_CHECKS=1");

            return null;
        });

    }

    @And("I quickly load table data specified in files:")
    public void loadTableDataSpecifiedInFile(List<Map<String, String>> files) {

        logger.info("I load table data from the following files:");

        List<Future<Object>> futureList = new ArrayList<>();

        Gson gson = new Gson();
        for (Map<String, String> file : files) {

            Future<Object> future = executorService.submit(() -> {
                jdbcTemplate.execute("set FOREIGN_KEY_CHECKS=0");

                String filename = file.get("filepath");
                logger.info("\t{}", filename);

                String jsonString = FileUtilities.getStringFromResource(filename);

                JsonObject jsonObject = gson.fromJson(jsonString, JsonObject.class);
                String table = jsonObject.get("table").getAsString();

                JsonArray tableData = jsonObject.get("tableData").getAsJsonArray();

                List<String> sqlList = new ArrayList<>();
                for (JsonElement itemData : tableData) {
                    String sql = generateInsertStatement(table, itemData);
                    sqlList.add(sql);
                }

                connectPerformInsertUpdateClose(sqlList);

                jdbcTemplate.execute("set FOREIGN_KEY_CHECKS=1");

                return null;
            });

            futureList.add(future);
        }

        for (Future<Object> future : futureList) {
            try {
                future.get();
            } catch (InterruptedException | ExecutionException ex) {
                throw new RuntimeException(ex);
            }
        }
    }

    private String generateInsertStatement(String table, JsonElement itemData) {

        JsonObject asJsonObject = itemData.getAsJsonObject();

        StringBuilder fields = new StringBuilder();
        StringBuilder values = new StringBuilder();

        OffsetDateTime now = OffsetDateTime.now(ZoneOffset.UTC);

        for (Map.Entry<String, JsonElement> entry : asJsonObject.entrySet()) {

            JsonElement node = entry.getValue();

            String nodeName = entry.getKey();
            fields.append(nodeName).append(", ");

            if (node.isJsonNull()) {
                values.append("null").append(", ");
            } else {
                String nodeValue = node.getAsString();

                if ("<<today>>".equals(nodeValue)) {
                    nodeValue = ISO_LOCAL_DATE.format(now);
                } else if (nodeValue.startsWith("'<<today")) {
                    long adjust = Long.parseLong(nodeValue
                                                     .replace("<<today", "")
                                                     .replace(">>", "")
                                                     .trim());
                    nodeValue = ISO_LOCAL_DATE.withZone(ZoneOffset.UTC).format(now.plusDays(adjust));
                }

                values.append("'").append(nodeValue).append("', ");
            }
        }

        fields.setLength(fields.length() - 2);
        values.setLength(values.length() - 2);

        return "INSERT INTO " + table + " (" + fields + ") VALUES (" + values + ")";
    }

    private void connectPerformInsertUpdateClose(List<String> queryList) {
        transactionTemplate.execute(status -> {
            jdbcTemplate.execute("set FOREIGN_KEY_CHECKS=0");
            for (String query : queryList) {
                jdbcTemplate.update(query);
            }
            return null;
        });
    }

    @And("I set dbType")
    public void iSetDbType() {
        DatabaseItems.setDbType("MySql");
    }

    @And("I set connection details to seymour")
    public void iSetConnectionDetailsToSeymour() {
        logger.info("I set connection details to seymour");
        DatabaseItems.setDbType("MySql");
        DatabaseItems.setDbPassword(password);
        DatabaseItems.setDbUri(url);
        DatabaseItems.setDbUsername(username);
    }
}
