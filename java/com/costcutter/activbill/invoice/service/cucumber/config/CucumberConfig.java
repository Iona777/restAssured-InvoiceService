package com.costcutter.activbill.invoice.service.cucumber.config;

import com.cc.rest.exception.ExceptionRestTemplate;
import com.mysql.jdbc.Driver;
import org.apache.tomcat.jdbc.pool.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.client.RestTemplate;

import java.time.Clock;
import java.time.ZoneId;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Configuration
@ComponentScan({"com.costcutter.activbill.invoice.service.cucumber", "com.costcutter.cucumber.utils"})
@PropertySource(ignoreResourceNotFound = true,
                value = "${properties.path}/activbill-invoice-service-cucumber.properties")
public class CucumberConfig {

    @Value("${db.billing.rw.password}")
    private String password;

    @Value("${db.billing.rw.url}")
    private String url;

    @Value("${db.billing.rw.username}")
    private String username;

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    @Bean
    public Clock clock() {
        return Clock.system(ZoneId.of("GMT"));
    }

    @Bean
    public DataSource dataSource() {
        DataSource dataSource = new DataSource();
        dataSource.setDriverClassName(Driver.class.getName());
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        dataSource.setDefaultReadOnly(Boolean.FALSE);
        return dataSource;
    }

    @Bean(destroyMethod = "shutdown")
    public ExecutorService executorService(DataSource dataSource) {
        return Executors.newFixedThreadPool(dataSource.getMaxActive());
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean
    public TransactionTemplate transactionTemplate(PlatformTransactionManager transactionManager) {
        return new TransactionTemplate(transactionManager);
    }

    @Bean
    public RestTemplate restTemplate() {
        return ExceptionRestTemplate.getRestTemplate("activbill-invoice-service-cucumber");
    }

    @Bean
    public Logger logger() {
        return LoggerFactory.getLogger("activbill-invoice-service-cucumber");
    }
}
