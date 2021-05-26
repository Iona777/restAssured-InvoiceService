@000
Feature: 000 Healthcheck endpoint

  Background:
    Given I start a new test
    And  I set oAuth


  Scenario: 01 - Health check endpoint returns valid information
    When I query GET endpoint "/health"
    Then I should receive response status code 200
    And Status returned will be OK
    And the following health check entries are listed:
      | name                                           | status |
      | database 1                                     | OK     |
      | [GET] /health                                  | OK     |
      | [DELETE] /invoice/{type}/delete/{id}           | OK     |
      | [DELETE] /invoice/delete/{id}                  | OK     |
      | [POST] /invoice/{type}                         | OK     |
      | [PUT] /invoice/{type}                          | OK     |
      | [POST] /invoice                                | OK     |
      | [PUT] /invoice                                 | OK     |
      | [POST] /validate/{type}/supplier               | OK     |
      | [POST] /validate/supplier                      | OK     |
      | [POST] /validate/{type}/header                 | OK     |
      | [POST] /validate/header                        | OK     |
      | [POST] /validate/{type}/line                   | OK     |
      | [POST] /validate/line                          | OK     |
      | [POST] /validate/invoice                       | OK     |
      | [POST] /validate/{type}/invoice                | OK     |
      | [POST] /validate/{type}/retailer               | OK     |
      | [POST] /validate/retailer                      | OK     |
      | [GET] /invoice/{id}                            | OK     |
      | [GET] /invoice/{type}/{id}                     | OK     |
      | [GET] /invoice/blank                           | OK     |
      | [GET] /search/member                           | OK     |
      | [GET] /search/invoice                          | OK     |
      | [GET] /user/details                            | OK     |
      | [POST] /calendar/cutoff                        | OK     |
      | [GET] /calendar/year/{year}/week/{week}        | OK     |
      | [GET] /calendar/year/week                      | OK     |
      | [POST] /calendar/year/{year}/week/{week}/close | OK     |
      | [GET] /fees/types/list                         | OK     |
      | [GET] /regions/list                            | OK     |
      | [POST] /directdebitreport                      | OK     |
      | [GET] /directdebitchanges                      | OK     |
      | [GET] /v2/api-docs                             | OK     |


