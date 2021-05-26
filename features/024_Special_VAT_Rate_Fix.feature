Feature: 024 Special VAT Rate Fix

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

    Scenario: 02 - Amend special VAT rate - calculateLine = True - 1 product line with vat code = Q
      Given Request Content Type is set to: application/json
      And request body is set to contents of file: testdata/savePayloads/specialVatRates/save1LineCalcTrue.json
      And I set the query URL to /invoice/
      #Check there is a special VAT rate of Q set up for 1 line on this invoice
      And I run queries and store results:
      #Use source root
        | queryfilepath                                      | savefilepath                                                |
        | testdata/sqlQueries/024_specialVatRate_query01.sql | testdata/sqlActualResults/024_specialVatRate_results01A.json |
        | testdata/sqlQueries/024_specialVatRate_query02.sql | testdata/sqlActualResults/024_specialVatRate_results02A.json |
      Then I compare JSON files:
      #use repository root
        | firstfilepath                                                                             | secondfilepath                                                                 |
        | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results01A.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results01A.json |
        | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results02A.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results02A.json |
      #Change the special VAT rate to S for one line
      When I execute the api POST query
      Then I should receive response status code 201
      #Check that Q line has been removed from inv_hdr_vat_rate table and entry on invoice_lines updated (vatPercent & vatCode only)
      And I run queries and store results:
      #Use source root
        | queryfilepath                                      | savefilepath                                                |
        | testdata/sqlQueries/024_specialVatRate_query01.sql | testdata/sqlActualResults/024_specialVatRate_results01B.json |
        | testdata/sqlQueries/024_specialVatRate_query02.sql | testdata/sqlActualResults/024_specialVatRate_results02B.json |
      Then I compare JSON files:
      #use repository root
      # expected data for query1 is now no rows. Nothing to export so what should expected results be? Just {} ?
        | firstfilepath                                                                             | secondfilepath                                                                 |
        | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results01B.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results01B.json |
        | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results02B.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results02B.json |


  Scenario: 03 - Amend special VAT rate - calculateLine = True - 2 product lines with vat code = Q
    Given Request Content Type is set to: application/json
    And request body is set to contents of file: testdata/savePayloads/specialVatRates/save2LineCalcTrue.json
    And I set the query URL to /invoice/
      #Check there is a special VAT rate of Q set up for 2 lines on this invoice
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                 |
      | testdata/sqlQueries/024_specialVatRate_query03.sql | testdata/sqlActualResults/024_specialVatRate_results03A.json |
      | testdata/sqlQueries/024_specialVatRate_query04.sql | testdata/sqlActualResults/024_specialVatRate_results04A.json |
    Then I compare JSON files:
      #use repository root
      | firstfilepath                                                                              | secondfilepath                                                                  |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results03A.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results03A.json |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results04A.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results04A.json |
      #Change the special VAT rate to S for one line
    When I execute the api POST query
    Then I should receive response status code 201
      #Check that Q line has been removed from inv_hdr_vat_rate table and entry on invoice_lines updated (vatPercent & vatCode only)
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                 |
      | testdata/sqlQueries/024_specialVatRate_query03.sql | testdata/sqlActualResults/024_specialVatRate_results03B.json |
      | testdata/sqlQueries/024_specialVatRate_query04.sql | testdata/sqlActualResults/024_specialVatRate_results04B.json |
    Then I compare JSON files:
      #use repository root
      # expected data for query1 is now no rows. Nothing to export so what should expected results be? Just {} ?
      | firstfilepath                                                                              | secondfilepath                                                                  |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results03B.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results03B.json |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results04B.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results04B.json |


  Scenario: 04 - No special VAT rate - calculateLine = True - inv_hdr_vat_rates table not updated
    Given Request Content Type is set to: application/json
    And request body is set to contents of file: testdata/savePayloads/specialVatRates/saveNoQCodeSetUpCalcTrue.json
    And I set the query URL to /invoice/
      #Attempt to post a special VAT rate of Q
    When I execute the api POST query
    Then I should receive response status code 400
      #Check that Q line has NOt been added to inv_hdr_vat_rate table and entry on invoice_lines updated (vatPercent & vatCode only)
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                 |
      | testdata/sqlQueries/024_specialVatRate_query05.sql | testdata/sqlActualResults/024_specialVatRate_results05.json |
    Then I compare JSON files:
      #use repository root
      # expected data for query1 is now no rows. Nothing to export so what should expected results be? Just {} ?
      | firstfilepath                                                                              | secondfilepath                                                                  |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results05.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results05.json |


  Scenario: 05 - Amend special VAT rate - calculateLine = False - 1 product line with vat code = Q
    Given Request Content Type is set to: application/json
    And request body is set to contents of file: testdata/savePayloads/specialVatRates/save1LineCalcFalse.json
    And I set the query URL to /invoice/
      #Check there is a special VAT rate of Q set up for 1 line on this invoice
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                |
      | testdata/sqlQueries/024_specialVatRate_query06.sql | testdata/sqlActualResults/024_specialVatRate_results06A.json |
      | testdata/sqlQueries/024_specialVatRate_query07.sql | testdata/sqlActualResults/024_specialVatRate_results07A.json |
    Then I compare JSON files:
      #use repository root
      | firstfilepath                                                                             | secondfilepath                                                                 |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results06A.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results06A.json |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results07A.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results07A.json |
      #Change the special VAT rate to S for one line
    When I execute the api POST query
    Then I should receive response status code 201
      #Check that Q line has been removed from inv_hdr_vat_rate table and entry on invoice_lines updated (vatPercent & vatCode only)
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                |
      | testdata/sqlQueries/024_specialVatRate_query06.sql | testdata/sqlActualResults/024_specialVatRate_results06B.json |
      | testdata/sqlQueries/024_specialVatRate_query07.sql | testdata/sqlActualResults/024_specialVatRate_results07B.json |
    Then I compare JSON files:
      #use repository root
      # expected data for query1 is now no rows. Nothing to export so what should expected results be? Just {} ?
      | firstfilepath                                                                             | secondfilepath                                                                 |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results06B.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results06B.json |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results07B.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results07B.json |

  Scenario: 06 - No special VAT rate - calculateLine = False - inv_hdr_vat_rates table not updated
    Given Request Content Type is set to: application/json
    And request body is set to contents of file: testdata/savePayloads/specialVatRates/save1LineCalcFalse.json
    And I set the query URL to /invoice/
      #Attempt to post a special VAT rate of Q
    When I execute the api POST query
    Then I should receive response status code 201
      #Check that Q line has NOt been added to inv_hdr_vat_rate table and entry on invoice_lines updated (vatPercent & vatCode only)
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                |
      | testdata/sqlQueries/024_specialVatRate_query08.sql | testdata/sqlActualResults/024_specialVatRate_results08.json |
    Then I compare JSON files:
      #use repository root
      # expected data for query1 is now no rows. Nothing to export so what should expected results be? Just {} ?
      | firstfilepath                                                                             | secondfilepath                                                                 |
      | src/test/resources/testdata/sqlExpectedResults/024_specialVatRate_Expected_results08.json | src/test/resources/testdata/sqlActualResults/024_specialVatRate_results08.json |


Scenario: 7 - Get totals.specialVatAmount from  inv_hdr_vat_rates.spec_vat_amount
  Given I set the query URL to /invoice/105
  When I execute the api GET query
  Then I should receive response status code 200
  And The following JSON values are present in the response:
    | item                    | value |
    | totals.specialVatAmount | 400   |
