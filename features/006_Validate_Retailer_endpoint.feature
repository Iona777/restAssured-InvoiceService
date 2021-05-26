Feature: 006 Validate Retailer endpoint

  Background:
    Given  I start a new test
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
      | billing.invoice_groups        |
      | billing.invoice_clerks        |

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


  Scenario: 02 I Call endpoint with valid EDI retailer code payload
    Given request body is set to contents of file: testdata/validate/retailer/validateValidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item            | value                                    | status | message |
      | code            | 72196                                    | VALID  | null    |
      | name            | SIMPLY FRESH -DRINKSWORLD LTD MR K KHERA | VALID  | null    |
      | addressLine1    | SIMPLY FRESH                             | VALID  | null    |
      | addressLine2    | 5 - 7 HIGH STREET                        | VALID  | null    |
      | addressLine3    | Midtown                                  | VALID  | null    |
      | addressLine4    | Dunney-on-the-wold                       | VALID  | null    |
      | postcode        | B49 5AE                                  | VALID  | null    |
      | vatNumber       | V78912378                                | VALID  | null    |
      | supplierAccount | C31688                                   | VALID  | null    |


  Scenario: 03 I Call endpoint with invalid EDI retailercode  payload
    Given request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item            | value | status  | message                         |
      | code            | 99999 | INVALID | Retailer '99999' does not exist |
      | name            | null  | null    | null                            |
      | addressLine1    | null  | null    | null                            |
      | addressLine2    | null  | null    | null                            |
      | addressLine3    | null  | null    | null                            |
      | addressLine4    | null  | null    | null                            |
      | postcode        | null  | null    | null                            |
      | vatNumber       | null  | null    | null                            |
      | supplierAccount | null  | null    | null                            |


  Scenario: 04 I Call endpoint with null EDI retailer code  payload
    Given request body is set to contents of file: testdata/validate/retailer/validateNullRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item            | value | status  | message                             |
      | code            | null  | INVALID | The retailer code must not be blank |
      | name            | null  | null    | null                                |
      | addressLine1    | null  | null    | null                                |
      | addressLine2    | null  | null    | null                                |
      | addressLine3    | null  | null    | null                                |
      | addressLine4    | null  | null    | null                                |
      | postcode        | null  | null    | null                                |
      | vatNumber       | null  | null    | null                                |
      | supplierAccount | null  | null    | null                                |




