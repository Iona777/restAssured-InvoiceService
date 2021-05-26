Feature: 020 Calendar Get Week Details

  Background:
    Given I start a new test
    And I set oAuth
    And I set connection details to seymour


  Scenario: 01 - I setup test data
    Given I quickly empty the following tables:
      | table                         |
      | billing.edi_inv_hdr_vat_rates |
      | billing.edi_invoice_lines     |
      | billing.edi_invoice_headers   |
      | billing.inv_hdr_vat_rates     |
      | billing.invoice_lines         |
      | billing.invoice_headers       |
      | billing.week_numbers          |
      | billing.invoice_statuses      |
      | billing.invoice_types         |
      | billing.vat_rates             |
      | suppliers.suppliers           |
      | franman.franchises            |
      | franman.retail_organisations  |
      | franman.shops                 |
      | franman.addresses             |
      | franman.areas                 |
      | franman.regions               |
      | billing.invoice_groups        |
      | billing.invoice_clerks        |
      | billing.member_invoices       |


    And I quickly load table data specified in files:
      | filepath                                  |
      | testdata/setup/member_invoices.json       |
      | testdata/setup/invoice_clerks.json        |
      | testdata/setup/invoice_groups.json        |
      | testdata/setup/regions.json               |
      | testdata/setup/areas.json                 |
      | testdata/setup/shop_addresses.json        |
      | testdata/setup/shops.json                 |
      | testdata/setup/retail_organisations.json  |
      | testdata/setup/franchises.json            |
      | testdata/setup/suppliers.json             |
      | testdata/setup/vat_rates.json             |
      | testdata/setup/invoice_types.json         |
      | testdata/setup/invoice_statuses.json      |
      | testdata/setup/week_numbers.json          |
      | testdata/setup/invoice_headers.json       |
      | testdata/setup/invoice_lines.json         |
      | testdata/setup/inv_hdr_vat_rates.json     |
      | testdata/setup/edi_invoice_headers.json   |
      | testdata/setup/edi_invoice_lines.json     |
      | testdata/setup/edi_inv_hdr_vat_rates.json |


    And I quickly empty the following tables:
      | table                               |
      | billing.invoice_headers_audit       |
      | billing.invoice_lines_audit         |
      | billing.inv_hdr_vat_rates_audit     |
      | billing.edi_invoice_headers_audit   |
      | billing.edi_invoice_lines_audit     |
      | billing.edi_inv_hdr_vat_rates_audit |


  Scenario: 02 - I get week details for current week (earliest non-closed week) for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/week
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item               | value      |
      | ccPeriod           | 2          |
      | closed             | n          |
      | directDebitDate    | 2021-02-16 |
      | internalCutOffDate | 2021-02-04 |
      | julianPeriod       | 2          |
      | julianYear         | 2021       |
      | taxWeekNumber      | null       |
      | weekEndDate        | 2021-02-05 |
      | weekNumber         | 6          |
      | weekStartDate      | 2021-02-01 |
      | yearNumber         | 2021       |

  Scenario: 03 - I get week details for current week (earliest non-closed week) for user without END_OF_WEEK role
    Given I set OAuth for user testcustsv01
    And I set the query URL to /calendar/year/week
    When I execute the api GET query
    Then I should receive response status code 403

  Scenario: 04 - I get week details for for user without END_OF_WEEK role
    Given I set OAuth for user testcustsv01
    And I set the query URL to /calendar/year/2021/week/21
    When I execute the api GET query
    Then I should receive response status code 403


      #DOUBLE CHECK THESE VALUES AGAINST DB

  Scenario: 05 - I get week details for specific open week for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/2021/week/21
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item               | value      |
      | ccPeriod           | 5          |
      | closed             | n          |
      | directDebitDate    | 2021-06-01 |
      | internalCutOffDate | 2021-05-20 |
      | julianPeriod       | 5          |
      | julianYear         | 2021       |
      | taxWeekNumber      | null       |
      | weekEndDate        | 2021-05-21 |
      | weekNumber         | 21         |
      | weekStartDate      | 2021-05-17 |
      | yearNumber         | 2021       |


  Scenario: 06 - I get week details for specific CLOSED week for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/2021/week/2
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item               | value      |
      | ccPeriod           | 1          |
      | closed             | y          |
      | directDebitDate    | 2021-01-19 |
      | internalCutOffDate | 2021-01-07 |
      | julianPeriod       | 1          |
      | julianYear         | 2021       |
      | taxWeekNumber      | null       |
      | weekEndDate        | 2021-01-08 |
      | weekNumber         | 2          |
      | weekStartDate      | 2021-01-04 |
      | yearNumber         | 2021       |


    # add in validation tests here
    Scenario: 07 - Set invalid cutoff date - week does not exist - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/2020/week/12
    When I execute the api GET query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | WEEK_NOT_FOUND                      |
      | message   | Week {12} not found for year {2020} |


  Scenario: 08 - Set invalid cutoff date - year does not exist - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/2019/week/12
    When I execute the api GET query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | WEEK_NOT_FOUND                      |
      | message   | Week {12} not found for year {2019} |

  Scenario: 09 - Set invalid cutoff date - week is blank - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/2021/week/
    When I execute the api GET query
    Then I should receive response status code 404

  Scenario: 10 - Set invalid cutoff date - year is blank - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year//week/21
    When I execute the api GET query
    Then I should receive response status code 404

  Scenario: 10 - Set invalid cutoff date - year is space - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    #Need to replace the space with %20
    And I set the query URL to /calendar/year/%20/week/21
    When I execute the api GET query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |

  Scenario: 11 - Set invalid cutoff date - week NaN - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/2021/week/abc
    When I execute the api GET query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |
    
  Scenario: 11 - Set invalid cutoff date - year NaN - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And I set the query URL to /calendar/year/abc/week/21
    When I execute the api GET query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |


  

  

  