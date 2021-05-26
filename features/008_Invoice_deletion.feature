Feature: 008 Invoice Deletion Endpoint

  Background:
    Given I start a new test
    And  I set oAuth

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

    And I quickly load table data specified in files:
      | filepath                                  |
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

  Scenario: 02 - Existing transferred invoice in db and not closed, it should be deleted
    Given I query GET endpoint "/invoice/486"
    And I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value   |
      | id                         | 486     |
      | header.invoiceNumber.value | 1928736 |
      | header.weekNumber.value    | 7       |
      | header.yearNumber.value    | 2021    |
      | retailer.code              | 51604   |
      | supplier.code              | ZCRSM   |
      | lines[0].id                | 144     |
    And I set the query URL to /invoice/Transferred/delete/486
    When I execute the api DELETE query
    Then I should receive response status code 200
    And I query GET endpoint "/invoice/486"
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value               |
      | errorCode | INVOICE_NOT_FOUND   |
      | message   | Invoice 486 not found |

  Scenario: 03 - Existing transferred invoice in DB and closed - should not allowed to delete
    Given I query GET endpoint "/invoice/Transferred/487"
    And I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value   |
      | id                         | 487     |
      | header.invoiceNumber.value | 1928737 |
      | header.weekNumber.value    | 3       |
      | header.yearNumber.value    | 2021    |
      | retailer.code.value        | 40768   |
      | supplier.code.value        | ZCRSM   |
      | lines[0].id                | 145     |
    And I set the query URL to /invoice/Transferred/delete/487
    When I execute the api DELETE query
    # This code has been changed as part of 1280 -Add endpoint to adjust cut-off date
    Then I should receive response status code 403
    And The following JSON values are present in the response:
      | item      | value                                        |
      | errorCode | WEEK_CLOSED                                  |
      | message   | Cannot delete an invoice from a closed week. |


  Scenario: 04 - Existing EDI invoice in EDI table (always not closed), it should be deleted
    Given I query GET endpoint "/invoice/EDI/1"
    And I should receive response status code 200
    And The following JSON values are present in the response:
      | item                       | value   |
      | id                         | 1       |
      | header.invoiceNumber.value | 7405907 |
      | retailer.code.value        | 113344  |
      | supplier.code.value        | CAMB    |
      | lines[0].id                | 445     |
    And I set the query URL to /invoice/EDI/delete/1
    When I execute the api DELETE query
    Then I should receive response status code 200
    And I query GET endpoint "/invoice/EDI/1"
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value               |
      | errorCode | INVOICE_NOT_FOUND   |
      | message   | Invoice 1 not found |
