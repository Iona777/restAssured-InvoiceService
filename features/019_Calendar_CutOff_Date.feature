Feature: 019 Calendar CutOff Date
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


  Scenario: 02 - Set valid cutoff date for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/validCutOffDate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 200
    When I run queries and store results:
       #use source root
      | queryfilepath                                     | savefilepath                                               |
      | testdata/sqlQueries/019_validCutOffDate_query.sql | testdata/sqlActualResults/019_validCutOffDate_results.json |
    #use repostitory root
    Then I compare JSON files:
      | firstfilepath                                                                            | secondfilepath                                                                |
      | src/test/resources/testdata/sqlExpectedResults/019_validCutOffDate_Expected_results.json | src/test/resources/testdata/sqlActualResults/019_validCutOffDate_results.json |


  Scenario: 03 - Set valid cutoff date in future for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/validCutOffDate_future.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 200
    When I run queries and store results:
       #use source root
      | queryfilepath                                      | savefilepath                                                |
      | testdata/sqlQueries/019A_validCutOffDate_query.sql | testdata/sqlActualResults/019A_validCutOffDate_results.json |
    #use repostitory root
    Then I compare JSON files:
      | firstfilepath                                                                             | secondfilepath                                                                 |
      | src/test/resources/testdata/sqlExpectedResults/019A_validCutOffDate_Expected_results.json | src/test/resources/testdata/sqlActualResults/019A_validCutOffDate_results.json |



  Scenario: 04 - Set valid cutoff date for user without END_OF_WEEK role
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/calendar/validCutOffDate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 403


  Scenario: 05 - Set valid cutoff date for super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/calendar/validCutOffDate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 06 - Set invalid cutoff date - week already closed - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_WeekAlreadyClosed.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 403
    And The following JSON values are present in the response:
      | item      | value                     |
      | errorCode | WEEK_CLOSED               |
      | message   | Cannot edit a closed week |

  Scenario: 07 - Set invalid cutoff date - week does not exist - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_WeekDoesNotExist.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                              |
      | errorCode | WEEK_NOT_FOUND                     |
      | message   | Week {1} not found for year {2020} |


  Scenario: 08 - Set invalid cutoff date - year does not exist - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_YearDoesNotExist.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                              |
      | errorCode | WEEK_NOT_FOUND                     |
      | message   | Week {21} not found for year {21}   |

  Scenario: 09 - Set invalid cutoff date - week is blank - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_WeekIsBlank.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                                 |
      | errorCode | WEEK_NOT_FOUND                        |
      | message   | Week {null} not found for year {2021} |

  Scenario: 10 - Set invalid cutoff date - year is blank - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_YearIsBlank.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                                 |
      | errorCode | WEEK_NOT_FOUND                        |
      | message   | Week {21} not found for year {null}   |


  Scenario: 11 - Set invalid cutoff date - week NaN - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_WeekNaN.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | 207                                 |
      | message   | HTTP message not readable exception |


  Scenario: 12 - Set invalid cutoff date - date format wrong - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_DateFormatWrong.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | 207                                 |
      | message   | HTTP message not readable exception |

  Scenario: 13 - Set invalid cutoff date - date 29 Feb 2021 - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_Date29Feb.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | 207                                 |
      | message   | HTTP message not readable exception |


  Scenario: 14 - Set invalid cutoff date - blank date - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_BlankDate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                 |
      | errorCode | 305                   |
      | message   | Cutoff cannot be null |

  Scenario: 15 - Set invalid cutoff date - null date - for user with END_OF_WEEK role
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/calendar/invalidCutOffDate_NullDate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/cutoff
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                 |
      | errorCode | 305                   |
      | message   | Cutoff cannot be null |

