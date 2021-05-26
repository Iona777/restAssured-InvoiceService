Feature: 005 Invoice Headers validation

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


  Scenario: 01 - Given valid invoiceNumber should be marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_number_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value          | status | message |
      | invoiceNumber | 14012021115000 | VALID  | null    |


  Scenario: 02 - Given empty invoiceNumber should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_number_empty.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value | status  | message                              |
      | invoiceNumber | null  | INVALID | The invoice number must not be blank |

  Scenario: 03 - Given null invoiceNumber should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_number_null.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value | status  | message                              |
      | invoiceNumber | null  | INVALID | The invoice number must not be blank |

  Scenario: 04 - Given invoiceNumber character longer than 17 should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_number_too_long.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value              | status  | message                                               |
      | invoiceNumber | 140120211150005267 | INVALID | The invoice number must be shorter than 18 characters |

  Scenario: 05 - Given invoiceNumber character longer than <= 17 with extra spaces should be trimmed and marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_number_extra_spaces.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value             | status | message |
      | invoiceNumber | 14012021115000000 | VALID  | null    |

  Scenario: 06 - Given invoiceType "M" should marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_type_m_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status | message |
      | invoiceType | M     | VALID  | null    |

  Scenario: 07 - Given invoiceType "I" should marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_type_i_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status | message |
      | invoiceType | I     | VALID  | null    |

  Scenario: 08 - Given invoiceType "E" should marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_type_e_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status | message |
      | invoiceType | E     | VALID  | null    |

  Scenario: 09 - Given invoiceType not E, I, or M, should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_type_o_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status  | message                                  |
      | invoiceType | O     | INVALID | The invoice type must be 'E', 'I' or 'M' |

  Scenario: 11 - Given invoiceType is empty should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_type_empty_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status  | message                                  |
      | invoiceType |       | INVALID | The invoice type must be 'E', 'I' or 'M' |

  Scenario: 12 - Given invoiceType is null should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_type_null_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status  | message                                  |
      | invoiceType | null  | INVALID | The invoice type must be 'E', 'I' or 'M' |

  Scenario: 13 - Given invoiceDate is null should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_date_null_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status  | message                            |
      | invoiceDate | null  | INVALID | The invoice date must not be blank |

  Scenario: 14 - Given invoiceDate is empty should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_date_empty_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status  | message                            |
      | invoiceDate | null  | INVALID | The invoice date must not be blank |

  Scenario: 15 - Given invoiceDate in future and type is I should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_date_I_future_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value      | status  | message                                                                    |
      | invoiceDate | 2040-03-10 | INVALID | This invoice type cannot be assigned an invoice date that is in the future |

  Scenario: 16 - Given invoiceDate in future and type is M should marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_date_M_future_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value      | status  | message                                                                    |
      | invoiceDate | 2040-03-10 | INVALID | This invoice type cannot be assigned an invoice date that is in the future |

  Scenario: 17 - Given weekNumber 0 should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_week_0_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status  | message                                                     |
      | weekNumber | 0     | INVALID | The week number is less than the minimum allowed value of 1 |

  Scenario: 18 - Given weekNumber 54 should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_week_54_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status  | message                                                         |
      | weekNumber | 54    | INVALID | The week number is greater than the maximum allowed value of 53 |

  Scenario: 19 - Given non-numeric weekNumber should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_week_non_numeric_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status  | message                               |
      | weekNumber | WW    | INVALID | The week number is not a valid number |

  Scenario: 20 - Given weekNumber 1 should be marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_week_1_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status | message |
      | weekNumber | 1     | VALID  | null    |

  Scenario: 21 - Given weekNumber and year number in range should be marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_week_year_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status | message |
      | weekNumber | 36    | VALID  | null    |

  Scenario: 22 - Given weekNumber and year number in range, but not in table should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_week_year_in_range_not_in_db_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status  | message                                            |
      | weekNumber | 53    | INVALID | This week does not currently exist in the database |

  Scenario: 23 - Given yearNumber -1 should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_year_minus_1_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status  | message                                                     |
      | yearNumber | -1    | INVALID | The year number is less than the minimum allowed value of 0 |

  Scenario: 24 - Given yearNumber is Not Integer should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_year_not_int_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item       | value | status  | message                               |
      | yearNumber | YY    | INVALID | The year number is not a valid number |

  Scenario: 25 - Given invoiceStatus E for EDI should be marked as warning
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value | status  | message |
      | invoiceStatus | E     | WARNING | null    |

  Scenario: 26 - Given invoiceStatus P for EDI should be marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_status_p_edi_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value | status | message |
      | invoiceStatus | P     | VALID  | null    |

  Scenario: 27 - Given invoiceStatus M for Transferred should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_status_m_transferred_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value | status  | message                                         |
      | invoiceStatus | M     | INVALID | The invoice status must be 'A', 'E', 'O' or 'P' |

  Scenario: 28 - Given invoiceStatus M for Transferred should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_status_m_edi_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item          | value | status  | message                                         |
      | invoiceStatus | M     | INVALID | The invoice status must be 'A', 'E', 'O' or 'P' |

  Scenario: 31 - Given description null should be marked as valid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_description_null_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value | status | message |
      | description | null  | VALID  | null    |

  Scenario: 30 - Given description not longer 255 characters should be marked as invalid
    And I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_description_valid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value                                         | status | message |
      | description | Description not greater than (256) characters | VALID  | null    |

  Scenario: 31 - Given description longer than 255 characters should be marked as invalid
    When I query "POST" endpoint "/validate/header" with request body from file: "testdata/validate/header/invoice_description_too_long_invalid.json"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item        | value                                                                                                                                                                                                                                                            | status  | message                                                     |
      | description | Description too long, completed with Ls to make up 256 characters. Here we go LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL | INVALID | The invoice description must be shorter than 256 characters |











