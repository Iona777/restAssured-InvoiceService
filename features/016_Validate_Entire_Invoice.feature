Feature: 016 Validate Entire Invoice

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


    #Taken from  004 Invoice Save endpoint
  Scenario: 20 - I Call endpoint with Transferred payload with null Id - Week not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveNullIDNoWeekOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                 | status  | message                                                                 |
      | header.invoiceNumber        | EPI3659410-C          | VALID   | null                                                                    |
      | header.weekNumber           | 49                    | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.yearNumber           | 2021                  | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.invoiceStatus        | O                     | VALID   | null                                                                    |
      | header.description          | This is a description | VALID   | null                                                                    |
      | retailer.code               | 102418                | VALID   | null                                                                    |
      | supplier.code               | NISA                  | VALID   | null                                                                    |
      | retailer.orderNumber        | 3659410-A             | null    | null                                                                    |
      | retailer.orderDate          | 2021-01-01            | null    | null                                                                    |
      | retailer.deliveryDate       | 2021-01-02            | null    | null                                                                    |
      | retailer.deliveryNumber     | 123                   | null    | null                                                                    |
      | retailer.unitsDelivered     | 5                     | null    | null                                                                    |
      | lines[0].productCode        | PROD-01               | VALID   | null                                                                    |
      | lines[0].unitWeight         | 1.123                 | VALID   | null                                                                    |
      | lines[0].unitCost           | 7.5000                | VALID   | null                                                                    |
      | lines[0].vatCode            | L                     | VALID   | null                                                                    |
      | lines[0].discountAmount     | 1.0000                | VALID   | null                                                                    |
      | lines[0].productDescription | Cuddly toy            | VALID   | null                                                                    |



    #Taken from 011 Invoice Header Validate On GET - but changed into a POST, data from invoice 3
  Scenario: 02 - Check valid EDI invoice
    Given request body is set to contents of file: testdata/validate/entire_invoice/validEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/invoice
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                     | value                  | status | message |
      | header.invoiceNumber     | 3725073                | VALID  | null    |
      | header.invoiceType       | E                      | VALID  | null    |
      | header.invoiceDate       | 2021-02-14             | VALID  | null    |
      | header.invoiceStatus     | P                      | VALID  | null    |
      | header.description       | null                   | VALID  | null    |
    #Retailer
      | retailer.code            | 85012                  | VALID  | null    |
      | retailer.name            | CHARLES WALSH          | VALID  | null    |
      | retailer.addressLine1    | SUPERSHOP              | VALID  | null    |
      | retailer.addressLine2    | 33 GLEBETOWN DRIVE     | VALID  | null    |
      | retailer.addressLine3    | KILLOUGH ROAD          | VALID  | null    |
      | retailer.addressLine4    | Sometown               | VALID  | null    |
      | retailer.postcode        | BT30 6QD               | VALID  | null    |
      | retailer.vatNumber       | V87456321              | VALID  | null    |
      | retailer.supplierAccount | C34704                 | VALID  | null    |
#Supplier
      | supplier.code            | CAMB                   | VALID  | null    |
      | supplier.name            | COOP AMBIENT           | VALID  | null    |
      | supplier.addressLine1    | COOPERATIVE GROUP FOOD | VALID  | null    |
      | supplier.addressLine2    | ANGEL AQUARE           | VALID  | null    |
      | supplier.addressLine3    | MANCHESTER             | VALID  | null    |
      | supplier.addressLine4    | null                   | VALID  | null    |
      | supplier.postcode        | M60 0AG                | VALID  | null    |
      | supplier.partnerStatus   | L                      | VALID  | null    |

    #Taken from 012 Full Invoice Validation
  Scenario: 03 - I Call endpoint with Transferred payload with no lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/InvoiceWithNoLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    Then The following JSON values are present in the response:
      | item    | value                                |
      | status  | INVALID                              |
      | message | Invoices must have at least one line |

  Scenario: 04 - I Call endpoint with Transferred payload with Invoice Type M with positive and negative lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeM_PositiveAndNegativeLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    Then The following JSON values are present in the response:
      | item    | value                                                 |
      | status  | INVALID                                               |
      | message | Invoices may not have a mix of debit and credit lines |

  Scenario: 05 - I Call endpoint with Transferred payload with Invoice Type I with positive and negative lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeI_PositiveAndNegativeLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    Then The following JSON values are present in the response:
      | item    | value                                                 |
      | status  | INVALID                                               |
      | message | Invoices may not have a mix of debit and credit lines |


     #This includes both positive and negative lines. They are not rejected for Type E
  Scenario: 06 - I Call endpoint with Transferred payload with correct Amount fields
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeE_AllAmountsCorrect.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                   | status | message |
      | header.invoiceNumber        | EPI3659916              | VALID  | null    |
      | header.invoiceType          | E                       | VALID  | null    |
      | header.invoiceStatus        | O                       | VALID  | null    |
      | header.description          | This is a saved payload | VALID  | null    |

      | totals.zeroVatAmount        | -4.26                   | VALID  | null    |
      | totals.specialVatAmount     | 7.00                    | VALID  | null    |
      | totals.stdVatAmount         | 12.00                   | VALID  | null    |
      | totals.netAmount            | 14.74                   | VALID  | null    |
      | totals.vatAmount            | 2.75                    | VALID  | null    |
      | totals.totalAmount          | 17.49                   | VALID  | null    |

      | lines[0].productCode        | 35594                   | VALID  | null    |
      | lines[0].unitWeight         | 0.000                   | VALID  | null    |
      | lines[0].units              | 2.000                   | VALID  | null    |
      | lines[0].unitCost           | 14.0000                 | VALID  | null    |
      | lines[0].unitCostExVat      | 28.00                   | VALID  | null    |
      | lines[0].vatCode            | S                       | VALID  | null    |
      | lines[0].discountAmount     | 0                       | VALID  | null    |
      | lines[0].vatAmount          | 5.60                    | VALID  | null    |
      | lines[0].totalAmount        | 33.60                   | VALID  | null    |
      | lines[0].productDescription | SWIZZLES LOVE HEART TIN | VALID  | null    |

      | lines[1].productCode        | 17125                   | VALID  | null    |
      | lines[1].unitWeight         | 0.000                   | VALID  | null    |
      | lines[1].units              | 2.000                   | VALID  | null    |
      | lines[1].unitCost           | -8.0000                 | VALID  | null    |
      | lines[1].unitCostExVat      | -16.00                  | VALID  | null    |
      | lines[1].vatCode            | S                       | VALID  | null    |
      | lines[1].discountAmount     | 0                       | VALID  | null    |
      | lines[1].vatAmount          | -3.20                   | VALID  | null    |
      | lines[1].totalAmount        | -19.20                  | VALID  | null    |
      | lines[1].productDescription | SWIZZELS MATLOW LOVE HEARTS | VALID  | null    |

      | lines[2].productCode        | 17125-A                 | VALID  | null    |
      | lines[2].unitWeight         | 0.000                   | VALID  | null    |
      | lines[2].units              | 2.000                   | VALID  | null    |
      | lines[2].unitCost           | -4.0000                 | VALID  | null    |
      | lines[2].unitCostExVat      | -8.00                   | VALID  | null    |
      | lines[2].vatCode            | L                       | VALID  | null    |
      | lines[2].discountAmount     | 0                       | VALID  | null    |
      | lines[2].vatAmount          | -0.40                   | VALID  | null    |
      | lines[2].totalAmount        | -8.40                   | VALID  | null    |
      | lines[2].productDescription | Fuel 1                  | VALID  | null    |

      | lines[3].productCode        | 17125-C                 | VALID  | null    |
      | lines[3].unitWeight         | 0.000                   | VALID  | null    |
      | lines[3].units              | 3.000                   | VALID  | null    |
      | lines[3].unitCost           | 5.0000                  | VALID  | null    |
      | lines[3].unitCostExVat      | 15.00                   | VALID  | null    |
      | lines[3].vatCode            | L                       | VALID  | null    |
      | lines[3].discountAmount     | 1.0000                  | VALID  | null    |
      | lines[3].vatAmount          | 0.75                    | VALID  | null    |
      | lines[3].totalAmount        | 14.75                   | VALID  | null    |
      | lines[3].productDescription | Fuel 2                  | VALID  | null    |

      | lines[4].productCode        | 17125-D                 | VALID  | null    |
      | lines[4].unitWeight         | 0.000                   | VALID  | null    |
      | lines[4].units              | 30.000                  | VALID  | null    |
      | lines[4].unitCost           | 0.0997                  | VALID  | null    |
      | lines[4].unitCostExVat      | 2.99                    | VALID  | null    |
      | lines[4].vatCode            | Z                       | VALID  | null    |
      | lines[4].discountAmount     | 0                       | VALID  | null    |
      | lines[4].vatAmount          | 0.00                    | VALID  | null    |
      | lines[4].totalAmount        | 2.99                    | VALID  | null    |
      | lines[4].productDescription | Nappies size 1          | VALID  | null    |

      | lines[5].productCode        | 17125-E                 | VALID  | null    |
      | lines[5].unitWeight         | 0.000                   | VALID  | null    |
      | lines[5].units              | 25.000                  | VALID  | null    |
      | lines[5].unitCost           | 0.1100                  | VALID  | null    |
      | lines[5].unitCostExVat      | 2.75                    | VALID  | null    |
      | lines[5].vatCode            | X                       | VALID  | null    |
      | lines[5].discountAmount     | 0.2500                  | VALID  | null    |
      | lines[5].vatAmount          | 0.00                    | VALID  | null    |
      | lines[5].totalAmount        | 2.50                    | VALID  | null    |
      | lines[5].productDescription | Nappies size 2          | VALID  | null    |

      | lines[6].productCode        | 17125-Ref               | VALID  | null    |
      | lines[6].unitWeight         | 0.000                   | VALID  | null    |
      | lines[6].units              | 1.000                   | VALID  | null    |
      | lines[6].unitCost           | -10.0000                | VALID  | null    |
      | lines[6].unitCostExVat      | -10.00                  | VALID  | null    |
      | lines[6].vatCode            | X                       | VALID  | null    |
      | lines[6].discountAmount     | 0                       | VALID  | null    |
      | lines[6].vatAmount          | 0.00                    | VALID  | null    |
      | lines[6].totalAmount        | -10.00                  | VALID  | null    |
      | lines[6].productDescription | Some kind of refund     | VALID  | null    |


  Scenario: 12 - I Call endpoint with Transferred payload with Amount fields that will not match the lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeE_NoAmountsMatchHeaders.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                         | status | message |
      | header.invoiceNumber        | EPI3659975                    | VALID  | null    |
      | header.invoiceType          | E                             | VALID  | null    |
      | header.invoiceStatus        | O                             | VALID  | null    |
      | header.description          | This is another saved payload | VALID  | null    |
      | totals.zeroVatAmount        | -4.26                         | VALID  | null    |
      | totals.specialVatAmount     | 7.00                          | VALID  | null    |
      | totals.stdVatAmount         | 12.00                         | VALID  | null    |
      | totals.netAmount            | 14.74                         | VALID  | null    |
      | totals.vatAmount            | 2.75                          | VALID  | null    |
      | totals.totalAmount          | 17.49                         | VALID  | null    |
      | lines[0].productCode        | 35594                         | VALID  | null    |
      | lines[0].unitWeight         | 0.000                         | VALID  | null    |
      | lines[0].units              | 2.000                         | VALID  | null    |
      | lines[0].unitCost           | 14.0000                       | VALID  | null    |
      | lines[0].unitCostExVat      | 28.00                         | VALID  | null    |
      | lines[0].vatCode            | S                             | VALID  | null    |
      | lines[0].discountAmount     | 0                             | VALID  | null    |
      | lines[0].vatAmount          | 5.60                          | VALID  | null    |
      | lines[0].totalAmount        | 33.60                         | VALID  | null    |
      | lines[0].productDescription | SWIZZLES LOVE HEART TIN       | VALID  | null    |

      | lines[1].productCode        | 17125                         | VALID  | null    |
      | lines[1].unitWeight         | 0.000                         | VALID  | null    |
      | lines[1].units              | 2.000                         | VALID  | null    |
      | lines[1].unitCost           | -8.0000                       | VALID  | null    |
      | lines[1].unitCostExVat      | -16.00                        | VALID  | null    |
      | lines[1].vatCode            | S                             | VALID  | null    |
      | lines[1].discountAmount     | 0                             | VALID  | null    |
      | lines[1].vatAmount          | -3.20                         | VALID  | null    |
      | lines[1].totalAmount        | -19.20                        | VALID  | null    |
      | lines[1].productDescription | SWIZZELS MATLOW LOVE HEARTS   | VALID  | null    |

      | lines[2].productCode        | 17125-A                       | VALID  | null    |
      | lines[2].unitWeight         | 0.000                         | VALID  | null    |
      | lines[2].units              | 2.000                         | VALID  | null    |
      | lines[2].unitCost           | -4.0000                       | VALID  | null    |
      | lines[2].unitCostExVat      | -8.00                         | VALID  | null    |
      | lines[2].vatCode            | L                             | VALID  | null    |
      | lines[2].discountAmount     | 0                             | VALID  | null    |
      | lines[2].vatAmount          | -0.40                         | VALID  | null    |
      | lines[2].totalAmount        | -8.40                         | VALID  | null    |
      | lines[2].productDescription | Fuel 1                        | VALID  | null    |

      | lines[3].productCode        | 17125-C                       | VALID  | null    |
      | lines[3].unitWeight         | 0.000                         | VALID  | null    |
      | lines[3].units              | 3.000                         | VALID  | null    |
      | lines[3].unitCost           | 5.0000                        | VALID  | null    |
      | lines[3].unitCostExVat      | 15.00                         | VALID  | null    |
      | lines[3].vatCode            | L                             | VALID  | null    |
      | lines[3].discountAmount     | 1.0000                        | VALID  | null    |
      | lines[3].vatAmount          | 0.75                          | VALID  | null    |
      | lines[3].totalAmount        | 14.75                         | VALID  | null    |
      | lines[3].productDescription | Fuel 2                        | VALID  | null    |

      | lines[4].productCode        | 17125-D                       | VALID  | null    |
      | lines[4].unitWeight         | 0.000                         | VALID  | null    |
      | lines[4].units              | 30.000                        | VALID  | null    |
      | lines[4].unitCost           | 0.0997                        | VALID  | null    |
      | lines[4].unitCostExVat      | 2.99                          | VALID  | null    |
      | lines[4].vatCode            | Z                             | VALID  | null    |
      | lines[4].discountAmount     | 0                             | VALID  | null    |
      | lines[4].vatAmount          | 0.00                          | VALID  | null    |
      | lines[4].totalAmount        | 2.99                          | VALID  | null    |
      | lines[4].productDescription | Nappies size 1                | VALID  | null    |

      | lines[5].productCode        | 17125-E                       | VALID  | null    |
      | lines[5].unitWeight         | 0.000                         | VALID  | null    |
      | lines[5].units              | 25.000                        | VALID  | null    |
      | lines[5].unitCost           | 0.1100                        | VALID  | null    |
      | lines[5].unitCostExVat      | 2.75                          | VALID  | null    |
      | lines[5].vatCode            | X                             | VALID  | null    |
      | lines[5].discountAmount     | 0.2500                        | VALID  | null    |
      | lines[5].vatAmount          | 0.00                          | VALID  | null    |
      | lines[5].totalAmount        | 2.50                          | VALID  | null    |
      | lines[5].productDescription | Nappies size 2                | VALID  | null    |

      | lines[6].productCode        | 17125-Ref                     | VALID  | null    |
      | lines[6].unitWeight         | 0.000                         | VALID  | null    |
      | lines[6].units              | 1.000                         | VALID  | null    |
      | lines[6].unitCost           | -10.0000                      | VALID  | null    |
      | lines[6].unitCostExVat      | -10.00                        | VALID  | null    |
      | lines[6].vatCode            | X                             | VALID  | null    |
      | lines[6].discountAmount     | 0                             | VALID  | null    |
      | lines[6].vatAmount          | 0.00                          | VALID  | null    |
      | lines[6].totalAmount        | -10.00                        | VALID  | null    |
      | lines[6].productDescription | Some kind of refund           | VALID  | null    |


  Scenario: 07 - I Call endpoint with Transferred payload with duplicate combination key fields
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeE_AllAmountsCorrectDuplicateNoID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value        | status  | message                     |
      | header.invoiceNumber | EPI3659916   | INVALID | This invoice already exists |
      | header.invoiceType   | E            | INVALID | This invoice already exists |
      | header.invoiceDate   | 2020-12-14   | INVALID | This invoice already exists |
      | retailer.code        | 115225       | INVALID | This invoice already exists |
      | supplier.code        | NISA         | INVALID | This invoice already exists |


  Scenario: 08 - I Call endpoint with EDI payload with duplicate combination key fields
    Given request body is set to contents of file: testdata/validate/full_Invoice/EDI_Duplicate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/invoice
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value     | status  | message                     |
      | header.invoiceNumber | 2020556-A | INVALID | This invoice already exists |
      | supplier.generation  | 7510      | INVALID | This invoice already exists |
      | supplier.code        | NISA      | INVALID | This invoice already exists |


    #Taken from 015 Add Calculate Line Flag

  Scenario: 09 - I Call endpoint with Transferred payload with calculateLine = FALSE for all lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeI_CalcLineFalse.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
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


  Scenario: 10 - I Call endpoint with Transferred payload with calculateLine = TRUE and FAlSE for different lines
    Given request body is set to contents of file: testdata/validate/lines/flags/TypeI_CalcLineTrueAndFalse.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
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


    #Scenarios with new payloads
  #Checks: EDI Invoice status = X
  Scenario: 13 - I Call endpoint with EDI payload with invalid invoice status = X
    Given request body is set to contents of file: testdata/validate/entire_invoice/EDI_status_X.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/invoice
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value                          | status  | message                           |
      | header.invoiceNumber | 7405907                        | VALID   | null                              |
      | header.invoiceType   | E                              | VALID   | null                              |
      | header.invoiceStatus | X                              | INVALID | The EDI status must be 'E' or 'P' |
      | retailer.code        | 100564                         | VALID   | null                              |
      | supplier.generation  | 7510                           | VALID   | null                              |
      | supplier.code        | NISA                           | VALID   | null                              |


    #Checks: EDI Invoice status = E
  Scenario: 14 - I Call endpoint with EDI payload with invalid invoice status = E
    Given request body is set to contents of file: testdata/validate/entire_invoice/EDI_status_E.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/invoice
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value   | status  | message |
      | header.invoiceNumber | 7405907 | VALID   | null    |
      | header.invoiceType   | E       | VALID   | null    |
      | header.invoiceStatus | E       | WARNING | null    |
      | retailer.code        | 100564  | VALID   | null    |
      | supplier.generation  | 7510    | VALID   | null    |
      | supplier.code        | NISA    | VALID   | null    |

     #Checks: Transferred Invoice status = M
  Scenario: 15 - I Call endpoint with Transferred payload with invalid invoice status = M
    Given request body is set to contents of file: testdata/validate/entire_invoice/Transferred_status_M.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value   | status  | message                                         |
      | header.invoiceNumber | 1928940 | VALID   | null                                            |
      | header.invoiceType   | I       | VALID   | null                                            |
      | header.invoiceStatus | M       | INVALID | The invoice status must be 'A', 'E', 'O' or 'P' |
      | retailer.code        | 62836   | VALID   | null                                            |
      | supplier.generation  | 1       | VALID   | null                                            |
      | supplier.code        | ZVAT    | VALID   | null                                            |

  #Checks: retailer code, supplier code, invoice date, invoice status header description, generation number,
  #lines.vatAmount unit weight product description (valid)
  Scenario: 11 - I Call endpoint with Transferred payload with several invalid fields fields - 01
    Given request body is set to contents of file: testdata/validate/entire_invoice/Transferred_VariousInvalid_01.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                       | status  | message                                         |
      | header.invoiceNumber        | 1928940                     | VALID   | null                                            |
      | header.invoiceType          | I                           | VALID   | null                                            |
      | header.invoiceDate          | null                        | INVALID | The invoice date must not be blank              |
      | header.weekNumber           | 50                          | VALID   | null                                            |
      | header.yearNumber           | 2021                        | VALID   | null                                            |
      | header.invoiceStatus        | X                           | INVALID | The invoice status must be 'A', 'E', 'O' or 'P' |
      | header.description          | 123456781 123456782 123456783 123456784 123456785 123456786 123456787 123456788 123456789 1234567890,123456781 123456782 123456783 123456784 123456785 123456786 123456787 123456788 123456789 1234567890 123456781 123456782 123456783 123456784 123456785 123456 | INVALID  | The invoice description must be shorter than 256 characters    |

      | totals.zeroVatAmount        | 0.00                    | VALID  | null    |
      | totals.specialVatAmount     | 0.00                    | VALID  | null    |
      | totals.stdVatAmount         | 20.05                   | VALID  | null    |
      | totals.netAmount            | 20.05                   | VALID  | null    |
      | totals.vatAmount            | 4.00                    | VALID  | null    |
      | totals.totalAmount          | 24.05                   | VALID  | null    |
      | retailer.code               | null                    | INVALID  | The retailer code must not be blank    |
      | supplier.generation         | 10000                   | INVALID  | The generation number is greater than the maximum allowed value of 9999    |
      | supplier.code               | null                    | INVALID  | The supplier code must not be blank    |

      | lines[0].productCode        | CREDIT                  | VALID   | null    |
      | lines[0].unitWeight         | abc                     | INVALID | The unit weight is not a valid number    |
      | lines[0].units              | 1.000                   | VALID   | null    |
      | lines[0].unitCost           | 20.05                   | VALID   | null    |
      | lines[0].unitCostExVat      | 20.05                   | VALID   | null    |
      | lines[0].vatPercent         | 20.00                   | VALID   | null    |
      | lines[0].vatCode            | S                       | VALID   | null    |
      | lines[0].discountAmount     | 0                       | VALID   | null    |
      | lines[0].vatAmount          | 4.00                    | WARNING | VAT amount 4.00 is different from the calculated value of 4.01    |
      | lines[0].totalAmount        | 24.05                   | VALID   | null    |
      | lines[0].productDescription | A Toy                   | INVALID | The product description must be longer than 5 characters    |

    #Checks: Invoice status retailer code, supplier code, invoice type, invoice status, lines.vatAmount
  Scenario: 12 - I Call endpoint with Transferred payload with several invalid fields fields - 02
    Given request body is set to contents of file: testdata/validate/entire_invoice/Transferred_VariousInvalid_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                          | status   | message |
      | header.invoiceNumber        | 1928940                        | VALID    | null    |
      | header.invoiceType          | X                              | INVALID  | The invoice type must be 'E', 'I' or 'M'    |
      | header.invoiceDate          | 2021-01-14                     | VALID    | null    |
      | header.weekNumber           | 50                             | VALID    | This week does not have a summary invoice and changes will not be saved    |
      | header.yearNumber           | 2021                           | VALID    | This week does not have a summary invoice and changes will not be saved    |
      | header.invoiceStatus        | O                              | VALID    | null    |
      | header.description          | AUTO-GENERATED EBOR VAT CONTRA | VALID    | null    |

      | totals.zeroVatAmount        | 0.00                           | VALID    | null    |
      | totals.specialVatAmount     | 0.00                           | VALID    | null    |
      | totals.stdVatAmount         | 19.95                          | VALID    | null    |
      | totals.netAmount            | 19.95                          | VALID    | null    |
      | totals.vatAmount            | 4.00                           | VALID    | null    |
      | totals.totalAmount          | 23.95                          | VALID    | null    |

      | retailer.code               | xxx                            | INVALID | Retailer 'xxx' does not exist                                           |
      | supplier.generation         | 0                              | INVALID | The generation number is less than the minimum allowed value of 1       |
      | supplier.code               | xxx                            | INVALID | Supplier 'xxx' does not exist                                           |

      | lines[0].productCode        | 123                            | VALID   | null                                                                    |
      | lines[0].unitWeight         | 1.2                            | VALID   | null                                                                    |
      | lines[0].units              | 1.000                          | VALID   | null                                                                    |
      | lines[0].unitCost           | 19.95                          | VALID   | null                                                                    |
      | lines[0].unitCostExVat      | 19.95                          | VALID   | null                                                                    |
      | lines[0].vatPercent         | 20.00                          | VALID   | null                                                                    |
      | lines[0].vatCode            | S                              | VALID   | null                                                                    |
      | lines[0].discountAmount     | 0                              | VALID   | null                                                                    |
      | lines[0].vatAmount          | 4.00                           | WARNING | VAT amount 4.00 is different from the calculated value of 3.99          |
      | lines[0].totalAmount        | 23.95                          | VALID   | null                                                                    |
      | lines[0].productDescription | Large Cuddly Toy               | VALID   | null                                                                    |

#Checks: invoiceNumber, invoiceDate, weekNumber, yearNumber, productCode, units, vatPercent, vatCode & productDescription
  Scenario: 13 - I Call endpoint with Transferred payload with several invalid fields fields - 03
    Given request body is set to contents of file: testdata/validate/entire_invoice/Transferred_VariousInvalid_03.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                          | status  | message                                                                    |
      | header.invoiceNumber        | 1928940-1234567891             | INVALID | The invoice number must be shorter than 18 characters                      |
      | header.invoiceType          | I                              | VALID   | null                                                                       |
      | header.invoiceDate          | 2121-01-14                     | INVALID | This invoice type cannot be assigned an invoice date that is in the future |
      | header.weekNumber           | 5                              | INVALID | This week has been closed and changes will not be saved                    |
      | header.yearNumber           | 2021                           | VALID   | This week has been closed and changes will not be saved                    |
      | header.invoiceStatus        | O                              | VALID   | null                                                                       |
      | header.description          | AUTO-GENERATED EBOR VAT CONTRA | VALID   | null                                                                       |

      | totals.zeroVatAmount        | 0.00                           | VALID    | null    |
      | totals.specialVatAmount     | 0.00                           | VALID    | null    |
      | totals.stdVatAmount         | 0.00                           | VALID    | null    |
      | totals.netAmount            | 0.00                           | VALID    | null    |
      | totals.vatAmount            | 0.00                           | VALID    | null    |
      | totals.totalAmount          | 0.00                           | VALID    | null    |

      | retailer.code               | 62836                          | VALID   | null                                                                       |
      | supplier.generation         | A                              | INVALID | The generation number is not a valid number                                |
      | supplier.code               | ZVAT                           | VALID   | null                                                                       |

      | lines[0].productCode        | null                           | INVALID | The product code must not be blank                                         |
      | lines[0].unitWeight         | null                           | VALID   | null                                                                       |
      | lines[0].units              | A                              | INVALID | The number of units is not a valid number                                  |
      | lines[0].unitCost           | -2076.5900                     | VALID   | null                                                                       |
      | lines[0].unitCostExVat      | 0                              | VALID   | null                                                                       |
      | lines[0].vatPercent         | null                           | INVALID | The VAT code must be 'L', 'M', 'R', 'S', 'X' or 'Z'                        |
      | lines[0].vatCode            | A                              | INVALID | The VAT code must be 'L', 'M', 'R', 'S', 'X' or 'Z'                        |
      | lines[0].discountAmount     | 0                              | VALID   | null                                                                       |
      | lines[0].vatAmount          | 0.00                           | VALID   | null                                                                       |
      | lines[0].totalAmount        | 0.00                           | VALID   | null                                                                       |
      | lines[0].productDescription | null                           | INVALID | The product description must not be blank                                  |


    #Checks: Unit cost, discount amount & productDescription
  Scenario: 14 - I Call endpoint with Transferred payload with several invalid fields fields - 04
    Given request body is set to contents of file: testdata/validate/entire_invoice/Transferred_VariousInvalid_05.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/invoice/
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                          | status  | message  |
      | header.invoiceNumber        | 1928940                        | VALID   | null     |
      | header.invoiceType          | I                              | VALID   | null     |
      | header.invoiceDate          | 2021-01-14                     | VALID   | null     |
      | header.weekNumber           | 50                             | VALID   | null     |
      | header.yearNumber           | 2021                           | VALID   | null     |
      | header.invoiceStatus        | O                              | VALID   | null     |
      | header.description          | AUTO-GENERATED EBOR VAT CONTRA | VALID   | null     |

      | totals.zeroVatAmount        | 0.00                           | VALID   | null     |
      | totals.specialVatAmount     | 0.00                           | VALID   | null     |
      | totals.stdVatAmount         | 0.00                           | VALID   | null     |
      | totals.netAmount            | 0.00                           | VALID   | null     |
      | totals.vatAmount            | 0.00                           | VALID   | null     |
      | totals.totalAmount          | 0.00                           | VALID   | null     |

      | retailer.code               | 62836                          | VALID   | null     |
      | supplier.generation         | 1                              | VALID   | null     |
      | supplier.code               | ZVAT                           | VALID   | null     |

      | lines[0].productCode        | CREDIT                         | VALID   | null     |
      | lines[0].unitWeight         | null                           | VALID   | null     |
      | lines[0].units              | 1.000                          | VALID   | null     |
      | lines[0].unitCost           | -                              | INVALID | The unit cost is not a valid number |
      | lines[0].unitCostExVat      | 0.00                           | VALID   | null     |
      | lines[0].vatPercent         | 0.00                           | VALID   | null     |
      | lines[0].vatCode            | Z                              | VALID   | null     |
      | lines[0].discountAmount     | A                              | INVALID | The discount amount is not a valid number |
      | lines[0].vatAmount          | 0.00                           | VALID   | null                                      |
      | lines[0].totalAmount        | 0.00                           | VALID   | null                                      |
      | lines[0].productDescription | 123456781 123456782 123456783 12345678941 | INVALID | The product description must be shorter than 41 characters |
