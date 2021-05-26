Feature: 027 Auddis Report

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
      | billing.fee_types             |
      | billing.auddis_history        |


    And I quickly load table data specified in files:
      | filepath                                  |
      | testdata/setup/auddis_history.json        |
      | testdata/setup/fee_types.json             |
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
    
    Scenario: 02 - Generate Auddis Report
      Given I set OAuth for user testcrcont01
      And I set the query URL to /directdebitreport

      #Check initial status of auddis_history table
      ### Had to add auddis_history table to datasource. Will that cause problems? ###
      And I run queries and store results:
      #use source root
        | queryfilepath                                   | savefilepath                                               |
        | testdata/sqlQueries/026_auddis_Report_query.sql | testdata/sqlActualResults/026_auddis_Report_results01.json |
      And I compare JSON files:
      #Use repository root
        | firstfilepath                                                                            | secondfilepath                                                                |
        | src/test/resources/testdata/sqlExpectedResults/026_auddis_report_Expected_results01.json | src/test/resources/testdata/sqlActualResults/026_auddis_Report_results01.json |

      And I execute the api POST query
      Then I should receive response status code 200
      And The response body contains the following text "104191EBOR COSTCUTTER SUPERMARKET GRO01709097 40-23-12             0 0N"
      And The response body contains the following text "33555XEBOR COSTCUTTER SUPERMARKET GRO01709097 40-23-12             0 0N"

      #Check auddis_history table updated - guid changed on one row and another row added as it is present on
      #franman.franchises but not on auddis_history. Replicates one account be amended a new one being created
      And I run queries and store results:
      #Use source root
        | queryfilepath                                   | savefilepath                                               |
        | testdata/sqlQueries/026_auddis_Report_query.sql | testdata/sqlActualResults/026_auddis_Report_results02.json |
      And I compare JSON files:
      #Use repository root
        | firstfilepath                                                                            | secondfilepath                                                                |
        | src/test/resources/testdata/sqlExpectedResults/026_auddis_report_Expected_results02.json | src/test/resources/testdata/sqlActualResults/026_auddis_Report_results02.json |
