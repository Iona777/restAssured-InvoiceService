Feature: 014 Calculate Invoice Header Values on Save

  Background:
    Given  I start a new test
    And  I set oAuth
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


    #NOTE scenarios 02 and 3  will fail if run more than once per data set up
    # This is because the invoice number has to be unique and it will not be on the second run

    #Here we check header values are correct and check DB for retail_amount, discount_type, discount_percent
    #discount_amount, summary_invoice_number, entry_date and generation_type
    #Variations:
    #Discount_type =X, Invoice_status = P, Total_Amount > 0, Create Invoice
  Scenario: 02 - I Call endpoint with Transferred payload with null Id and all VAT Types, Discount Type X - check retail amount etc.
    Given request body is set to contents of file: testdata/calculate/TypeM_Null_IdAllVatTypesDiscType_X.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                    | value         | status | message |
      | header.invoiceNumber    | EPI3659499-A  | VALID  | null    |
      | header.invoiceType      | M             | VALID  | null    |
      | header.invoiceStatus    | P             | VALID  | null    |
      | header.description      | All vat types | VALID  | null    |
      | totals.zeroVatAmount    | 208.00        | VALID  | null    |
      | totals.specialVatAmount | 30.00         | VALID  | null    |
      | totals.stdVatAmount     | 36.00         | VALID  | null    |
      | totals.netAmount        | 274.00        | VALID  | null    |
      | totals.vatAmount        | 8.70          | VALID  | null    |
      | totals.totalAmount      | 282.70        | VALID  | null    |
      | retailer.code           | 102418        | VALID  | null    |
      | supplier.code           | NISA          | VALID  | null    |
    And I run queries and store results:
    #use source root
      | queryfilepath                                            | savefilepath                                                      |
      | testdata/sqlQueries/018_invoice_header_calc_query_01.sql | testdata/sqlActualResults/018_invoice_header_calc_01_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                   | secondfilepath                                                                             |
      | src/test/resources/testdata/sqlExpectedResults/018_invoice_header_calc_01_Expected_results.json | src/test/resources/testdata/sqlActualResults/018_invoice_header_calc_01_results.json |

     #Here we check header values are correct and check DB for retail_amount, discount_type, discount_percent
    #discount_amount, summary_invoice_number, entry_date and generation_type
    #Variations:
    #Discount_type =N, Invoice_status = P, Total_Amount > 0, Create Invoice
  Scenario: 03 - I Call endpoint with Transferred payload with null Id and all VAT Types, Discount Type N - check retail amount etc.
    Given request body is set to contents of file: testdata/calculate/TypeM_Null_IdAllVatTypesDiscType_N.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                    | value         | status | message |
      | header.invoiceNumber    | EPI3659499-B  | VALID  | null    |
      | header.invoiceType      | M             | VALID  | null    |
      | header.invoiceStatus    | P             | VALID  | null    |
      | header.description      | All vat types | VALID  | null    |
      | totals.zeroVatAmount    | 208.00        | VALID  | null    |
      | totals.specialVatAmount | 30.00         | VALID  | null    |
      | totals.stdVatAmount     | 36.00         | VALID  | null    |
      | totals.netAmount        | 274.00        | VALID  | null    |
      | totals.vatAmount        | 8.70          | VALID  | null    |
      | totals.totalAmount      | 282.70        | VALID  | null    |
      | retailer.code           | 102418        | VALID  | null    |
      | supplier.code           | ZCRSH         | VALID  | null    |
    And I run queries and store results:
    #use source root
      | queryfilepath                                            | savefilepath                                                      |
      | testdata/sqlQueries/018_invoice_header_calc_query_02.sql | testdata/sqlActualResults/018_invoice_header_calc_02_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                   | secondfilepath                                                                       |
      | src/test/resources/testdata/sqlExpectedResults/018_invoice_header_calc_02_Expected_results.json | src/test/resources/testdata/sqlActualResults/018_invoice_header_calc_02_results.json |



    #Here we check header values are correct and check DB for retail_amount, discount_type, discount_percent
    #discount_amount, summary_invoice_number, entry_date and generation_type
    #Variations:
    #Discount_type =G, Invoice_status = O, Total_Amount > 0, Save existing invoice
  Scenario: 04 - I Call endpoint with Transferred payload with ID and all VAT Types Discount Type G - check retail amount etc.
    Given request body is set to contents of file: testdata/calculate/TypeI_AllVatTypesDiscType_G.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                    | value         | status | message |
      | header.invoiceNumber    | 1928921       | VALID  | null    |
      | header.invoiceType      | I             | VALID  | null    |
      | header.invoiceStatus    | O             | VALID  | null    |
      | header.description      | All vat types | VALID  | null    |
      | totals.zeroVatAmount    | 48.84         | VALID  | null    |
      | totals.specialVatAmount | 3.85          | VALID  | null    |
      | totals.stdVatAmount     | 9.70          | VALID  | null    |
      | totals.netAmount        | 62.39         | VALID  | null    |
      | totals.vatAmount        | 2.13          | VALID  | null    |
      | totals.totalAmount      | 64.52         | VALID  | null    |
      | retailer.code           | 106162        | VALID  | null    |
      | supplier.code           | ZCRSM         | VALID  | null    |
    And I run queries and store results:
    #use source root
      | queryfilepath                                            | savefilepath                                                      |
      | testdata/sqlQueries/018_invoice_header_calc_query_03.sql | testdata/sqlActualResults/018_invoice_header_calc_03_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                   | secondfilepath                                                                       |
      | src/test/resources/testdata/sqlExpectedResults/018_invoice_header_calc_03_Expected_results.json | src/test/resources/testdata/sqlActualResults/018_invoice_header_calc_03_results.json |



    #Here we check header values are correct and check DB for retail_amount, discount_type, discount_percent
    #discount_amount, summary_invoice_number, entry_date and generation_type
    #Variations:
    #Discount_type =G, Invoice_status = O, Total_Amount < 0, Create invoice
  Scenario: 05 - I Call endpoint with Transferred payload with ID and Total Amount < 0 - check retail amount etc.
    Given request body is set to contents of file: testdata/calculate/TypeI_Null_IdDiscType_G_NegTotal.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                    | value          | status | message |
      | header.invoiceNumber    | 1928921-A      | VALID  | null    |
      | header.invoiceType      | I              | VALID  | null    |
      | header.invoiceStatus    | O              | VALID  | null    |
      | header.description      | Negative total | VALID  | null    |
      | totals.zeroVatAmount    | -1.00          | VALID  | null    |
      | totals.specialVatAmount | 0.00           | VALID  | null    |
      | totals.stdVatAmount     | 0.00           | VALID  | null    |
      | totals.netAmount        | -1.00          | VALID  | null    |
      | totals.vatAmount        | 0.00           | VALID  | null    |
      | totals.totalAmount      | -1.00          | VALID  | null    |
      | retailer.code           | 106162         | VALID  | null    |
      | supplier.code           | ZCRSM          | VALID  | null    |
    And I run queries and store results:
    #use source root
      | queryfilepath                                            | savefilepath                                                      |
      | testdata/sqlQueries/018_invoice_header_calc_query_04.sql | testdata/sqlActualResults/018_invoice_header_calc_04_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                   | secondfilepath                                                                       |
      | src/test/resources/testdata/sqlExpectedResults/018_invoice_header_calc_04_Expected_results.json | src/test/resources/testdata/sqlActualResults/018_invoice_header_calc_04_results.json |


