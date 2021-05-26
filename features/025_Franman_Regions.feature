Feature: 025 - Franman Regions

  Background:
    Given I start a new test
    And I set oAuth

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


    And I quickly load table data specified in files:
      | filepath                                  |
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

  Scenario: 02 - Get Region List
    Given I set the query URL to /regions/list
    When I execute the api GET query
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item     | value                   |
      | [0].code | CE                      |
      | [0].name | CENTRAL                 |
      | [1].code | CEN                     |
      | [1].name | CENTRAL                 |
      | [2].code | EBOR                    |
      | [2].name | EBOR                    |
      | [3].code | NEWNI                   |
      | [3].name | NORTHERN IRELAND REGION |
      | [4].code | NOR                     |
      | [4].name | NORTH                   |
      | [5].code | SDX                     |
      | [5].name | SODEXO REGION           |
      | [6].code | SF                      |
      | [6].name | Simply Fresh            |
      | [7].code | SOU                     |
      | [7].name | SOUTH                   |
      | [8].code | WHOLE                   |
      | [8].name | Wholesale               |


