Feature: 021 Close week
  Background:
    Given I start a new test
    And I set oAuth
    And I set connection details to seymour
    And I create directory "src/test/resources/testdata/sqlActualResults"

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

  Scenario: 02 - Invoices for specified week that have a summary invoice, user has END_OF_WEEK role
    Given I set OAuth for user testinv01
    #Check the initial condition of the invoice, with status = P ,associated with week to be closed
    And I set the query URL to /invoice/42
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value      |
      | header.weekClosed          | false      |
      | header.invoiceNumber.value | EPI3659782 |
      | header.invoiceStatus.value | P          |
     #Check the initial condition of the invoice, with status = O ,associated with week to be closed
    And I set the query URL to /invoice/1
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value      |
      | header.weekClosed          | false      |
      | header.invoiceNumber.value | EPI3662277 |
      | header.invoiceStatus.value | O          |
    #Close the week
    Given Request Content Type is set to: application/json
    And I set the query URL to /calendar/year/2021/week/50/close
    When I execute the api POST query
    Then I should receive response status code 200
  #Check the final condition of the invoice, with status = P ,associated with week to be closed
    And I set the query URL to /invoice/42
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value      |
      | header.weekClosed          | true       |
      | header.invoiceNumber.value | EPI3659782 |
      | header.invoiceStatus.value | O          |
  #Check the final condition of the invoice, with status = O ,associated with week to be closed
    And I set the query URL to /invoice/1
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value      |
      | header.weekClosed          | true      |
      | header.invoiceNumber.value | EPI3662277 |
      | header.invoiceStatus.value | O          |
    #Check that Ebor VAT contra invoices written to DB
    And I run queries and store results:
    #user source root
      | queryfilepath                                       | savefilepath                                                 |
      | testdata/sqlQueries/025_ebor_vat_contra_query01.sql | testdata/sqlActualResults/025_ebor_vat_contra_results01.json |
      | testdata/sqlQueries/025_ebor_vat_contra_query02.sql | testdata/sqlActualResults/025_ebor_vat_contra_results02.json |
    Then I compare JSON files:
    #user repository root
      | firstfilepath                                                                              | secondfilepath                                                                    |
      | src/test/resources/testdata/sqlExpectedResults/025_ebor_vat_contra_Expected_results01.json | src/test/resources/testdata/sqlActualResults/025_ebor_vat_contra_results01.json |
      | src/test/resources/testdata/sqlExpectedResults/025_ebor_vat_contra_Expected_results02.json | src/test/resources/testdata/sqlActualResults/025_ebor_vat_contra_results02.json |


    Scenario: 03: Cannot close Invoices for specified week if week already closed
      Given Request Content Type is set to: application/json
      And I set the query URL to /calendar/year/2021/week/3/close
      When I execute the api POST query
      Then I should receive response status code 403
      And The following JSON values are present in the response:
        | item      | value                     |
        | errorCode | WEEK_CLOSED               |
        | message   | Cannot edit a closed week |

    Scenario: 04 - Invoices for specified week with status = P, do NOT have a summary invoice, user has END_OF_WEEK role
      Given I set OAuth for user testinv01
      And Request Content Type is set to: application/json
      And I set the query URL to /calendar/year/2021/week/49/close
      When I execute the api POST query
      Then I should receive response status code 409
      And The following JSON values are present in the response:
        | item              | value      |
        | [0].id            | 40         |
        | [0].invoiceNumber | EPI3659272 |


  Scenario: 05 - Cannot close Invoices for specified week if user does NOT have END_OF_WEEK role
    Given I set OAuth for user testcustsv01
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/year/2021/week/50/close
    When I execute the api POST query
    Then I should receive response status code 403
    And The following JSON values are present in the response:
      | item      | value                                                                         |
      | errorCode | 202                                                                           |
      | message   | Privilege error - User profile does not have admin privilege for this action. |

  Scenario: 06 - Cannot close Invoices for specified week if week does not exist
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/year/2020/week/50/close
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | WEEK_NOT_FOUND                      |
      | message   | Week {50} not found for year {2020} |

  Scenario: 07 - Cannot close Invoices for specified week if year does not exist
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/year/2010/week/50/close
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | WEEK_NOT_FOUND                      |
      | message   | Week {50} not found for year {2010} |


  Scenario: 08 - Cannot close Invoices for specified week if week is blank
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    #Need to replace the space with %20
    And I set the query URL to /calendar/year/2021/week/%20/close
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |


  Scenario: 09 - Cannot close Invoices for specified week if year is blank
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    #Need to replace the space with %20
    And I set the query URL to /calendar/year/%20/week/50/close
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |


  Scenario: 10 - Cannot close Invoices for specified week if week is NaN
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/year/2021/week/abc/close
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |


  Scenario: 11 - Cannot close Invoices for specified week if year is NaN
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    And I set the query URL to /calendar/year/abc/week/50/close
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                            |
      | errorCode | 206                              |
      | message   | Argument type mismatch exception |