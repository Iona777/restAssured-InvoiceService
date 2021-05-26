Feature: 009 Validate Lines endpoint

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


  Scenario: 02 I Call endpoint with invalid EDI lines payload
    Given request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value                                                   | status | message |
      | productCode        | COF0000199999999999999999999999999999999999999999999999 | null   | null    |
      | unitWeight         | abc                                                     | null   | null    |
      | units              | abc                                                     | null   | null    |
      | unitCost           | abc                                                     | null   | null    |
      | unitCostExVat      | abc                                                     | null   | null    |
      | vatPercent         | abc                                                     | null   | null    |
      | vatCode            | abc                                                     | null   | null    |
      | discountAmount     | abc                                                     | null   | null    |
      | vatAmount          | abc                                                     | null   | null    |
      | totalAmount        | abc                                                     | null   | null    |
      | productDescription | WAREHOUSE SERVICE CHG                                   | null   | null    |

# Total amount, unit cost ex vat and vat percent are wrong  and  vat amount is null on payload on purpose to check
# that there are calculated/looked up correctly
# Product code set to maximum length and includes special characters. Other fields set to large values
# (no lengths specified in requirements)
  Scenario: 03 I Call endpoint with valid transferred lines payload
    Given request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 1!£$%^&*(@)_-?A  | VALID  | null    |
      | unitWeight         | 99.9900          | VALID  | null    |
      | units              | 999.9900         | VALID  | null    |
      | unitCost           | 999.9900         | VALID  | null    |
      | unitCostExVat      | 999980.00        | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 99               | VALID  | null    |
      | vatAmount          | 199996.00        | VALID  | null    |
      | totalAmount        | 1199877.00       | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 04 I Call endpoint with valid transferred lines payload - VAT rounding check
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatRounding.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value           | status | message |
      | productCode        | 123             | VALID  | null    |
      | unitWeight         | 1.2             | VALID  | null    |
      | units              | 2.500           | VALID  | null    |
      | unitCost           | 0.0500          | VALID  | null    |
      | unitCostExVat      | 0.13            | VALID  | null    |
      | vatPercent         | 20.00           | VALID  | null    |
      | vatCode            | S               | VALID  | null    |
      | discountAmount     | 0               | VALID  | null    |
      | vatAmount          | 0.03            | VALID  | null    |
      | totalAmount        | 0.16            | VALID  | null    |
      | productDescription | Tiny Cuddly Toy | VALID  | null    |


  Scenario: 05 I Call endpoint with valid transferred lines payload - VAT rounding check - inside threshold -Upper
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatRoundingUpper.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 1.000            | VALID  | null    |
      | unitCost           | 20.0495          | VALID  | null    |
      | unitCostExVat      | 20.05            | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 4.00             | VALID  | null    |
      | totalAmount        | 24.05            | VALID  | null    |
      | productDescription | Large Cuddly Toy | VALID  | null    |

  Scenario: 06 I Call endpoint with valid transferred lines payload - VAT rounding check - inside threshold - lower
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatRoundingLower.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 1.000            | VALID  | null    |
      | unitCost           | 19.9505          | VALID  | null    |
      | unitCostExVat      | 19.95            | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 4.00             | VALID  | null    |
      | totalAmount        | 23.95            | VALID  | null    |
      | productDescription | Large Cuddly Toy | VALID  | null    |

    #If you use unit costs of 19.95 and 20.05 they will be just outside.

  Scenario: 07 I Call endpoint with valid transferred lines payload - VAT rounding check - outside threshold -Upper
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatRoundingOutsideUpper.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status    | message |
      | productCode        | 123              | VALID     | null    |
      | unitWeight         | 1.2              | VALID     | null    |
      | units              | 1.000            | VALID     | null    |
      | unitCost           | 20.05            | VALID     | null    |
      | unitCostExVat      | 20.05            | VALID     | null    |
      | vatPercent         | 20.00            | VALID     | null    |
      | vatCode            | S                | VALID     | null    |
      | discountAmount     | 0                | VALID     | null    |
      | vatAmount          | 4.00             | WARNING   | VAT amount 4.00 is different from the calculated value of 4.01 |
      | totalAmount        | 24.05            | VALID     | null    |
      | productDescription | Large Cuddly Toy | VALID     | null    |


  Scenario: 08 I Call endpoint with valid transferred lines payload - VAT rounding check - outside threshold - lower
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatRoundingOutsideLower.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status    | message |
      | productCode        | 123              | VALID     | null    |
      | unitWeight         | 1.2              | VALID     | null    |
      | units              | 1.000            | VALID     | null    |
      | unitCost           | 19.95            | VALID     | null    |
      | unitCostExVat      | 19.95            | VALID     | null    |
      | vatPercent         | 20.00            | VALID     | null    |
      | vatCode            | S                | VALID     | null    |
      | discountAmount     | 0                | VALID     | null    |
      | vatAmount          | 4.00             | WARNING   | VAT amount 4.00 is different from the calculated value of 3.99    |
      | totalAmount        | 23.95            | VALID     | null    |
      | productDescription | Large Cuddly Toy | VALID     | null    |



  Scenario: 09 I Call endpoint with invalid transferred lines payload - product code null
    Given request body is set to contents of file: testdata/validate/lines/validateLinesProductCodeNull.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message |
      | productCode        | null             | INVALID | The product code must not be blank    |
      | unitWeight         | 1.2              | VALID   | null    |
      | units              | 2.000            | VALID   | null    |
      | unitCost           | 7.5000           | VALID   | null    |
      | unitCostExVat      | 15.00            | VALID   | null    |
      | vatPercent         | 20.00            | VALID   | null    |
      | vatCode            | S                | VALID   | null    |
      | discountAmount     | 1.5              | VALID   | null    |
      | vatAmount          | 3.00             | VALID   | null    |
      | totalAmount        | 16.50            | VALID   | null    |
      | productDescription | Small Cuddly Toy | VALID   | null    |

  Scenario: 10 I Call endpoint with invalid transferred lines payload - product code white space
    Given request body is set to contents of file: testdata/validate/lines/validateLinesProductCodeWhitespace.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message |
      | productCode        | null             | INVALID | The product code must not be blank    |
      | unitWeight         | 1.2              | VALID   | null    |
      | units              | 2.000            | VALID   | null    |
      | unitCost           | 7.5000           | VALID   | null    |
      | unitCostExVat      | 15.00            | VALID   | null    |
      | vatPercent         | 20.00            | VALID   | null    |
      | vatCode            | S                | VALID   | null    |
      | discountAmount     | 1.5              | VALID   | null    |
      | vatAmount          | 3.00             | VALID   | null    |
      | totalAmount        | 16.50            | VALID   | null    |
      | productDescription | Small Cuddly Toy | VALID   | null    |

  Scenario: 11 I Call endpoint with valid transferred lines payload - unit weight null
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitWeightNull.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | null             | VALID  | null    |
      | units              | 1.0              | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 7.50             | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 1.50             | VALID  | null    |
      | totalAmount        | 9.00             | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 12 I Call endpoint with valid transferred lines payload - unit weight white space
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitWeightWhitespace.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | null             | VALID  | null    |
      | units              | 1.0              | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 7.50             | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 1.50             | VALID  | null    |
      | totalAmount        | 9.00             | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |


  Scenario: 13 I Call endpoint with valid transferred lines payload - unit weight non-numeric
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitWeightNonNumeric.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message                               |
      | productCode        | 123              | VALID   | null                                  |
      | unitWeight         | abc              | INVALID | The unit weight is not a valid number |
      | units              | 1.0              | VALID   | null                                  |
      | unitCost           | 7.5000           | VALID   | null                                  |
      | unitCostExVat      | 7.50             | VALID   | null                                  |
      | vatPercent         | 20.00            | VALID   | null                                  |
      | vatCode            | S                | VALID   | null                                  |
      | discountAmount     | 0                | VALID   | null                                  |
      | vatAmount          | 1.50             | VALID   | null                                  |
      | totalAmount        | 9.00             | VALID   | null                                  |
      | productDescription | Small Cuddly Toy | VALID   | null                                  |

  Scenario: 14 I Call endpoint with valid transferred lines payload - units null- default to 0
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitsNull.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 0                | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 0.00             | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 0.00             | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |


  Scenario: 15 I Call endpoint with valid transferred lines payload - units white space- default to 0
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitsWhitespace.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 0                | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 0.00             | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 0.00             | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 16 I Call endpoint with valid transferred lines payload - units negative
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitsNegative.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message |
      | productCode        | 123              | VALID   | null    |
      | unitWeight         | 1.2              | VALID   | null    |
      | units              | -1.00            | INVALID | Units must not be less than zero    |
      | unitCost           | 7.5000           | VALID   | null    |
      | unitCostExVat      | -7.50            | VALID   | null    |
      | vatPercent         | 20.00            | VALID   | null    |
      | vatCode            | S                | VALID   | null    |
      | discountAmount     | 0                | VALID   | null    |
      | vatAmount          | -1.50            | VALID   | null    |
      | totalAmount        | -9.00            | VALID   | null    |
      | productDescription | Small Cuddly Toy | VALID   | null    |


  Scenario: 17 I Call endpoint with invalid transferred lines payload - units non-numeric
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitsNonNumeric.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message                                   |
      | productCode        | 123              | VALID   | null                                      |
      | unitWeight         | 1.2              | VALID   | null                                      |
      | units              | abc              | INVALID | The number of units is not a valid number |
      | unitCost           | 7.5000           | VALID   | null                                      |
      | unitCostExVat      | 0.00             | VALID   | null                                      |
      | vatPercent         | 20.00            | VALID   | null                                      |
      | vatCode            | S                | VALID   | null                                      |
      | discountAmount     | 0                | VALID   | null                                      |
      | vatAmount          | 0.00             | VALID   | null                                      |
      | totalAmount        | 0.00             | VALID   | null                                      |
      | productDescription | Small Cuddly Toy | VALID   | null                                      |

  Scenario: 18 I Call endpoint with valid transferred lines payload - unit cost null - default to 0
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitCostNull.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 1.0              | VALID  | null    |
      | unitCost           | 0                | VALID  | null    |
      | unitCostExVat      | 0.00             | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 0.00             | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 19 I Call endpoint with valid transferred lines payload - unit cost whitepsace - default to 0
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitCostWhitespace.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 1.0              | VALID  | null    |
      | unitCost           | 0                | VALID  | null    |
      | unitCostExVat      | 0.00             | VALID  | null    |
      | vatPercent         | 20.00            | VALID  | null    |
      | vatCode            | S                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 0.00             | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 20 I Call endpoint with invalid transferred lines payload - unit cost non-numeric
    Given request body is set to contents of file: testdata/validate/lines/validateLinesUnitCostNonNumeric.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message                             |
      | productCode        | 123              | VALID   | null                                |
      | unitWeight         | 1.2              | VALID   | null                                |
      | units              | 1.0              | VALID   | null                                |
      | unitCost           | abc              | INVALID | The unit cost is not a valid number |
      | unitCostExVat      | 0.00             | VALID   | null                                |
      | vatPercent         | 20.00            | VALID   | null                                |
      | vatCode            | S                | VALID   | null                                |
      | discountAmount     | 0                | VALID   | null                                |
      | vatAmount          | 0.00             | VALID   | null                                |
      | totalAmount        | 0.00             | VALID   | null                                |
      | productDescription | Small Cuddly Toy | VALID   | null                                |

  Scenario: 21 I Call endpoint with valid transferred lines payload - VAT Code = Z
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCodeZ.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 2.000            | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 15.00            | VALID  | null    |
      | vatPercent         | 0.00             | VALID  | null    |
      | vatCode            | Z                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 15.00            | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 22 I Call endpoint with valid transferred lines payload - VAT Code = L
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCodeL.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 2.000            | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 15.00            | VALID  | null    |
      | vatPercent         | 5.00             | VALID  | null    |
      | vatCode            | L                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.75             | VALID  | null    |
      | totalAmount        | 15.75            | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |
    
    #VAT amount in payload is null so that service has to calculate it
  Scenario: 23 I Call endpoint with valid transferred lines payload - VAT Code = M
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCodeM.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 2.000            | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 15.00            | VALID  | null    |
      | vatPercent         | 5.00             | VALID  | null    |
      | vatCode            | M                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.75             | VALID  | null    |
      | totalAmount        | 15.75            | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 24 I Call endpoint with valid transferred lines payload - VAT Code = X
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCodeX.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 2.000            | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 15.00            | VALID  | null    |
      | vatPercent         | 0.00             | VALID  | null    |
      | vatCode            | X                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 15.00            | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 25 I Call endpoint with invalid transferred lines payload - VAT Code = A
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCodeA.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message                                             |
      | productCode        | 123              | VALID   | null                                                |
      | unitWeight         | 1.2              | VALID   | null                                                |
      | units              | 2.000            | VALID   | null                                                |
      | unitCost           | 7.5000           | VALID   | null                                                |
      | unitCostExVat      | 15.00            | VALID   | null                                                |
      | vatPercent         | null             | INVALID | The VAT code must be 'L', 'M', 'R', 'S', 'X' or 'Z' |
      | vatCode            | A                | INVALID | The VAT code must be 'L', 'M', 'R', 'S', 'X' or 'Z' |
      | discountAmount     | 0                | VALID   | null                                                |
      | vatAmount          | 0.00             | VALID   | null                                                |
      | totalAmount        | 15.00            | VALID   | null                                                |
      | productDescription | Small Cuddly Toy | VALID   | null                                                |

  Scenario: 26 I Call endpoint with valid transferred lines payload - discount null- default to 0
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDiscountNull.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 2.000            | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 15.00            | VALID  | null    |
      | vatPercent         | 0.00             | VALID  | null    |
      | vatCode            | X                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 15.00            | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |


  Scenario: 27 I Call endpoint with valid transferred lines payload - discount white space- default to 0
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDiscountWhiteSpace.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status | message |
      | productCode        | 123              | VALID  | null    |
      | unitWeight         | 1.2              | VALID  | null    |
      | units              | 2.000            | VALID  | null    |
      | unitCost           | 7.5000           | VALID  | null    |
      | unitCostExVat      | 15.00            | VALID  | null    |
      | vatPercent         | 0.00             | VALID  | null    |
      | vatCode            | X                | VALID  | null    |
      | discountAmount     | 0                | VALID  | null    |
      | vatAmount          | 0.00             | VALID  | null    |
      | totalAmount        | 15.00            | VALID  | null    |
      | productDescription | Small Cuddly Toy | VALID  | null    |

  Scenario: 28 I Call endpoint with invalid transferred lines payload - discount non-numeric
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDiscountNonNumeric.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message                                   |
      | productCode        | 123              | VALID   | null                                      |
      | unitWeight         | 1.2              | VALID   | null                                      |
      | units              | 2.000            | VALID   | null                                      |
      | unitCost           | 7.5000           | VALID   | null                                      |
      | unitCostExVat      | 15.00            | VALID   | null                                      |
      | vatPercent         | 0.00             | VALID   | null                                      |
      | vatCode            | X                | VALID   | null                                      |
      | discountAmount     | abc              | INVALID | The discount amount is not a valid number |
      | vatAmount          | 0.00             | VALID   | null                                      |
      | totalAmount        | 15.00            | VALID   | null                                      |
      | productDescription | Small Cuddly Toy | VALID   | null                                      |


  Scenario: 29 I Call endpoint with valid transferred lines payload - description 6 characters long
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescription6Chars.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value  | status | message |
      | productCode        | 123    | VALID  | null    |
      | unitWeight         | 1.2    | VALID  | null    |
      | units              | 2.000  | VALID  | null    |
      | unitCost           | 7.5000 | VALID  | null    |
      | unitCostExVat      | 15.00  | VALID  | null    |
      | vatPercent         | 0.00   | VALID  | null    |
      | vatCode            | Z      | VALID  | null    |
      | discountAmount     | 0      | VALID  | null    |
      | vatAmount          | 0.00   | VALID  | null    |
      | totalAmount        | 15.00  | VALID  | null    |
      | productDescription | 123456 | VALID  | null    |

  Scenario: 30 I Call endpoint with valid transferred lines payload - description 40 characters long
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescription40Chars.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value                                    | status | message |
      | productCode        | 123                                      | VALID  | null    |
      | unitWeight         | 1.2                                      | VALID  | null    |
      | units              | 2.000                                    | VALID  | null    |
      | unitCost           | 7.5000                                   | VALID  | null    |
      | unitCostExVat      | 15.00                                    | VALID  | null    |
      | vatPercent         | 0.00                                     | VALID  | null    |
      | vatCode            | Z                                        | VALID  | null    |
      | discountAmount     | 0                                        | VALID  | null    |
      | vatAmount          | 0.00                                     | VALID  | null    |
      | totalAmount        | 15.00                                    | VALID  | null    |
      | productDescription | 1234567891123456789212345678931234567894 | VALID  | null    |


  Scenario: 31 I Call endpoint with invalid transferred lines payload - description 5 characters long
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescription5Chars.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value  | status  | message                                                  |
      | productCode        | 123    | VALID   | null                                                     |
      | unitWeight         | 1.2    | VALID   | null                                                     |
      | units              | 2.000  | VALID   | null                                                     |
      | unitCost           | 7.5000 | VALID   | null                                                     |
      | unitCostExVat      | 15.00  | VALID   | null                                                     |
      | vatPercent         | 0.00   | VALID   | null                                                     |
      | vatCode            | Z      | VALID   | null                                                     |
      | discountAmount     | 0      | VALID   | null                                                     |
      | vatAmount          | 0.00   | VALID   | null                                                     |
      | totalAmount        | 15.00  | VALID   | null                                                     |
      | productDescription | 12345  | INVALID | The product description must be longer than 5 characters |

  Scenario: 32 I Call endpoint with valid transferred lines payload - description 41 characters long
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescription41Chars.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value                                     | status  | message                                                    |
      | productCode        | 123                                       | VALID   | null                                                       |
      | unitWeight         | 1.2                                       | VALID   | null                                                       |
      | units              | 2.000                                     | VALID   | null                                                       |
      | unitCost           | 7.5000                                    | VALID   | null                                                       |
      | unitCostExVat      | 15.00                                     | VALID   | null                                                       |
      | vatPercent         | 0.00                                      | VALID   | null                                                       |
      | vatCode            | Z                                         | VALID   | null                                                       |
      | discountAmount     | 0                                         | VALID   | null                                                       |
      | vatAmount          | 0.00                                      | VALID   | null                                                       |
      | totalAmount        | 15.00                                     | VALID   | null                                                       |
      | productDescription | 12345678911234567892123456789312345678941 | INVALID | The product description must be shorter than 41 characters |

  Scenario: 33 I Call endpoint with invalid transferred lines payload - description null
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescriptionNull.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value  | status  | message                                   |
      | productCode        | 123    | VALID   | null                                      |
      | unitWeight         | 1.2    | VALID   | null                                      |
      | units              | 2.000  | VALID   | null                                      |
      | unitCost           | 7.5000 | VALID   | null                                      |
      | unitCostExVat      | 15.00  | VALID   | null                                      |
      | vatPercent         | 0.00   | VALID   | null                                      |
      | vatCode            | Z      | VALID   | null                                      |
      | discountAmount     | 0      | VALID   | null                                      |
      | vatAmount          | 0.00   | VALID   | null                                      |
      | totalAmount        | 15.00  | VALID   | null                                      |
      | productDescription | null   | INVALID | The product description must not be blank |

  Scenario: 34 I Call endpoint with invalid transferred lines payload - description white space
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescriptionWhitespace.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value  | status  | message                                   |
      | productCode        | 123    | VALID   | null                                      |
      | unitWeight         | 1.2    | VALID   | null                                      |
      | units              | 2.000  | VALID   | null                                      |
      | unitCost           | 7.5000 | VALID   | null                                      |
      | unitCostExVat      | 15.00  | VALID   | null                                      |
      | vatPercent         | 0.00   | VALID   | null                                      |
      | vatCode            | Z      | VALID   | null                                      |
      | discountAmount     | 0      | VALID   | null                                      |
      | vatAmount          | 0.00   | VALID   | null                                      |
      | totalAmount        | 15.00  | VALID   | null                                      |
      | productDescription | null   | INVALID | The product description must not be blank |


  Scenario: 35 I Call endpoint with invalid transferred lines payload - description leading spaces and full stops
    Given request body is set to contents of file: testdata/validate/lines/validateLinesDescriptionLeadingChars.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value  | status  | message                                                  |
      | productCode        | 123    | VALID   | null                                                     |
      | unitWeight         | 1.2    | VALID   | null                                                     |
      | units              | 2.000  | VALID   | null                                                     |
      | unitCost           | 7.5000 | VALID   | null                                                     |
      | unitCostExVat      | 15.00  | VALID   | null                                                     |
      | vatPercent         | 0.00   | VALID   | null                                                     |
      | vatCode            | Z      | VALID   | null                                                     |
      | discountAmount     | 0      | VALID   | null                                                     |
      | vatAmount          | 0.00   | VALID   | null                                                     |
      | totalAmount        | 15.00  | VALID   | null                                                     |
      | productDescription | 123    | INVALID | The product description must be longer than 5 characters |



  Scenario: 36 I Call endpoint with warning transferred lines payload - vat amount warning
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatAmtWarning.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value            | status  | message |
      | productCode        | 123              | VALID   | null    |
      | unitWeight         | 1.0              | VALID   | null    |
      | units              | 1.0              | VALID   | null    |
      | unitCost           | 7.5000           | VALID   | null    |
      | unitCostExVat      | 7.50             | VALID   | null    |
      | vatPercent         | 20.00            | VALID   | null    |
      | vatCode            | S                | VALID   | null    |
      | discountAmount     | 0                | VALID   | null    |
      | vatAmount          | 10.00            | WARNING | VAT amount 10.00 is different from the calculated value of 1.50    |
      | totalAmount        | 17.50            | VALID   | null    |
      | productDescription | Small Cuddly Toy | VALID   | null    |

  Scenario: 37 I Call endpoint with valid transferred lines payload - zero vat amount - standard code - vat calculated
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCalculationZeroValue.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value           | status | message |
      | productCode        | 123             | VALID  | null    |
      | unitWeight         | 1.2             | VALID  | null    |
      | units              | 1.000           | VALID  | null    |
      | unitCost           | 20.00           | VALID  | null    |
      | unitCostExVat      | 20.00           | VALID  | null    |
      | vatPercent         | 20.00           | VALID  | null    |
      | vatCode            | S               | VALID  | null    |
      | discountAmount     | 0               | VALID  | null    |
      | vatAmount          | 4.00            | VALID  | null    |
      | totalAmount        | 24.00           | VALID  | null    |
      | productDescription | Tiny Cuddly Toy | VALID  | null    |

  Scenario: 38 I Call endpoint with valid transferred lines payload - non zero vat amount - standard code - vat not calculated
    Given request body is set to contents of file: testdata/validate/lines/validateLinesVatCalculationNonZeroValue.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item               | value           | status  | message                                                        |
      | productCode        | 123             | VALID   | null                                                           |
      | unitWeight         | 1.2             | VALID   | null                                                           |
      | units              | 1.000           | VALID   | null                                                           |
      | unitCost           | 20.00           | VALID   | null                                                           |
      | unitCostExVat      | 20.00           | VALID   | null                                                           |
      | vatPercent         | 20.00           | VALID   | null                                                           |
      | vatCode            | S               | VALID   | null                                                           |
      | discountAmount     | 0               | VALID   | null                                                           |
      | vatAmount          | 1.23            | WARNING | VAT amount 1.23 is different from the calculated value of 4.00 |
      | totalAmount        | 21.23           | VALID   | null                                                           |
      | productDescription | Tiny Cuddly Toy | VALID   | null                                                           |
