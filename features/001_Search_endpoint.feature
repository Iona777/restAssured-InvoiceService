@001
Feature: 001 Search endpoint

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

  Scenario: 02 - Search with no parameters
    When I query GET endpoint "/search/invoice"
    Then I should receive response status code 200
    And I should receive a list of 500 entries

  Scenario: 03 - Search by full invoice number
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    And I verify the following values are present in the response:
      | id | item           | value                 |
      | 20 | invoiceNumber  | EPI3658757            |
      | 20 | yearNumber     | 2021                  |
      | 20 | weekNumber     | 3                     |
      | 20 | memberCode     | 19731                 |
      | 20 | memberName     | MR A WILKINS ROBINSON |
      | 20 | supplierCode   | NISA                  |
      | 20 | supplierName   | NISAWAY               |
      | 20 | invoiceDate    | 2020-12-14            |
      | 20 | invoiceType    | E                     |
      | 20 | totalAmount    | 119.46                |
      | 20 | invoiceStatus  | O                     |
      | 20 | generationType | DR                    |
      | 20 | ediInvoice     | N                     |

  Scenario: 04 - Search by partial invoice number
    When I query GET endpoint "/search/invoice?invoiceNumber=365"
    Then I should receive response status code 200
    And I should receive a list of 33 entries
    And I verify the following values are present in the response:
      | id | item          | value      |
      | 10 | invoiceNumber | EPI3659433 |
      | 20 | invoiceNumber | EPI3658757 |
      | 30 | invoiceNumber | EPI3659700 |
      | 40 | invoiceNumber | EPI3659272 |

  Scenario: 05 - Search by unknown invoice number
    When I query GET endpoint "/search/invoice?invoiceNumber=XXXXXXXX"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 06 - Search by member code
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200
    And I should receive a list of 6 entries
    And I verify the following values are present in the response:
      | id    | item       | value |
      | 19    | memberCode | 23406 |
      | 527   | memberCode | 23406 |
      | 549   | memberCode | 23406 |
      | 943   | memberCode | 23406 |
      | 42EDI | memberCode | 23406 |

  Scenario: 07 - Search by partial member code
    When I query GET endpoint "/search/invoice?memberCode=1085"
    Then I should receive response status code 200
    And I should receive a list of 7 entries
    And I verify the following values are present in the response:
      | id  | item       | value  |
      | 47  | memberCode | 108511 |
      | 97  | memberCode | 108538 |
      | 132 | memberCode | 108538 |
      | 168 | memberCode | 108538 |
      | 333 | memberCode | 108592 |

  Scenario: 08 - Search by unknown member code
    When I query GET endpoint "/search/invoice?memberCode=XXXX"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 09 - Search by member name
    When I query GET endpoint "/search/invoice?memberName=CHARLES%25WALSH"
    Then I should receive response status code 200
    And I should receive a list of 2 entries
    And The following JSON values are present in the response:
      | item           | value         |
      | [0].id         | 3             |
      | [0].memberName | CHARLES WALSH |
      | [1].id         | 239             |
      | [1].memberName | CHARLES WALSH |


  Scenario: 10 - Search by partial member name
    When I query GET endpoint "/search/invoice?memberName=SONS"
    Then I should receive response status code 200
    And I should receive a list of 41 entries
    And I verify the following values are present in the response:
      | id    | item       | value                          |
      | 202   | memberName | WILSONS RETAIL LTD             |
      | 305   | memberName | J THOMAS & SONS (ABERAERON)LTD |
      | 843   | memberName | ANDREW PARSONS                 |
      | 943   | memberName | W.M.MOUTRAY & SONS             |
      | 42EDI | memberName | W.M.MOUTRAY & SONS             |

  Scenario: 11 - Search by unknown member name
    When I query GET endpoint "/search/invoice?memberName=XXXX"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 12 - Search by supplier code
    When I query GET endpoint "/search/invoice?supplierCode=ZBRB"
    Then I should receive response status code 200
    And I should receive a list of 104 entries
    And I verify the following values are present in the response:
      | id  | item         | value |
      | 470 | supplierCode | ZBRB  |
      | 510 | supplierCode | ZBRB  |
      | 513 | supplierCode | ZBRB  |
      | 527 | supplierCode | ZBRB  |
      | 999 | supplierCode | ZBRB  |

  Scenario: 12.1 - Search by partial supplier code
    When I query GET endpoint "/search/invoice?supplierCode=C"
    Then I should receive response status code 200
    And I should receive a list of 246 entries
    And I verify the following values are present in the response:
      | id  | item         | value |
      | 484 | supplierCode | ZCRSM  |
      | 123 | supplierCode | ZCRSH  |


  Scenario: 13 - Search by unknown supplier code
    When I query GET endpoint "/search/invoice?supplierCode=XXXX"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 14 - Search by supplier name
    When I query GET endpoint "/search/invoice?supplierName=BROADBAND%20CHARGES"
    Then I should receive response status code 200
    And I should receive a list of 104 entries
    And I verify the following values are present in the response:
      | id  | item         | value             |
      | 470 | supplierName | BROADBAND CHARGES |
      | 510 | supplierName | BROADBAND CHARGES |
      | 513 | supplierName | BROADBAND CHARGES |
      | 527 | supplierName | BROADBAND CHARGES |
      | 999 | supplierName | BROADBAND CHARGES |

  Scenario: 15 - Search by partial supplier name
    When I query GET endpoint "/search/invoice?supplierName=BROADBAND"
    Then I should receive response status code 200
    And I should receive a list of 104 entries
    And I verify the following values are present in the response:
      | id  | item         | value             |
      | 470 | supplierName | BROADBAND CHARGES |
      | 510 | supplierName | BROADBAND CHARGES |
      | 513 | supplierName | BROADBAND CHARGES |
      | 527 | supplierName | BROADBAND CHARGES |
      | 999 | supplierName | BROADBAND CHARGES |

  Scenario: 16 - Search by unknown supplier name
    When I query GET endpoint "/search/invoice?supplierName=XXXX"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 17 - Search by invoice type
    When I query GET endpoint "/search/invoice?invoiceType=E"
    Then I should receive response status code 200
    And I should receive a list of 86 entries
    And I verify the following values are present in the response:
      | id    | item        | value |
      | 6EDI  | invoiceType | E     |
      | 16EDI | invoiceType | E     |
      | 31EDI | invoiceType | E     |
      | 6     | invoiceType | E     |
      | 29    | invoiceType | E     |
      | 44    | invoiceType | E     |

  Scenario: 18 - Search by unknown invoice type
    When I query GET endpoint "/search/invoice?invoiceType=XXXX"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 19 - Search by week number
    When I query GET endpoint "/search/invoice?weekNumber=2"
    Then I should receive response status code 200
    And I should receive a list of 4 entries
    And I verify the following values are present in the response:
      | id | item       | value |
      | 2  | weekNumber | 2     |
      | 3  | weekNumber | 2     |
      | 4  | weekNumber | 2     |
      | 5  | weekNumber | 2     |


  Scenario: 20 - Search by unknown week number
    When I query GET endpoint "/search/invoice?weekNumber=123"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 21 - Search by year number
    When I query GET endpoint "/search/invoice?yearNumber=2020"
    Then I should receive response status code 200
    And I should receive a list of 5 entries
    And I verify the following values are present in the response:
      | id | item       | value |
      | 7  | yearNumber | 2020  |
      | 8  | yearNumber | 2020  |
      | 9  | yearNumber | 2020  |
      | 10 | yearNumber | 2020  |
      | 11 | yearNumber | 2020  |

  Scenario: 22 - Search by unknown year number
    When I query GET endpoint "/search/invoice?yearNumber=1900"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 23 - Search by min date only
    When I query GET endpoint "/search/invoice?minDate=2021-02-14"
    Then I should receive response status code 200
    And I should receive a list of 38 entries
    And I verify the following values are present in the response:
      | id    | item        | value      |
      | 613   | invoiceDate | 2030-08-06 |
      | 10EDI | invoiceDate | 2021-02-14 |
      | 15EDI | invoiceDate | 2021-02-14 |
      | 20EDI | invoiceDate | 2021-02-14 |


  Scenario: 24 - Search by max date only
    When I query GET endpoint "/search/invoice?maxDate=2020-12-14"
    Then I should receive response status code 200
    And I should receive a list of 30 entries
    And I verify the following values are present in the response:
      | id | item        | value      |
      | 9  | invoiceDate | 2020-12-14 |
      | 14 | invoiceDate | 2020-12-14 |
      | 26 | invoiceDate | 2020-12-14 |
      | 33 | invoiceDate | 2020-12-14 |
      | 49 | invoiceDate | 2020-12-11 |

  Scenario: 25 - Search by date range
    When I query GET endpoint "/search/invoice?minDate=2020-12-16&maxDate=2020-12-16"
    Then I should receive response status code 200
    And I should receive a list of 3 entries
    And I verify the following values are present in the response:
      | id | item        | value      |
      | 1  | invoiceDate | 2020-12-16 |
      | 6  | invoiceDate | 2020-12-16 |
      | 7  | invoiceDate | 2020-12-16 |

  Scenario: 26 - Search by full EDI invoice number
    When I query GET endpoint "/search/invoice?invoiceNumber=3725077"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    And I verify the following values are present in the response:
      | id   | item           | value          |
      | 7EDI | invoiceNumber  | 3725077        |
      | 7EDI | yearNumber     | <null>         |
      | 7EDI | weekNumber     | <null>         |
      | 7EDI | memberCode     | 113488         |
      | 7EDI | memberName     | EBOR FRANCHISE |
      | 7EDI | supplierCode   | CAMB           |
      | 7EDI | supplierName   | COOP AMBIENT   |
      | 7EDI | invoiceDate    | 2021-02-14     |
      | 7EDI | invoiceType    | E              |
      | 7EDI | totalAmount    | 4.95           |
      | 7EDI | invoiceStatus  | P              |
      | 7EDI | generationType | DR             |
      | 7EDI | ediInvoice     | Y              |

  Scenario: 27 - Search for EDI by supplier code
    When I query GET endpoint "/search/invoice?supplierCode=CAMB"
    Then I should receive response status code 200
    And I should receive a list of 18 entries
    And I verify the following values are present in the response:
      | id    | item         | value |
      | 8EDI  | supplierCode | CAMB  |
      | 11EDI | supplierCode | CAMB  |
      | 24EDI | supplierCode | CAMB  |
      | 47EDI | supplierCode | CAMB  |


  Scenario: 28 - Search for EDI by partial supplier name
    When I query GET endpoint "/search/invoice?supplierName=AMBIENT"
    Then I should receive response status code 200
    And I should receive a list of 18 entries
    And I verify the following values are present in the response:
      | id    | item         | value        |
      | 7EDI  | supplierName | COOP AMBIENT |
      | 11EDI | supplierName | COOP AMBIENT |
      | 25EDI | supplierName | COOP AMBIENT |
      | 48EDI | supplierName | COOP AMBIENT |
      | 49EDI | supplierName | COOP AMBIENT |

  Scenario: 29 - Search for transferred invoices
    When I query GET endpoint "/search/invoice?isEdi=N&invoiceNumber=98"
    Then I should receive response status code 200
    And I should receive a list of 21 entries
    And I verify the following values are present in the response:
      | id  | item       | value |
      | 328 | ediInvoice | N     |
      | 610 | ediInvoice | N     |
      | 633 | ediInvoice | N     |
      | 771 | ediInvoice | N     |
      | 895 | ediInvoice | N     |

  Scenario: 30 - Search for EDI invoices
    When I query GET endpoint "/search/invoice?isEdi=Y"
    Then I should receive response status code 200
    And I should receive a list of 37 entries
    And I verify the following values are present in the response:
      | id    | item       | value |
      | 7EDI  | ediInvoice | Y     |
      | 10EDI | ediInvoice | Y     |
      | 24EDI | ediInvoice | Y     |
      | 31EDI | ediInvoice | Y     |
      | 41EDI | ediInvoice | Y     |

  Scenario: 31 - Search by invoice status
    When I query GET endpoint "/search/invoice?invoiceStatus=A"
    Then I should receive response status code 200
    And I should receive a list of 8 entries
    And I verify the following values are present in the response:
      | id    | item          | value |
      | 131   | invoiceStatus | A     |
      | 133   | invoiceStatus | A     |
      | 135   | invoiceStatus | A     |
      | 43EDI | invoiceStatus | A     |
      | 47EDI | invoiceStatus | A     |

  Scenario: 32 - Search by generation type
    When I query GET endpoint "/search/invoice?generationType=CR"
    Then I should receive response status code 200
    And I should receive a list of 28 entries
    And I verify the following values are present in the response:
      | id   | item           | value |
      | 54   | generationType | CR    |
      | 70   | generationType | CR    |
      | 74   | generationType | CR    |
      | 82   | generationType | CR    |
      | 3EDI | generationType | CR    |


  Scenario: 33 - Search by combination fields - Invoice Number and  Member Code
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757&memberName=19731"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    And I verify the following values are present in the response:
      | id | item           | value                 |
      | 20 | invoiceNumber  | EPI3658757            |
      | 20 | yearNumber     | 2021                  |
      | 20 | weekNumber     | 3                     |
      | 20 | memberCode     | 19731                 |
      | 20 | memberName     | MR A WILKINS ROBINSON |
      | 20 | supplierCode   | NISA                  |
      | 20 | supplierName   | NISAWAY               |
      | 20 | invoiceDate    | 2020-12-14            |
      | 20 | invoiceType    | E                     |
      | 20 | totalAmount    | 119.46                |
      | 20 | invoiceStatus  | O                     |
      | 20 | generationType | DR                    |
      | 20 | ediInvoice     | N                     |

  Scenario: 34 - Search by combination fields - Member Name and Supplier Name
    When I query GET endpoint "/search/invoice?memberName=MR%20A%20WILKINS%20ROBINSON&supplierName=NISAWAY"
    Then I should receive response status code 200
    And I should receive a list of 68 entries
    And I verify the following values are present in the response:
      | id    | item          | value                 |
      | 20    | memberName    | MR A WILKINS ROBINSON |
      | 20    | supplierName  | NISAWAY               |

  Scenario: 35 - Search by combination fields - Valid and Invalid Fields
    When I query GET endpoint "/search/invoice?invoiceNumber=InvalidValue&memberName=InvalidValue&supplierName=NISAWAY"
    Then I should receive response status code 200
    And I should receive a list of 66 entries
    And I verify the following values are present in the response:
      | id   | item          | value                 |
      | 1    | supplierName  | NISAWAY               |
      | 7    | supplierName  | NISAWAY               |
      | 20   | supplierName  | NISAWAY               |

