Feature: 012 Full Invoice Validation

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

  Scenario: 02 - I Call endpoint with Transferred payload with only 1 line
    Given request body is set to contents of file: testdata/validate/full_Invoice/InvoiceWithSingleLine.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                 | value   | status | message |
      | header.invoiceNumber | 1928940 | VALID  | null    |
      | header.invoiceType   | I       | VALID  | null    |
      | retailer.code        | 62836   | VALID  | null    |
      | supplier.code        | ZVAT    | VALID  | null    |
      | lines[0].productCode | CREDIT  | VALID  | null    |

  Scenario: 03 - I Call endpoint with Transferred payload with no lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/InvoiceWithNoLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    Then The following JSON values are present in the response:
      | item    | value                                |
      | status  | INVALID                              |
      | message | Invoices must have at least one line |

  Scenario: 04 - I Call endpoint with Transferred payload with Invoice Type I and all negative lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeI_AllAmountsNegative.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value                          | status | message |
      | header.invoiceNumber        | 1928950                        | VALID  | null    |
      | header.invoiceType          | I                              | VALID  | null    |
      | header.invoiceStatus        | O                              | VALID  | null    |
      | header.description          | AUTO-GENERATED EBOR VAT CONTRA | VALID  | null    |
      | totals.zeroVatAmount        | -821.26                        | VALID  | null    |
      | totals.specialVatAmount     | 0.00                           | VALID  | null    |
      | totals.stdVatAmount         | 0.00                           | VALID  | null    |
      | totals.netAmount            | -821.26                        | VALID  | null    |
      | totals.vatAmount            | 0.00                           | VALID  | null    |
      | totals.totalAmount          | -821.26                        | VALID  | null    |

      | lines[0].productCode        | CREDIT                         | VALID  | null    |
      | lines[0].unitWeight         | null                           | VALID  | null    |
      | lines[0].units              | 1.000                          | VALID  | null    |
      | lines[0].unitCost           | -340.4200                      | VALID  | null    |
      | lines[0].unitCostExVat      | -340.42                        | VALID  | null    |
      | lines[0].vatCode            | Z                              | VALID  | null    |
      | lines[0].discountAmount     | 0                              | VALID  | null    |
      | lines[0].vatAmount          | 0.00                           | VALID  | null    |
      | lines[0].totalAmount        | -340.42                        | VALID  | null    |
      | lines[0].productDescription | AUTO_GENERATED EBOR VAT CONTRA | VALID  | null    |

      | lines[1].productCode        | CREDIT                         | VALID  | null    |
      | lines[1].unitWeight         | null                           | VALID  | null    |
      | lines[1].units              | 2.000                          | VALID  | null    |
      | lines[1].unitCost           | -240.4200                      | VALID  | null    |
      | lines[1].unitCostExVat      | -480.84                        | VALID  | null    |
      | lines[1].vatCode            | Z                              | VALID  | null    |
      | lines[1].discountAmount     | 0                              | VALID  | null    |
      | lines[1].vatAmount          | 0.00                           | VALID  | null    |
      | lines[1].totalAmount        | -480.84                        | VALID  | null    |
      | lines[1].productDescription | AUTO_GENERATED EBOR VAT CONTRA | VALID  | null    |

  Scenario: 05 - I Call endpoint with Transferred payload with Invoice Type M and all negative lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeM_AllAmountsNegative.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value                          | status | message |
      | header.invoiceNumber        | 1401202118688RM                | VALID  | null    |
      | header.invoiceType          | M                              | VALID  | null    |
      | header.invoiceStatus        | O                              | VALID  | null    |
      | header.description          | null                           | VALID  | null    |
      | totals.zeroVatAmount        | -821.26                        | VALID  | null    |
      | totals.specialVatAmount     | 0.00                           | VALID  | null    |
      | totals.stdVatAmount         | 0.00                           | VALID  | null    |
      | totals.netAmount            | -821.26                        | VALID  | null    |
      | totals.vatAmount            | 0.00                           | VALID  | null    |
      | totals.totalAmount          | -821.26                        | VALID  | null    |

      | lines[0].productCode        | CREDIT                         | VALID  | null    |
      | lines[0].unitWeight         | null                           | VALID  | null    |
      | lines[0].units              | 1.000                          | VALID  | null    |
      | lines[0].unitCost           | -340.4200                      | VALID  | null    |
      | lines[0].unitCostExVat      | -340.42                        | VALID  | null    |
      | lines[0].vatCode            | Z                              | VALID  | null    |
      | lines[0].discountAmount     | 0                              | VALID  | null    |
      | lines[0].vatAmount          | 0.00                           | VALID  | null    |
      | lines[0].totalAmount        | -340.42                        | VALID  | null    |
      | lines[0].productDescription | AUTO_GENERATED EBOR VAT CONTRA | VALID  | null    |

      | lines[1].productCode        | CREDIT                         | VALID  | null    |
      | lines[1].unitWeight         | null                           | VALID  | null    |
      | lines[1].units              | 2.000                          | VALID  | null    |
      | lines[1].unitCost           | -240.4200                      | VALID  | null    |
      | lines[1].unitCostExVat      | -480.84                        | VALID  | null    |
      | lines[1].vatCode            | Z                              | VALID  | null    |
      | lines[1].discountAmount     | 0                              | VALID  | null    |
      | lines[1].vatAmount          | 0.00                           | VALID  | null    |
      | lines[1].totalAmount        | -480.84                        | VALID  | null    |
      | lines[1].productDescription | AUTO_GENERATED EBOR VAT CONTRA | VALID  | null    |


  Scenario: 06 - I Call endpoint with Transferred payload with Invoice Type I and all positive lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeI_AllAmountsPositive.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value                              | status | message |
      | header.invoiceNumber        | 1928921                            | VALID  | null    |
      | header.invoiceType          | I                                  | VALID  | null    |
      | header.invoiceStatus        | O                                  | VALID  | null    |
      | header.description          | Rental site with additional extras | VALID  | null    |
      | totals.zeroVatAmount        | 0.00                               | VALID  | null    |
      | totals.specialVatAmount     | 0.00                               | VALID  | null    |
      | totals.stdVatAmount         | 13.55                              | VALID  | null    |
      | totals.netAmount            | 13.55                              | VALID  | null    |
      | totals.vatAmount            | 2.71                               | VALID  | null    |
      | totals.totalAmount          | 16.26                              | VALID  | null    |

      | lines[0].productCode        | RENTEX                             | VALID  | null    |
      | lines[0].unitWeight         | null                               | VALID  | null    |
      | lines[0].units              | 1.000                              | VALID  | null    |
      | lines[0].unitCost           | 3.8500                             | VALID  | null    |
      | lines[0].unitCostExVat      | 3.85                               | VALID  | null    |
      | lines[0].vatCode            | S                                  | VALID  | null    |
      | lines[0].discountAmount     | 0                                  | VALID  | null    |
      | lines[0].vatAmount          | 0.77                               | VALID  | null    |
      | lines[0].totalAmount        | 4.62                               | VALID  | null    |
      | lines[0].productDescription | Rental site with additional extras | VALID  | null    |

      | lines[1].productCode        | RENTEX                             | VALID  | null    |
      | lines[1].unitWeight         | null                               | VALID  | null    |
      | lines[1].units              | 2.000                              | VALID  | null    |
      | lines[1].unitCost           | 4.8500                             | VALID  | null    |
      | lines[1].unitCostExVat      | 9.70                               | VALID  | null    |
      | lines[1].vatCode            | S                                  | VALID  | null    |
      | lines[1].discountAmount     | 0                                  | VALID  | null    |
      | lines[1].vatAmount          | 1.94                               | VALID  | null    |
      | lines[1].totalAmount        | 11.64                              | VALID  | null    |
      | lines[1].productDescription | Rental site with additional extras | VALID  | null    |

  Scenario: 07 - I Call endpoint with Transferred payload with Invoice Type M and all positive lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeM_AllAmountsPositive.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value               | status | message |
      | header.invoiceNumber        | 1401202184373RM     | VALID  | null    |
      | header.invoiceType          | M                   | VALID  | null    |
      | header.invoiceStatus        | O                   | VALID  | null    |
      | header.description          | null                | VALID  | null    |
      | totals.zeroVatAmount        | 0.00                | VALID  | null    |
      | totals.specialVatAmount     | 0.00                | VALID  | null    |
      | totals.stdVatAmount         | 88.23               | VALID  | null    |
      | totals.netAmount            | 88.23               | VALID  | null    |
      | totals.vatAmount            | 17.64               | VALID  | null    |
      | totals.totalAmount          | 105.87              | VALID  | null    |

      | lines[0].productCode        | Prod-P1             | VALID  | null    |
      | lines[0].unitWeight         | null                | VALID  | null    |
      | lines[0].units              | 2.000               | VALID  | null    |
      | lines[0].unitCost           | 24.9900             | VALID  | null    |
      | lines[0].unitCostExVat      | 49.98               | VALID  | null    |
      | lines[0].vatCode            | S                   | VALID  | null    |
      | lines[0].discountAmount     | 0                   | VALID  | null    |
      | lines[0].vatAmount          | 9.99                | VALID  | null    |
      | lines[0].totalAmount        | 59.97               | VALID  | null    |
      | lines[0].productDescription | Large Paddling Pool | VALID  | null    |

      | lines[1].productCode        | Prod-P2             | VALID  | null    |
      | lines[1].unitWeight         | null                | VALID  | null    |
      | lines[1].units              | 3.000               | VALID  | null    |
      | lines[1].unitCost           | 12.7500             | VALID  | null    |
      | lines[1].unitCostExVat      | 38.25               | VALID  | null    |
      | lines[1].vatCode            | S                   | VALID  | null    |
      | lines[1].discountAmount     | 2.75                | VALID  | null    |
      | lines[1].vatAmount          | 7.65                | VALID  | null    |
      | lines[1].totalAmount        | 43.15               | VALID  | null    |
      | lines[1].productDescription | Small Paddling Pool | VALID  | null    |


  Scenario: 08 - I Call endpoint with Transferred payload with Invoice Type M with positive and negative lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeM_PositiveAndNegativeLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    Then The following JSON values are present in the response:
      | item    | value                                                 |
      | status  | INVALID                                               |
      | message | Invoices may not have a mix of debit and credit lines |


  Scenario: 09 - I Call endpoint with Transferred payload with Invoice Type I with positive and negative lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeI_PositiveAndNegativeLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    Then The following JSON values are present in the response:
      | item       | value                                                 |
      | status  | INVALID                                               |
      | message | Invoices may not have a mix of debit and credit lines |


    #This includes both positive and negative lines. They are not rejected for Type E
  Scenario: 10 - I Call endpoint with Transferred payload with correct Amount fields
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeE_AllAmountsCorrect.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value                       | status | message |
      | header.invoiceNumber        | EPI3659916                  | VALID  | null    |
      | header.invoiceType          | E                           | VALID  | null    |
      | header.invoiceStatus        | O                           | VALID  | null    |
      | header.description          | This is a saved payload     | VALID  | null    |
      | totals.zeroVatAmount        | -4.26                       | VALID  | null    |
      | totals.specialVatAmount     | 7.00                        | VALID  | null    |
      | totals.stdVatAmount         | 12.00                       | VALID  | null    |
      | totals.netAmount            | 14.74                       | VALID  | null    |
      | totals.vatAmount            | 2.75                        | VALID  | null    |
      | totals.totalAmount          | 17.49                       | VALID  | null    |
      | lines[0].productCode        | 35594                       | VALID  | null    |
      | lines[0].unitWeight         | 0.000                       | VALID  | null    |
      | lines[0].units              | 2.000                       | VALID  | null    |
      | lines[0].unitCost           | 14.0000                     | VALID  | null    |
      | lines[0].unitCostExVat      | 28.00                       | VALID  | null    |
      | lines[0].vatCode            | S                           | VALID  | null    |
      | lines[0].discountAmount     | 0                           | VALID  | null    |
      | lines[0].vatAmount          | 5.60                        | VALID  | null    |
      | lines[0].totalAmount        | 33.60                       | VALID  | null    |
      | lines[0].productDescription | SWIZZLES LOVE HEART TIN     | VALID  | null    |

      | lines[1].productCode        | 17125                       | VALID  | null    |
      | lines[1].unitWeight         | 0.000                       | VALID  | null    |
      | lines[1].units              | 2.000                       | VALID  | null    |
      | lines[1].unitCost           | -8.0000                     | VALID  | null    |
      | lines[1].unitCostExVat      | -16.00                      | VALID  | null    |
      | lines[1].vatCode            | S                           | VALID  | null    |
      | lines[1].discountAmount     | 0                           | VALID  | null    |
      | lines[1].vatAmount          | -3.20                       | VALID  | null    |
      | lines[1].totalAmount        | -19.20                      | VALID  | null    |
      | lines[1].productDescription | SWIZZELS MATLOW LOVE HEARTS | VALID  | null    |

      | lines[2].productCode        | 17125-A                     | VALID  | null    |
      | lines[2].unitWeight         | 0.000                       | VALID  | null    |
      | lines[2].units              | 2.000                       | VALID  | null    |
      | lines[2].unitCost           | -4.0000                     | VALID  | null    |
      | lines[2].unitCostExVat      | -8.00                       | VALID  | null    |
      | lines[2].vatCode            | L                           | VALID  | null    |
      | lines[2].discountAmount     | 0                           | VALID  | null    |
      | lines[2].vatAmount          | -0.40                       | VALID  | null    |
      | lines[2].totalAmount        | -8.40                       | VALID  | null    |
      | lines[2].productDescription | Fuel 1                      | VALID  | null    |

      | lines[3].productCode        | 17125-C                     | VALID  | null    |
      | lines[3].unitWeight         | 0.000                       | VALID  | null    |
      | lines[3].units              | 3.000                       | VALID  | null    |
      | lines[3].unitCost           | 5.0000                      | VALID  | null    |
      | lines[3].unitCostExVat      | 15.00                       | VALID  | null    |
      | lines[3].vatCode            | L                           | VALID  | null    |
      | lines[3].discountAmount     | 1.0000                      | VALID  | null    |
      | lines[3].vatAmount          | 0.75                        | VALID  | null    |
      | lines[3].totalAmount        | 14.75                       | VALID  | null    |
      | lines[3].productDescription | Fuel 2                      | VALID  | null    |

      | lines[4].productCode        | 17125-D                     | VALID  | null    |
      | lines[4].unitWeight         | 0.000                       | VALID  | null    |
      | lines[4].units              | 30.000                      | VALID  | null    |
      | lines[4].unitCost           | 0.0997                      | VALID  | null    |
      | lines[4].unitCostExVat      | 2.99                        | VALID  | null    |
      | lines[4].vatCode            | Z                           | VALID  | null    |
      | lines[4].discountAmount     | 0                           | VALID  | null    |
      | lines[4].vatAmount          | 0.00                        | VALID  | null    |
      | lines[4].totalAmount        | 2.99                        | VALID  | null    |
      | lines[4].productDescription | Nappies size 1              | VALID  | null    |

      | lines[5].productCode        | 17125-E                     | VALID  | null    |
      | lines[5].unitWeight         | 0.000                       | VALID  | null    |
      | lines[5].units              | 25.000                      | VALID  | null    |
      | lines[5].unitCost           | 0.1100                      | VALID  | null    |
      | lines[5].unitCostExVat      | 2.75                        | VALID  | null    |
      | lines[5].vatCode            | X                           | VALID  | null    |
      | lines[5].discountAmount     | 0.2500                      | VALID  | null    |
      | lines[5].vatAmount          | 0.00                        | VALID  | null    |
      | lines[5].totalAmount        | 2.50                        | VALID  | null    |
      | lines[5].productDescription | Nappies size 2              | VALID  | null    |

      | lines[6].productCode        | 17125-Ref                   | VALID  | null    |
      | lines[6].unitWeight         | 0.000                       | VALID  | null    |
      | lines[6].units              | 1.000                       | VALID  | null    |
      | lines[6].unitCost           | -10.0000                    | VALID  | null    |
      | lines[6].unitCostExVat      | -10.00                      | VALID  | null    |
      | lines[6].vatCode            | X                           | VALID  | null    |
      | lines[6].discountAmount     | 0                           | VALID  | null    |
      | lines[6].vatAmount          | 0.00                        | VALID  | null    |
      | lines[6].totalAmount        | -10.00                      | VALID  | null    |
      | lines[6].productDescription | Some kind of refund         | VALID  | null    |

  #NEED TO DO A GET AFTER THIS TO BE SURE IT HAS SAVED PROPERLY
  #HERE WE ARE COMPARING WHAT IS ON THE DATABASE (I.E. THE DATA IN THE SETUP FILES) WITH THE CALCULATED VALUES
  #IN THIS HAPPY PATH SCENARIO, THEY SHOULD MATCH
  Scenario: 11A - I Call GET endpoint for Transferred payload with correct Amount fields
    When I query GET endpoint "/invoice/33"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                       | status | message |
      | header.invoiceNumber        | EPI3659916                  | VALID  | null    |
      | header.invoiceType          | E                           | VALID  | null    |
      | header.invoiceStatus        | O                           | VALID  | null    |
      | header.description          | This is a saved payload     | VALID  | null    |
      | totals.zeroVatAmount        | -4.26                       | VALID  | null    |
      | totals.specialVatAmount     | 7.00                        | VALID  | null    |
      | totals.stdVatAmount         | 12.00                       | VALID  | null    |
      | totals.netAmount            | 14.74                       | VALID  | null    |
      | totals.vatAmount            | 2.75                        | VALID  | null    |
      | totals.totalAmount          | 17.49                       | VALID  | null    |
      | lines[0].productCode        | 35594                       | VALID  | null    |
      | lines[0].unitWeight         | 0.000                       | null   | null    |
      | lines[0].units              | 2.000                       | null   | null    |
      | lines[0].unitCost           | 14.0000                     | null   | null    |
      | lines[0].unitCostExVat      | 28.00                       | null   | null    |
      | lines[0].vatCode            | S                           | null   | null    |
      | lines[0].discountAmount     | 0                           | null   | null    |
      | lines[0].vatAmount          | 5.60                        | null   | null    |
      | lines[0].totalAmount        | 33.60                       | null   | null    |
      | lines[0].productDescription | SWIZZLES LOVE HEART TIN     | VALID  | null    |

      | lines[1].productCode        | 17125                       | VALID  | null    |
      | lines[1].unitWeight         | 0.000                       | null   | null    |
      | lines[1].units              | 2.000                       | null   | null    |
      | lines[1].unitCost           | -8.0000                     | null   | null    |
      | lines[1].unitCostExVat      | -16.00                      | null   | null    |
      | lines[1].vatCode            | S                           | null   | null    |
      | lines[1].discountAmount     | 0                           | null   | null    |
      | lines[1].vatAmount          | -3.20                       | null   | null    |
      | lines[1].totalAmount        | -19.20                      | null   | null    |
      | lines[1].productDescription | SWIZZELS MATLOW LOVE HEARTS | VALID  | null    |

      | lines[2].productCode        | 17125-A                     | VALID  | null    |
      | lines[2].unitWeight         | 0.000                       | null   | null    |
      | lines[2].units              | 2.000                       | null   | null    |
      | lines[2].unitCost           | -4.0000                     | null   | null    |
      | lines[2].unitCostExVat      | -8.00                       | null   | null    |
      | lines[2].vatCode            | L                           | null   | null    |
      | lines[2].discountAmount     | 0                           | null   | null    |
      | lines[2].vatAmount          | -0.40                       | null   | null    |
      | lines[2].totalAmount        | -8.40                       | null   | null    |
      | lines[2].productDescription | Fuel 1                      | VALID  | null    |

      | lines[3].productCode        | 17125-C                     | VALID  | null    |
      | lines[3].unitWeight         | 0.000                       | null   | null    |
      | lines[3].units              | 3.000                       | null   | null    |
      | lines[3].unitCost           | 5.0000                      | null   | null    |
      | lines[3].unitCostExVat      | 15.00                       | null   | null    |
      | lines[3].vatCode            | L                           | null   | null    |
      | lines[3].discountAmount     | 1.0000                      | null   | null    |
      | lines[3].vatAmount          | 0.75                        | null   | null    |
      | lines[3].totalAmount        | 14.75                       | null   | null    |
      | lines[3].productDescription | Fuel 2                      | VALID  | null    |

      | lines[4].productCode        | 17125-D                     | VALID  | null    |
      | lines[4].unitWeight         | 0.000                       | null   | null    |
      | lines[4].units              | 30.000                      | null   | null    |
      | lines[4].unitCost           | 0.0997                      | null   | null    |
      | lines[4].unitCostExVat      | 2.99                        | null   | null    |
      | lines[4].vatCode            | Z                           | null   | null    |
      | lines[4].discountAmount     | 0                           | null   | null    |
      | lines[4].vatAmount          | 0.00                        | null   | null    |
      | lines[4].totalAmount        | 2.99                        | null   | null    |
      | lines[4].productDescription | Nappies size 1              | VALID  | null    |

      | lines[5].productCode        | 17125-E                     | VALID  | null    |
      | lines[5].unitWeight         | 0.000                       | null   | null    |
      | lines[5].units              | 25.000                      | null   | null    |
      | lines[5].unitCost           | 0.1100                      | null   | null    |
      | lines[5].unitCostExVat      | 2.75                        | null   | null    |
      | lines[5].vatCode            | X                           | null   | null    |
      | lines[5].discountAmount     | 0.2500                      | null   | null    |
      | lines[5].vatAmount          | 0.00                        | null   | null    |
      | lines[5].totalAmount        | 2.50                        | null   | null    |
      | lines[5].productDescription | Nappies size 2              | VALID  | null    |

      | lines[6].productCode        | 17125-Ref                   | VALID  | null    |
      | lines[6].unitWeight         | 0.000                       | null   | null    |
      | lines[6].units              | 1.000                       | null   | null    |
      | lines[6].unitCost           | -10.0000                    | null   | null    |
      | lines[6].unitCostExVat      | -10.00                      | null   | null    |
      | lines[6].vatCode            | X                           | null   | null    |
      | lines[6].discountAmount     | 0                           | null   | null    |
      | lines[6].vatAmount          | 0.00                        | null   | null    |
      | lines[6].totalAmount        | -10.00                      | null   | null    |
      | lines[6].productDescription | Some kind of refund         | VALID  | null    |


  Scenario: 12 - I Call endpoint with Transferred payload with Amount fields that will not match the lines
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeE_NoAmountsMatchHeaders.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
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

  #NEED TO DO A GET AFTER THIS TO BE SURE IT HAS SAVED PROPERLY
  #HERE WE ARE COMPARING WHAT IS ON THE DATABASE (I.E. THE DATA IN THE SETUP FILES) WITH THE CALCULATED VALUES
  #IN THIS VALIDATION SCENARIO, THE HEADER AMOUNT VALUES SHOULD NOT MATCH
  Scenario: 13A - I Call GET endpoint for Transferred payload with Amount fields that will not match the lines
    When I query GET endpoint "/invoice/34"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                        | value                         | status  | message                                                                                    |
      | header.invoiceNumber        | EPI3659975                    | VALID   | null                                                                                       |
      | header.invoiceType          | E                             | VALID   | null                                                                                       |
      | header.invoiceStatus        | O                             | VALID   | null                                                                                       |
      | header.description          | This is another saved payload | VALID   | null                                                                                       |
      | totals.zeroVatAmount        | -4.25                         | WARNING | The net amount for zero VAT lines (-4.25) does not match the calculated value of -4.26     |
      | totals.specialVatAmount     | 7.01                          | WARNING | The net amount for mixed VAT lines (7.01) does not match the calculated value of 7.00      |
      | totals.stdVatAmount         | 11.99                         | WARNING | The net amount for standard VAT lines (11.99) does not match the calculated value of 12.00 |
      | totals.netAmount            | 14.75                         | WARNING | The net amount (14.75) does not match the calculated value of 14.74                        |
      | totals.vatAmount            | 2.74                          | WARNING | The VAT amount (2.74) does not match the calculated value of 2.75                          |
      | totals.totalAmount          | 17.50                         | WARNING | The invoice total (17.50) does not match the calculated value of 17.49                     |
      | lines[0].productCode        | 35594                         | VALID   | null                                                                                       |
      | lines[0].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[0].units              | 2.000                         | null    | null                                                                                       |
      | lines[0].unitCost           | 14.0000                       | null    | null                                                                                       |
      | lines[0].unitCostExVat      | 28.00                         | null    | null                                                                                       |
      | lines[0].vatCode            | S                             | null    | null                                                                                       |
      | lines[0].discountAmount     | 0                             | null    | null                                                                                       |
      | lines[0].vatAmount          | 5.60                          | null    | null                                                                                       |
      | lines[0].totalAmount        | 33.60                         | null    | null                                                                                       |
      | lines[0].productDescription | SWIZZLES LOVE HEART TIN       | VALID   | null                                                                                       |

      | lines[1].productCode        | 17125                         | VALID   | null                                                                                       |
      | lines[1].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[1].units              | 2.000                         | null    | null                                                                                       |
      | lines[1].unitCost           | -8.0000                       | null    | null                                                                                       |
      | lines[1].unitCostExVat      | -16.00                        | null    | null                                                                                       |
      | lines[1].vatCode            | S                             | null    | null                                                                                       |
      | lines[1].discountAmount     | 0                             | null    | null                                                                                       |
      | lines[1].vatAmount          | -3.20                         | null    | null                                                                                       |
      | lines[1].totalAmount        | -19.20                        | null    | null                                                                                       |
      | lines[1].productDescription | SWIZZELS MATLOW LOVE HEARTS   | VALID   | null                                                                                       |

      | lines[2].productCode        | 17125-A                       | VALID   | null                                                                                       |
      | lines[2].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[2].units              | 2.000                         | null    | null                                                                                       |
      | lines[2].unitCost           | -4.0000                       | null    | null                                                                                       |
      | lines[2].unitCostExVat      | -8.00                         | null    | null                                                                                       |
      | lines[2].vatCode            | L                             | null    | null                                                                                       |
      | lines[2].discountAmount     | 0                             | null    | null                                                                                       |
      | lines[2].vatAmount          | -0.40                         | null    | null                                                                                       |
      | lines[2].totalAmount        | -8.40                         | null    | null                                                                                       |
      | lines[2].productDescription | Fuel 1                        | VALID   | null                                                                                       |

      | lines[3].productCode        | 17125-C                       | VALID   | null                                                                                       |
      | lines[3].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[3].units              | 3.000                         | null    | null                                                                                       |
      | lines[3].unitCost           | 5.0000                        | null    | null                                                                                       |
      | lines[3].unitCostExVat      | 15.00                         | null    | null                                                                                       |
      | lines[3].vatCode            | L                             | null    | null                                                                                       |
      | lines[3].discountAmount     | 1.0000                        | null    | null                                                                                       |
      | lines[3].vatAmount          | 0.75                          | null    | null                                                                                       |
      | lines[3].totalAmount        | 14.75                         | null    | null                                                                                       |
      | lines[3].productDescription | Fuel 2                        | VALID   | null                                                                                       |

      | lines[4].productCode        | 17125-D                       | VALID   | null                                                                                       |
      | lines[4].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[4].units              | 30.000                        | null    | null                                                                                       |
      | lines[4].unitCost           | 0.0997                        | null    | null                                                                                       |
      | lines[4].unitCostExVat      | 2.99                          | null    | null                                                                                       |
      | lines[4].vatCode            | Z                             | null    | null                                                                                       |
      | lines[4].discountAmount     | 0                             | null    | null                                                                                       |
      | lines[4].vatAmount          | 0.00                          | null    | null                                                                                       |
      | lines[4].totalAmount        | 2.99                          | null    | null                                                                                       |
      | lines[4].productDescription | Nappies size 1                | VALID   | null                                                                                       |

      | lines[5].productCode        | 17125-E                       | VALID   | null                                                                                       |
      | lines[5].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[5].units              | 25.000                        | null    | null                                                                                       |
      | lines[5].unitCost           | 0.1100                        | null    | null                                                                                       |
      | lines[5].unitCostExVat      | 2.75                          | null    | null                                                                                       |
      | lines[5].vatCode            | X                             | null    | null                                                                                       |
      | lines[5].discountAmount     | 0.2500                        | null    | null                                                                                       |
      | lines[5].vatAmount          | 0.00                          | null    | null                                                                                       |
      | lines[5].totalAmount        | 2.50                          | null    | null                                                                                       |
      | lines[5].productDescription | Nappies size 2                | VALID   | null                                                                                       |

      | lines[6].productCode        | 17125-Ref                     | VALID   | null                                                                                       |
      | lines[6].unitWeight         | 0.000                         | null    | null                                                                                       |
      | lines[6].units              | 1.000                         | null    | null                                                                                       |
      | lines[6].unitCost           | -10.0000                      | null    | null                                                                                       |
      | lines[6].unitCostExVat      | -10.00                        | null    | null                                                                                       |
      | lines[6].vatCode            | X                             | null    | null                                                                                       |
      | lines[6].discountAmount     | 0                             | null    | null                                                                                       |
      | lines[6].vatAmount          | 0.00                          | null    | null                                                                                       |
      | lines[6].totalAmount        | -10.00                        | null    | null                                                                                       |
      | lines[6].productDescription | Some kind of refund           | VALID   | null                                                                                       |


  Scenario: 14 - I Call endpoint with Transferred payload with duplicate combination key fields
    Given request body is set to contents of file: testdata/validate/full_Invoice/TypeE_AllAmountsCorrectDuplicateNoID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                 | value      | status  | message                     |
      | header.invoiceNumber | EPI3659916 | INVALID | This invoice already exists |
      | header.invoiceType   | E          | INVALID | This invoice already exists |
      | header.invoiceDate   | 2020-12-14 | INVALID | This invoice already exists |
      | retailer.code        | 115225     | INVALID | This invoice already exists |
      | supplier.code        | NISA       | INVALID | This invoice already exists |


  Scenario: 15 - I Call endpoint with EDI payload with duplicate combination key fields
    Given request body is set to contents of file: testdata/validate/full_Invoice/EDI_Duplicate.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                 | value     | status  | message                     |
      | header.invoiceNumber | 2020556-A | INVALID | This invoice already exists |
      | supplier.generation  | 7510      | INVALID | This invoice already exists |
      | supplier.code        | NISA      | INVALID | This invoice already exists |

