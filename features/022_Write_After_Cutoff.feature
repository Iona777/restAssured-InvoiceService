Feature: 022 Write After Cutoff

  Background:
    Given I start a new test
    And I set oAuth

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

    Scenario: 02 - I call save endpoint where user has WRITE_INVOICE, but NOT WRITE_INVOICE_AFTER_CUTOFF role
      Given I set OAuth for user testcrcont01
      And Request Content Type is set to: application/json
      And request body is set to contents of file: testdata/savePayloads/saveCutoffDateInPast.json
      And I set the query URL to /invoice/
      When I execute the api POST query
      Then I should receive response status code 400
      And The following JSON values are present in the response:
        | item                       | value                                                                   |
        | id                         | 486                                                                     |
        | header.weekClosed          | false                                                                   |
        | header.invoiceNumber.value | 1928736                                                                 |
        | header.weekNumber.value    | 7                                                                       |


  Scenario: 03 - I call save endpoint where user has WRITE_INVOICE_AFTER_CUTOFF & WRITE_INVOICE roles
    Given I set OAuth for user testinv01
    And Request Content Type is set to: application/json
    And request body is set to contents of file: testdata/savePayloads/saveCutoffDateInPast.json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following JSON values are present in the response:
      | item                       | value   |
      | id                         | 486     |
      | header.weekClosed          | false   |
      | header.invoiceNumber.value | 1928736 |
      | header.weekNumber.value    | 7       |
