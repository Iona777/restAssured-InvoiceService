Feature: 007 Validate Supplier endpoint

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

  Scenario: 02 I Call endpoint with valid EDI supplier code payload
    Given request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    #Generation not validated for EDI, so status will be null
    And The following values are present in the response:
      | item          | value              | status | message |
      | generation    | 7510               | null   | null    |
      | code          | NISA               | VALID  | null    |
      | name          | NISAWAY            | VALID  | null    |
      | addressLine1  | P.O BOX 58         | VALID  | null    |
      | addressLine2  | SCUNTHORPE         | VALID  | null    |
      | addressLine3  | NORTH LINCOLNSHIRE | VALID  | null    |
      | addressLine4  | Someplace          | VALID  | null    |
      | postcode      | DN15 8QQ           | VALID  | null    |
      | partnerStatus | L                  | VALID  | null    |



  Scenario: 03 I Call endpoint with invalid EDI supplier code  payload
    Given request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    #Generation not validated for EDI, so value is whatever you pass in
    And The following values are present in the response:
      | item          | value | status  | message                        |
      | generation    | 7510  | null    | null                           |
      | code          | Blah  | INVALID | Supplier 'Blah' does not exist |
      | name          | null  | null    | null                           |
      | addressLine1  | null  | null    | null                           |
      | addressLine2  | null  | null    | null                           |
      | addressLine3  | null  | null    | null                           |
      | addressLine4  | null  | null    | null                           |
      | postcode      | null  | null    | null                           |
      | partnerStatus | null  | null    | null                           |



  Scenario: 04 I Call endpoint with null EDI supplier code  payload
    Given request body is set to contents of file: testdata/validate/supplier/validateNullSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    #Generation not validated for EDI, so value is whatever you pass in
    And The following values are present in the response:
      | item          | value | status  | message                             |
      | generation    | 7510  | null    | null                                |
      | code          | null  | INVALID | The supplier code must not be blank |
      | name          | null  | null    | null                                |
      | addressLine1  | null  | null    | null                                |
      | addressLine2  | null  | null    | null                                |
      | addressLine3  | null  | null    | null                                |
      | addressLine4  | null  | null    | null                                |
      | postcode      | null  | null    | null                                |
      | partnerStatus | null  | null    | null                                |


  Scenario: 05 I Call endpoint with valid Transferred supplier generation payload
    Given request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeTrans.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value             | status | message |
      | generation    | 1                 | VALID  | null    |
      | code          | ZBRB              | VALID  | null    |
      | name          | BROADBAND CHARGES | VALID  | null    |
      | addressLine1  | HEAD OFFICE       | VALID  | null    |
      | addressLine2  | HARVEST MILLS     | VALID  | null    |
      | addressLine3  | DUNNINGTON        | VALID  | null    |
      | addressLine4  | YORK              | VALID  | null    |
      | postcode      | YO19 5RY          | VALID  | null    |
      | partnerStatus | T                 | VALID  | null    |

  Scenario: 06 I Call endpoint with invalid Transferred supplier generation=0  payload
    Given request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value             | status  | message                                                           |
      | generation    | 0                 | INVALID | The generation number is less than the minimum allowed value of 1 |
      | code          | ZBRB              | VALID   | null                                                              |
      | name          | BROADBAND CHARGES | VALID   | null                                                              |
      | addressLine1  | HEAD OFFICE       | VALID   | null                                                              |
      | addressLine2  | HARVEST MILLS     | VALID   | null                                                              |
      | addressLine3  | DUNNINGTON        | VALID   | null                                                              |
      | addressLine4  | YORK              | VALID   | null                                                              |
      | postcode      | YO19 5RY          | VALID   | null                                                              |
      | partnerStatus | T                 | VALID   | null                                                              |

  Scenario: 07 I Call endpoint with invalid Transferred supplier generation=10000  payload
    Given request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-10000.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value             | status  | message                                                           |
      | generation    | 10000             | INVALID | The generation number is greater than the maximum allowed value of 9999 |
      | code          | ZBRB              | VALID   | null                                                              |
      | name          | BROADBAND CHARGES | VALID   | null                                                              |
      | addressLine1  | HEAD OFFICE       | VALID   | null                                                              |
      | addressLine2  | HARVEST MILLS     | VALID   | null                                                              |
      | addressLine3  | DUNNINGTON        | VALID   | null                                                              |
      | addressLine4  | YORK              | VALID   | null                                                              |
      | postcode      | YO19 5RY          | VALID   | null                                                              |
      | partnerStatus | T                 | VALID   | null                                                              |

    #Requirement change - generation numbers can be null now
  Scenario: 08 I Call endpoint with null Transferred supplier generation payload
    Given request body is set to contents of file: testdata/validate/supplier/validateNullSupplierGen.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value             | status | message |
      | generation    | null              | VALID  | null    |
      | code          | ZBRB              | VALID  | null    |
      | name          | BROADBAND CHARGES | VALID  | null    |
      | addressLine1  | HEAD OFFICE       | VALID  | null    |
      | addressLine2  | HARVEST MILLS     | VALID  | null    |
      | addressLine3  | DUNNINGTON        | VALID  | null    |
      | addressLine4  | YORK              | VALID  | null    |
      | postcode      | YO19 5RY          | VALID  | null    |
      | partnerStatus | T                 | VALID  | null    |

  Scenario: 09 I Call endpoint with invalid Transferred supplier generation=abc payload
    Given request body is set to contents of file: testdata/validate/supplier/validateNaNSupplierGen.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value             | status  | message                                     |
      | generation    | abc               | INVALID | The generation number is not a valid number |
      | code          | ZBRB              | VALID   | null                                        |
      | name          | BROADBAND CHARGES | VALID   | null                                        |
      | addressLine1  | HEAD OFFICE       | VALID   | null                                        |
      | addressLine2  | HARVEST MILLS     | VALID   | null                                        |
      | addressLine3  | DUNNINGTON        | VALID   | null                                        |
      | addressLine4  | YORK              | VALID   | null                                        |
      | postcode      | YO19 5RY          | VALID   | null                                        |
      | partnerStatus | T                 | VALID   | null                                        |