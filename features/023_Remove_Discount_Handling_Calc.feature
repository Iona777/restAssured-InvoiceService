Feature: 023 Remove Discount Handling Calculation

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

    Scenario: 02 - Check discount not updated for Transferred invoice Type E
      Given request body is set to contents of file: testdata/savePayloads/savediscountAmt_TypeE.json
      And Request Content Type is set to: application/json
      #Check value of discount_amount field on invoice headers table for the invoice.
      And I run queries and store results:
      #Use source root
        | queryfilepath                                    | savefilepath                                              |
        | testdata/sqlQueries/023_discountAmount_query01.sql | testdata/sqlActualResults/023_discountAmount_results_01A.json |
      Then I compare JSON files:
      #use repository root
        | firstfilepath                                                                           | secondfilepath                                                               |
        | src/test/resources/testdata/sqlExpectedResults/023_discountAmount_Expected_results01.json | src/test/resources/testdata/sqlActualResults/023_discountAmount_results_01A.json |
      #Save that invoice, ensuring that there is some discount on one or more lines, such that the total is different to the amount above.
      And I set the query URL to /invoice/
      When I execute the api POST query
      Then I should receive response status code 201
      #Check value of discount_amount field has not changed.
      And I run queries and store results:
      #Use source root
        | queryfilepath                                    | savefilepath                                              |
        | testdata/sqlQueries/023_discountAmount_query01.sql | testdata/sqlActualResults/023_discountAmount_results_01B.json |
      Then I compare JSON files:
      #use repository root
        | firstfilepath                                                                           | secondfilepath                                                               |
        | src/test/resources/testdata/sqlExpectedResults/023_discountAmount_Expected_results01.json | src/test/resources/testdata/sqlActualResults/023_discountAmount_results_01B.json |


  Scenario: 03 - Check discount not updated for Transferred invoice Type I
    Given request body is set to contents of file: testdata/savePayloads/savediscountAmt_TypeI.json
    And Request Content Type is set to: application/json
      #Check value of discount_amount field on invoice headers table for the invoice.
    And I run queries and store results:
      #Use source root
      | queryfilepath                                    | savefilepath                                              |
      | testdata/sqlQueries/023_discountAmount_query02.sql | testdata/sqlActualResults/023_discountAmount_results_02A.json |
    Then I compare JSON files:
      #use repository root
      | firstfilepath                                                                           | secondfilepath                                                               |
      | src/test/resources/testdata/sqlExpectedResults/023_discountAmount_Expected_results02.json | src/test/resources/testdata/sqlActualResults/023_discountAmount_results_02A.json |
      #Save that invoice, ensuring that there is some discount on one or more lines, such that the total is different to the amount above.
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
      #Check value of discount_amount field has not changed.
    And I run queries and store results:
      #Use source root
      | queryfilepath                                    | savefilepath                                              |
      | testdata/sqlQueries/023_discountAmount_query02.sql | testdata/sqlActualResults/023_discountAmount_results_02B.json |
    Then I compare JSON files:
      #use repository root
      | firstfilepath                                                                           | secondfilepath                                                               |
      | src/test/resources/testdata/sqlExpectedResults/023_discountAmount_Expected_results02.json | src/test/resources/testdata/sqlActualResults/023_discountAmount_results_02B.json |


  Scenario: 04 - Check discount not updated for Transferred invoice Type M
    Given request body is set to contents of file: testdata/savePayloads/savediscountAmt_TypeM.json
    And Request Content Type is set to: application/json
      #Check value of discount_amount field on invoice headers table for the invoice.
    And I run queries and store results:
      #Use source root
      | queryfilepath                                    | savefilepath                                              |
      | testdata/sqlQueries/023_discountAmount_query03.sql | testdata/sqlActualResults/023_discountAmount_results_03A.json |
    Then I compare JSON files:
      #use repository root
      | firstfilepath                                                                           | secondfilepath                                                               |
      | src/test/resources/testdata/sqlExpectedResults/023_discountAmount_Expected_results03.json | src/test/resources/testdata/sqlActualResults/023_discountAmount_results_03A.json |
      #Save that invoice, ensuring that there is some discount on one or more lines, such that the total is different to the amount above.
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
      #Check value of discount_amount field has not changed.
    And I run queries and store results:
      #Use source root
      | queryfilepath                                      | savefilepath                                                 |
      | testdata/sqlQueries/023_discountAmount_query03.sql | testdata/sqlActualResults/023_discountAmount_results_03B.json |
    Then I compare JSON files:
      #use repository root
      | firstfilepath                                                                             | secondfilepath                                                                   |
      | src/test/resources/testdata/sqlExpectedResults/023_discountAmount_Expected_results03.json | src/test/resources/testdata/sqlActualResults/023_discountAmount_results_03B.json |





#DO THE SAME AS ABOVE FOR TRANSFERRED INVOICE WITH INVOICE_TYPE = M
  # Use this SQL to find suitable invoice - 1401202162863RM  - Id 160



  #Change the discount amount and save as testdata/savePayloads/savediscountAmt_TypeM.json (note change in file name
  #from TypeI to TypeM)
  #Use SQL from 023_discountAmount_query02.sql, changed invoice number and save as 023_discountAmount_query03.sql
  #Run query and store the output in 023_discountAmount_Expected_results03.json (notice increment file name from 02 to 03)
  #Can use same filename or actual results as in other scenarios as it (should) get overwritten




