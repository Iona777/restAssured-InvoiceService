Feature: 999 My Sandpit

  Background:
    Given  I start a new test
    And  I set oAuth
    And I set connection details to seymour

  Scenario: 01 - I setup test data
    Given I quickly empty the following tables:
      | table                         |
      | billing.edi_inv_hdr_vat_rates       |
      | billing.edi_invoice_lines           |
      | billing.edi_invoice_headers         |
      | billing.inv_hdr_vat_rates           |
      | billing.invoice_lines               |
      | billing.invoice_headers             |
      | billing.week_numbers                |
      | billing.invoice_statuses            |
      | billing.invoice_types               |
      | billing.vat_rates                   |
      | suppliers.suppliers                 |
      | franman.franchises                  |
      | franman.retail_organisations        |
      | franman.shops                       |
      | franman.addresses                   |
      | franman.areas                       |
      | franman.regions                     |
      | billing.invoice_groups              |
      | billing.invoice_clerks              |
      | billing.member_invoices             |


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
      | table                         |
      | billing.invoice_headers_audit       |
      | billing.invoice_lines_audit         |
      | billing.inv_hdr_vat_rates_audit     |
      | billing.edi_invoice_headers_audit   |
      | billing.edi_invoice_lines_audit     |
      | billing.edi_inv_hdr_vat_rates_audit |

  Scenario: 02 - I Call endpoint with Transferred payload with only 1 line
    Given request body is set to contents of file: testdata/validate/full_Invoice/InvoiceWithSingleLine.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are checked using hashmap:
      | node                 | value   | status | message |
      | header.invoiceNumber | 1928940 | VALID  | null    |
      | header.invoiceType   | I       | VALID  | null    |
      | retailer.code        | 62836   | VALID  | null    |
      | supplier.code        | ZVAT    | VALID  | null    |
      | lines[0].productCode | CREDIT  | VALID  | null    |

 # Scenario: 03 - Set valid cutoff date in future for user with END_OF_WEEK role
  #  Given I set OAuth for user testinv01
   # And request body is set to contents of file: testdata/calendar/validCutOffDate_future.json
   # And Request Content Type is set to: application/json
   # And I set the query URL to /calendar/cutoff
   # When I execute the api POST query
   # Then I should receive response status code 200
    #This uses MyDatabaseitems, but the items are set in  And I set connection details to seymour
    #only for Databaseitems. So need my own version of the step for this to work
   # When I runs SQL query and save results:
       #use source root
     # | queryfilepath                                      | savefilepath                                                |
    #  | testdata/sqlQueries/019A_validCutOffDate_query.sql | testdata/sqlActualResults/019A_validCutOffDate_results.json |
    #use repostitory root

    #this is Paul's version, need to write my own later
    #Then I compare JSON files:
    #  | firstfilepath                                                                             | secondfilepath                                                                 |
     # | src/test/resources/testdata/sqlExpectedResults/019A_validCutOffDate_Expected_results.json | src/test/resources/testdata/sqlActualResults/019A_validCutOffDate_results.json |

