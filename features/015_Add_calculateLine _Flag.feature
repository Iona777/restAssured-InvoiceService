Feature: 015 Add Calculate Line Flag

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



  Scenario: 02 - I Call endpoint with Transferred payload with calculateLine = FALSE for all lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeI_CalcLineFalse.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following JSON values are present in the response:
      | item                   | value   |
      | header.invoiceNumber   | 1928572 |
      | lines[0].calculateLine | false   |
      | lines[1].calculateLine | false   |
      | lines[2].calculateLine | false   |
    And The following values are present in the response:
      | item                   | value   | status | message |
      | header.invoiceNumber   | 1928572 | VALID  | null    |
      | lines[0].units         | -4.000  | null   | null    |
      | lines[0].unitCost      | 7.5000  | null   | null    |
      | lines[0].unitCostExVat | 20.000  | null   | null    |
      | lines[0].vatPercent    | 5       | null   | null    |
      | lines[0].vatCode       | X       | null   | null    |
      | lines[0].discountAmount| 1.000   | null   | null    |
      | lines[0].vatAmount     | 5.50    | null   | null    |
      | lines[0].totalAmount   | 20.00   | VALID  | null    |

      | lines[1].units         | -2.000  | null   | null    |
      | lines[1].unitCost      | 18.000  | null   | null    |
      | lines[1].unitCostExVat | 35.000  | null   | null    |
      | lines[1].vatPercent    | 5       | null   | null    |
      | lines[1].vatCode       | S       | null   | null    |
      | lines[1].discountAmount| null    | null   | null    |
      | lines[1].vatAmount     | null    | null   | null    |
      | lines[1].totalAmount   | 20.00   | VALID  | null    |

      | lines[2].units         | -2.000  | null   | null    |
      | lines[2].unitCost      | 104.000 | null   | null    |
      | lines[2].unitCostExVat | 35.000  | null   | null    |
      | lines[2].vatPercent    | 5       | null   | null    |
      | lines[2].vatCode       | X       | null   | null    |
      | lines[2].discountAmount| null    | null   | null    |
      | lines[2].vatAmount     | null    | null   | null    |
      | lines[2].totalAmount   | 20.00   | VALID  | null    |
    #Do a GET on same invoice as the content is known at this point
    When I query GET endpoint "/invoice/999"
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                   | value   |
      | header.invoiceNumber   | 1928572 |
      | lines[0].calculateLine | false   |
      | lines[1].calculateLine | false   |
      | lines[2].calculateLine | false   |
    And The following values are present in the response:
      | item                    | value    | status | message |
      | header.invoiceNumber    | 1928572  | VALID  | null    |
      | lines[0].units          | -4.000   | null   | null    |
      | lines[0].unitCost       | 7.5000   | null   | null    |
      | lines[0].unitCostExVat  | 20.00    | null   | null    |
      | lines[0].vatPercent     | 5        | null   | null    |
      | lines[0].vatCode        | X        | null   | null    |
      | lines[0].discountAmount | 1.000    | null   | null    |
      | lines[0].vatAmount      | 5.5000   | null   | null    |
      | lines[0].totalAmount    | 20.00    | VALID  | null    |

      | lines[1].units          | -2.000   | null   | null    |
      | lines[1].unitCost       | 18.0000  | null   | null    |
      | lines[1].unitCostExVat  | 35.0000  | null   | null    |
      | lines[1].vatPercent     | 5        | null   | null    |
      | lines[1].vatCode        | S        | null   | null    |
      | lines[1].discountAmount | null     | null   | null    |
      | lines[1].vatAmount      | null     | null   | null    |
      | lines[1].totalAmount    | 20.00    | VALID  | null    |



  Scenario: 03 - I Call endpoint with Transferred payload with calculateLine = TRUE for all lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeI_CalcLineTrue.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item                   | value   |
      | header.invoiceNumber   | 1928572 |
      | lines[0].calculateLine | true   |
      | lines[1].calculateLine | true   |
      | lines[2].calculateLine | true   |
    And The following values are present in the response:
      | item                   | value        | status  | message |
      | header.invoiceNumber   | 1928572      | VALID   | null    |
      | lines[0].units         | -4.000       | INVALID | Units must not be less than zero    |
      | lines[0].unitCost      | 7.5000       | VALID   | null    |
      | lines[0].unitCostExVat | -30.00       | VALID   | null    |
      | lines[0].vatPercent    | 0.00         | VALID   | null    |
      | lines[0].vatCode       | X            | VALID   | null    |
      | lines[0].discountAmount| 1.000        | VALID   | null    |
      | lines[0].vatAmount     | 5.50         | WARNING | VAT amount 5.50 is different from the calculated value of 0.00|
      | lines[0].totalAmount   | -25.50       | VALID   | null    |

      | lines[1].units         | -2.000       | INVALID | Units must not be less than zero    |
      | lines[1].unitCost      | 18.000       | VALID   | null    |
      | lines[1].unitCostExVat | -36.00       | VALID   | null    |
      | lines[1].vatPercent    | 20           | VALID   | null    |
      | lines[1].vatCode       | S            | VALID   | null    |
      | lines[1].discountAmount| 0            | VALID   | null    |
      | lines[1].vatAmount     | -7.20        | VALID   | null    |
      | lines[1].totalAmount   | -43.20       | VALID  | null    |

      | lines[2].units         | -2.000       | INVALID | Units must not be less than zero    |
      | lines[2].unitCost      | 104.000      | VALID   | null    |
      | lines[2].unitCostExVat | -208.00      | VALID   | null    |
      | lines[2].vatPercent    | 0.00         | VALID   | null    |
      | lines[2].vatCode       | X            | VALID   | null    |
      | lines[2].discountAmount| 0            | VALID   | null    |
      | lines[2].vatAmount     | 0.00         | VALID   | null    |
      | lines[2].totalAmount   | -208.00      | VALID  | null     |
    #Do a GET on same invoice as the content is known at this point
    When I query GET endpoint "/invoice/999"
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                   | value   |
      | header.invoiceNumber   | 1928572 |
      | lines[0].calculateLine | false   |
      | lines[1].calculateLine | false   |
      | lines[2].calculateLine | false   |
    And The following values are present in the response:
      | item                    | value    | status | message |
      | header.invoiceNumber    | 1928572  | VALID  | null    |
      | lines[0].units          | -4.000   | null   | null    |
      | lines[0].unitCost       | 7.5000   | null   | null    |
      | lines[0].unitCostExVat  | 20.00    | null   | null    |
      | lines[0].vatPercent     | 5        | null   | null    |
      | lines[0].vatCode        | X        | null   | null    |
      | lines[0].discountAmount | 1.000    | null   | null    |
      | lines[0].vatAmount      | 5.5000   | null   | null    |
      | lines[0].totalAmount    | 20.00    | VALID  | null    |

      | lines[1].units          | -2.000   | null   | null    |
      | lines[1].unitCost       | 18.0000  | null   | null    |
      | lines[1].unitCostExVat  | 35.0000  | null   | null    |
      | lines[1].vatPercent     | 5        | null   | null    |
      | lines[1].vatCode        | S        | null   | null    |
      | lines[1].discountAmount | null     | null   | null    |
      | lines[1].vatAmount      | null     | null   | null    |
      | lines[1].totalAmount    | 20.00    | VALID  | null    |

      | lines[2].units          | -2.000   | null   | null    |
      | lines[2].unitCost       | 104.0000 | null   | null    |
      | lines[2].unitCostExVat  | 35.0000  | null   | null    |
      | lines[2].vatPercent     | 5        | null   | null    |
      | lines[2].vatCode        | X        | null   | null    |
      | lines[2].discountAmount | null     | null   | null    |
      | lines[2].vatAmount      | null     | null   | null    |
      | lines[2].totalAmount    | 20.00    | VALID  | null    |

  Scenario: 04 - I Call endpoint with Transferred payload with calculateLine = TRUE and FAlSE for different lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeI_CalcLineTrueAndFalse.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item                   | value   |
      | header.invoiceNumber   | 1928572 |
      | lines[0].calculateLine | true    |
      | lines[1].calculateLine | true    |
      | lines[2].calculateLine | false   |
    And The following values are present in the response:
      | item                   | value        | status  | message |
      | header.invoiceNumber   | 1928572      | VALID   | null    |
      | lines[0].units         | -4.000       | INVALID | Units must not be less than zero    |
      | lines[0].unitCost      | 7.5000       | VALID   | null    |
      | lines[0].unitCostExVat | -30.00       | VALID   | null    |
      | lines[0].vatPercent    | 0.00         | VALID   | null    |
      | lines[0].vatCode       | X            | VALID   | null    |
      | lines[0].discountAmount| 1.000        | VALID   | null    |
      | lines[0].vatAmount     | 5.50         | WARNING | VAT amount 5.50 is different from the calculated value of 0.00|
      | lines[0].totalAmount   | -25.50       | VALID   | null    |

      | lines[1].units         | -2.000       | INVALID | Units must not be less than zero    |
      | lines[1].unitCost      | 18.000       | VALID   | null    |
      | lines[1].unitCostExVat | -36.00       | VALID   | null    |
      | lines[1].vatPercent    | 20           | VALID   | null    |
      | lines[1].vatCode       | S            | VALID   | null    |
      | lines[0].discountAmount| 0            | VALID   | null    |
      | lines[1].vatAmount     | -7.20        | VALID   | null    |
      | lines[1].totalAmount   | -43.20       | VALID  | null     |

      | lines[2].units         | -2.000  | null   | null    |
      | lines[2].unitCost      | 104.000 | null   | null    |
      | lines[2].unitCostExVat | 35.000  | null   | null    |
      | lines[2].vatPercent    | 5       | null   | null    |
      | lines[2].vatCode       | X       | null   | null    |
      | lines[2].discountAmount| null    | null   | null    |
      | lines[2].vatAmount     | null    | null   | null    |
      | lines[2].totalAmount   | 20.00   | VALID  | null    |
#Do a GET on same invoice as the content is known at this point
    When I query GET endpoint "/invoice/999"
    Then I should receive response status code 200
    And The following JSON values are present in the response:
      | item                   | value   |
      | header.invoiceNumber   | 1928572 |
      | lines[0].calculateLine | false   |
      | lines[1].calculateLine | false   |
      | lines[2].calculateLine | false   |
    And The following values are present in the response:
      | item                    | value    | status | message |
      | header.invoiceNumber    | 1928572  | VALID  | null    |
      | lines[0].units          | -4.000   | null   | null    |
      | lines[0].unitCost       | 7.5000   | null   | null    |
      | lines[0].unitCostExVat  | 20.00    | null   | null    |
      | lines[0].vatPercent     | 5        | null   | null    |
      | lines[0].vatCode        | X        | null   | null    |
      | lines[0].discountAmount | 1.000    | null   | null    |
      | lines[0].vatAmount      | 5.5000   | null   | null    |
      | lines[0].totalAmount    | 20.00    | VALID  | null    |

      | lines[1].units          | -2.000   | null   | null    |
      | lines[1].unitCost       | 18.0000  | null   | null    |
      | lines[1].unitCostExVat  | 35.0000  | null   | null    |
      | lines[1].vatPercent     | 5        | null   | null    |
      | lines[1].vatCode        | S        | null   | null    |
      | lines[1].discountAmount | null     | null   | null    |
      | lines[1].vatAmount      | null     | null   | null    |
      | lines[1].totalAmount    | 20.00    | VALID  | null    |

      | lines[2].units          | -2.000   | null   | null    |
      | lines[2].unitCost       | 104.0000 | null   | null    |
      | lines[2].unitCostExVat  | 35.0000  | null   | null    |
      | lines[2].vatPercent     | 5        | null   | null    |
      | lines[2].vatCode        | X        | null   | null    |
      | lines[2].discountAmount | null     | null   | null    |
      | lines[2].vatAmount      | null     | null   | null    |
      | lines[2].totalAmount    | 20.00    | VALID  | null    |

    #Check that it also works when creating an invoice
  Scenario: 05 - I Call endpoint with Transferred payload with No ID and calculateLine = FALSE for all lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeM_Null_Id_CalcLineFalse.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following JSON values are present in the response:
      | item                   | value        |
      | header.invoiceNumber   | EPI3659499-A |
      | lines[0].calculateLine | false        |
      | lines[1].calculateLine | false        |
      | lines[2].calculateLine | false        |
    And The following values are present in the response:
      | item                   | value        | status | message |
      | header.invoiceNumber   | EPI3659499-A | VALID  | null    |
      | lines[0].units         | -4.000       | null   | null    |
      | lines[0].unitCostExVat | 20.000       | null   | null    |
      | lines[0].vatPercent    | 5            | null   | null    |
      | lines[0].vatAmount     | 5.50         | null   | null    |
      | lines[0].totalAmount   | 20.00        | VALID  | null    |

      | lines[1].units         | -2.000       | null   | null    |
      | lines[1].unitCostExVat | 35.000       | null   | null    |
      | lines[1].vatPercent    | 5            | null   | null    |
      | lines[1].vatAmount     | null         | null   | null    |
      | lines[1].totalAmount   | 20.00        | VALID  | null    |

      | lines[2].units         | -2.000       | null   | null    |
      | lines[2].unitCostExVat | 35.000       | null   | null    |
      | lines[2].vatPercent    | 5            | null   | null    |
      | lines[2].vatAmount     | null         | null   | null    |
      | lines[2].totalAmount   | 20.00        | VALID  | null    |


  Scenario: 06 - I Call endpoint with Transferred payload with No ID and calculateLine = TRUE for all lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeM_Null_Id_CalcLineTrue.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item                   | value        |
      | header.invoiceNumber   | EPI3659499-B |
      | lines[0].calculateLine | true         |
      | lines[1].calculateLine | true         |
      | lines[2].calculateLine | true         |
    And The following values are present in the response:
      | item                   | value        | status  | message |
      | header.invoiceNumber   | EPI3659499-B | VALID   | null    |
      | lines[0].units         | -4.000       | INVALID | Units must not be less than zero    |
      | lines[0].unitCost      | 7.5000       | VALID   | null    |
      | lines[0].unitCostExVat | -30.00       | VALID   | null    |
      | lines[0].vatPercent    | 0.00         | VALID   | null    |
      | lines[0].vatCode       | X            | VALID   | null    |
      | lines[0].discountAmount| 1.000        | VALID   | null    |
      | lines[0].vatAmount     | 5.50         | WARNING | VAT amount 5.50 is different from the calculated value of 0.00|
      | lines[0].totalAmount   | -25.50       | VALID   | null    |

      | lines[1].units         | -2.000       | INVALID | Units must not be less than zero    |
      | lines[1].unitCost      | 18.000       | VALID   | null    |
      | lines[1].unitCostExVat | -36.00       | VALID   | null    |
      | lines[1].vatPercent    | 20           | VALID   | null    |
      | lines[1].vatCode       | S            | VALID   | null    |
      | lines[1].discountAmount| 0            | VALID   | null    |
      | lines[1].vatAmount     | -7.20        | VALID   | null    |
      | lines[1].totalAmount   | -43.20       | VALID   | null    |

      | lines[2].units         | -2.000       | INVALID | Units must not be less than zero    |
      | lines[2].unitCost      | 104.000      | VALID   | null    |
      | lines[2].unitCostExVat | -208.00      | VALID   | null    |
      | lines[2].vatPercent    | 0.00         | VALID   | null    |
      | lines[2].vatCode       | X            | VALID   | null    |
      | lines[0].discountAmount| 0            | VALID   | null    |
      | lines[2].vatAmount     | 0.00         | VALID   | null    |
      | lines[2].totalAmount   | -208.00      | VALID  | null     |


  Scenario: 07 - I Call endpoint with Transferred payload with No ID and calculateLine = TRUE and FAlSE for different lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeI_Null_Id_CalcLineTrueAndFalse.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item                   | value        |
      | header.invoiceNumber   | EPI3659499-C |
      | lines[0].calculateLine | true         |
      | lines[1].calculateLine | true         |
      | lines[2].calculateLine | false        |
    And The following values are present in the response:
      | item                   | value        | status  | message |
      | header.invoiceNumber   | EPI3659499-C | VALID   | null    |
      | lines[0].units         | -4.000       | INVALID | Units must not be less than zero    |
      | lines[0].unitCost      | 7.5000       | VALID   | null    |
      | lines[0].unitCostExVat | -30.00       | VALID   | null    |
      | lines[0].vatPercent    | 0.00         | VALID   | null    |
      | lines[0].vatCode       | X            | VALID   | null    |
      | lines[0].discountAmount| 1.000        | VALID   | null    |
      | lines[0].vatAmount     | 5.50         | WARNING | VAT amount 5.50 is different from the calculated value of 0.00|
      | lines[0].totalAmount   | -25.50       | VALID   | null    |

      | lines[1].units         | -2.000       | INVALID | Units must not be less than zero    |
      | lines[1].unitCost      | 18.000       | VALID   | null    |
      | lines[1].unitCostExVat | -36.00       | VALID   | null    |
      | lines[1].vatPercent    | 20           | VALID   | null    |
      | lines[1].vatCode       | S            | VALID   | null    |
      | lines[0].discountAmount| 0            | VALID   | null    |
      | lines[1].vatAmount     | -7.20        | VALID   | null    |
      | lines[1].totalAmount   | -43.20       | VALID  | null    |

      | lines[2].units         | -2.000  | null   | null    |
      | lines[2].unitCost      | 104.000 | null   | null    |
      | lines[2].unitCostExVat | 35.000  | null   | null    |
      | lines[2].vatPercent    | 5       | null   | null    |
      | lines[2].vatCode       | X       | null   | null    |
      | lines[2].discountAmount| null    | null   | null    |
      | lines[2].vatAmount     | null    | null   | null    |
      | lines[2].totalAmount   | 20.00   | VALID  | null    |
    
    


