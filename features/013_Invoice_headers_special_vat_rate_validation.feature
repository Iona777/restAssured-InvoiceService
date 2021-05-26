Feature: 013 Special Vat Rate validation

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
      | filepath                                 |
      | testdata/setup/invoice_clerks.json       |
      | testdata/setup/invoice_groups.json       |
      | testdata/setup/regions.json              |
      | testdata/setup/areas.json                |
      | testdata/setup/shop_addresses.json       |
      | testdata/setup/shops.json                |
      | testdata/setup/retail_organisations.json |
      | testdata/setup/franchises.json           |
      | testdata/setup/suppliers.json            |
      | testdata/setup/vat_rates.json            |
      | testdata/setup/invoice_types.json        |
      | testdata/setup/invoice_statuses.json     |
      | testdata/setup/week_numbers.json         |
      | testdata/setup/invoice_headers.json      |
      | testdata/setup/invoice_lines.json        |
      | testdata/setup/inv_hdr_vat_rates.json    |
      | testdata/setup/edi_invoice_headers.json  |
      | testdata/setup/edi_invoice_lines.json    |


  Scenario: 02 Setting Vat code S should not add a row into inv_hdr_vat_rate table
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferredVatRateS.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/transferred
    When I execute the api POST query
    And I should receive response status code 201
    Then The following values are present in the response:
      | item                 | value          | status | message |
      | header.invoiceNumber | 20210329095429 | VALID  | null    |
      | lines[0].vatCode     | S              | VALID  | null    |
      | lines[0].vatPercent  | 20.00          | VALID  | null    |
  #Check no (special) VAT rates added for vat code S
    And I set the query URL to /invoice/transferred/1
    When  I execute the api GET query
    Then The following JSON items are not present in the response
      | item                         |
      | vatRates[0].code             |
      | vatRates[0].rate             |
      | vatRates[0].specialVatAmount |
      | vatRates[0].vatPayable       |
      | vatRates[0].description      |
   

  Scenario: 04 Setting Vat code Z should not add a row into inv_hdr_vat_rate table
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferredVatRateZ.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/transferred
    When I execute the api POST query
    And I should receive response status code 201
    Then The following values are present in the response:
      | item                 | value          | status | message |
      | header.invoiceNumber | 20210329095429 | VALID  | null    |
      | lines[0].vatCode     | Z              | VALID  | null    |
      | lines[0].vatPercent  | 0.00           | VALID  | null    |
  # Check no (special) VAT rates added for vat code Z
    And I set the query URL to /invoice/transferred/1
    When I execute the api GET query
    Then The following JSON items are not present in the response
      | item                         |
      | vatRates[0].code             |
      | vatRates[0].rate             |
      | vatRates[0].specialVatAmount |
      | vatRates[0].vatPayable       |
      | vatRates[0].description      |


  Scenario: 05 Setting Vat code is X should not add a row into inv_hdr_vat_rate table
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferredVatRateX.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/transferred
    When I execute the api POST query
    And I should receive response status code 201
    Then The following values are present in the response:
      | item                 | value          | status | message |
      | header.invoiceNumber | 20210329095429 | VALID  | null    |
      | lines[0].vatCode     | X              | VALID  | null    |
      | lines[0].vatPercent  | 0.00           | VALID  | null    |
# Check no (special) VAT rates added for vat code X
    And I set the query URL to /invoice/transferred/1
    When I execute the api GET query
    Then The following JSON items are not present in the response
      | item                         |
      | vatRates[0].code             |
      | vatRates[0].rate             |
      | vatRates[0].specialVatAmount |
      | vatRates[0].vatPayable       |
      | vatRates[0].description      |


  Scenario: 06 A row should be added into inv_hdr_vat_rate table for Vat code R
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferredVatRateR.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/transferred
    And I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                 | value          | status | message |
      | header.invoiceNumber | 20210329095429 | VALID  | null    |
      | lines[0].vatCode     | S              | VALID  | null    |
      | lines[0].vatPercent  | 20.00          | VALID  | null    |
      | lines[1].vatCode     | R              | VALID  | null    |
      | lines[1].vatPercent  | 5.00           | VALID  | null    |

    #Check (special) VAT rates R is added and specialVatAmount calculated correctly
    # (sum of unitCostExVat on lines where special VAT rate applies)
    #Could check as part of the POST, but using a GET makes sure it has saved.
    And I set the query URL to /invoice/transferred/1
    When I execute the api GET query
    Then The following values are present in the response:
      | item                         | value          | status | message |
      | header.invoiceNumber         | 20210329095429 | VALID  | null    |
      | vatRates[0].code             | R              | null   | null    |
      | vatRates[0].rate             | 5.00           | null   | null    |
      | lines[1].units               | 2.00           | null   | null    |
      | lines[1].unitCost            | 20.00          | null   | null    |
      | lines[1].unitCostExVat       | 40.00          | null   | null    |
      | lines[1].vatAmount           | 2.00           | null   | null    |
      | vatRates[0].specialVatAmount | 40.00          | null   | null    |
      | vatRates[0].vatPayable       | 2.00           | null   | null    |
      | vatRates[0].description      | null           | null   | null    |

    #Since there is an existing line with vat code R, adding an additional line with vat code R, should result in
    # unitCostExVat for both lines being summed
    Scenario: 07 Save additional line with R vat code
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferredAdditionalLineVatRateR.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/transferred
    When I execute the api POST query
    Then I should receive response status code 201
      And The following values are present in the response:
        | item                 | value          | status | message |
        | header.invoiceNumber | 20210329095429 | VALID  | null    |

        | lines[0].vatCode     | S              | VALID  | null    |
        | lines[0].vatPercent  | 20.00          | VALID  | null    |

        | lines[1].vatCode     | R              | VALID  | null    |
        | lines[1].vatPercent  | 5.00           | VALID  | null    |

        | lines[2].vatCode     | R              | VALID  | null    |
        | lines[2].vatPercent  | 5.00           | VALID  | null    |

    #Check  specialVatAmount calculated correctly with additional line with R vat code
    And I set the query URL to /invoice/transferred/1
    When I execute the api GET query
    Then The following values are present in the response:
      | item                         | value          | status | message |
      | header.invoiceNumber         | 20210329095429 | VALID  | null    |
      | lines[1].units               | 2.000          | null   | null    |
      | lines[1].unitCost            | 20.00          | null   | null    |
      | lines[1].unitCostExVat       | 40.00          | null   | null    |
      | lines[1].vatAmount           | 2.00           | null   | null    |

      | lines[2].units               | 3.00           | null   | null    |
      | lines[2].unitCost            | 10.00          | null   | null    |
      | lines[2].unitCostExVat       | 30.00          | null   | null    |
      | lines[2].vatAmount           | 1.50           | null   | null    |
      | vatRates[0].code             | R              | null   | null    |
      | vatRates[0].rate             | 5.00           | null   | null    |
      | vatRates[0].specialVatAmount | 70.00          | null   | null    |
      | vatRates[0].rate             | 5.00           | null   | null    |
      | vatRates[0].vatPayable       | 3.50           | null   | null    |
      | vatRates[0].description      | null           | null   | null    |

  Scenario: 08 Given vat line with vat code R is deleted should delete record in inv_hdr_vat_rat table
    #First make sure there are R vat code lines present, to make this scenario independent of other scenarios.
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferredAdditionalLineVatRateR.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/transferred
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                 | value          | status | message |
      | header.invoiceNumber | 20210329095429 | VALID  | null    |
      | lines[0].vatCode     | S              | VALID  | null    |
      | lines[0].vatPercent  | 20.00          | VALID  | null    |
      | lines[1].vatCode     | R              | VALID  | null    |
      | lines[1].vatPercent  | 5.00           | VALID  | null    |
      | lines[2].vatCode     | R              | VALID  | null    |
      | lines[2].vatPercent  | 5.00           | VALID  | null    |
    # Delete current line with R vat code
    Then request body is set to contents of file: testdata/savePayloads/saveValidTransferredVatRateS.json
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                 | value          | status | message |
      | header.invoiceNumber | 20210329095429 | VALID  | null    |
      | lines[0].vatCode     | S              | VALID  | null    |
      | lines[0].vatPercent  | 20.00          | VALID  | null    |
    #Check line for VAT rate R is not present
    And The following JSON items are not present in the response
      | lines[1].vatCode    |
      | lines[1].vatPercent |
      | lines[2].vatCode    |
      | lines[2].vatPercent |
    #Could check as part of the POST, but using a GET makes sure it has saved.
    And I set the query URL to /invoice/transferred/1
    When I execute the api GET query
    Then The following JSON items are not present in the response
      | item                         |
      | vatRates[0].code             |
      | vatRates[0].rate             |
      | vatRates[0].specialVatAmount |
      | vatRates[0].vatPayable       |
      | vatRates[0].description      |
      | vatRates[1].code             |
      | vatRates[1].rate             |
      | vatRates[1].specialVatAmount |
      | vatRates[1].vatPayable       |
      | vatRates[1].description      |




