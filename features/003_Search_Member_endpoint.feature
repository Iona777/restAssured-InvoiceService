@003
Feature: 003 Search Member endpoint

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
    When I query GET endpoint "/search/member"
    Then I should receive response status code 200
    And I should receive a list of 20 entries

  Scenario: 03 - Search by full member code
    When I query GET endpoint "/search/member?searchTerm=67309"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    Then The following JSON values are present in the response:
      | item                | value                        |
      | [0].memberCode      | 67309                        |
      | [0].memberName      | MR PCM PATEL & MRS JPC PATEL |
      | [0].addressLine1    | COSTCUTTER                   |
      | [0].addressLine2    | 935-937 LEEDS ROAD           |
      | [0].addressLine3    | null                         |
      | [0].addressLine4    | null                         |
      | [0].postcode        | HD2 1UE                      |
      | [0].vatNumber       | null                         |
      | [0].supplierAccount | C24513                       |
      | [0].dateClosed      | null                         |


  Scenario: 04 - Search by partial member code
    When I query GET endpoint "/search/member?searchTerm=671"
    Then I should receive response status code 200
    And I should receive a list of 3 entries
    Then The following JSON values are present in the response:
      | item                                          | value                  |
      | [?(@.memberCode == '86713')].memberName       | RACHAEL CUBBON         |
      | [?(@.memberCode == '86713')].addressLine1     | MACE                   |
      | [?(@.memberCode == '86713')].addressLine2     | S&S MOTORS             |
      | [?(@.memberCode == '86713')].addressLine3     | ALEXANDRA ROAD         |
      | [?(@.memberCode == '86713')].addressLine4     | [null]                 |
      | [?(@.memberCode == '86713')].postcode         | IM9 1TE                |
      | [?(@.memberCode == '86713')].vatNumber        | [null]                 |
      | [?(@.memberCode == '86713')].supplierAccount  | C35238                 |
      | [?(@.memberCode == '86713')].dateClosed       | [null]                 |

      | [?(@.memberCode == '101671')].memberName      | MRS SUJATHA NARRAYANAN |
      | [?(@.memberCode == '101671')].addressLine1    | COSTCUTTER             |
      | [?(@.memberCode == '101671')].addressLine2    | 146 SOVEREIGN ROAD     |
      | [?(@.memberCode == '101671')].addressLine3    | EARLSDON               |
      | [?(@.memberCode == '101671')].addressLine4    | [null]                 |
      | [?(@.memberCode == '101671')].postcode        | CV5 6LU                |
      | [?(@.memberCode == '101671')].vatNumber       | [null]                 |
      | [?(@.memberCode == '101671')].supplierAccount | C35136                 |
      | [?(@.memberCode == '101671')].dateClosed      | [null]                 |

      | [?(@.memberCode == '67129')].memberName       | R W TOTTY              |
      | [?(@.memberCode == '67129')].addressLine1     | COSTCUTTER             |
      | [?(@.memberCode == '67129')].addressLine2     | FIRST & LAST STORES    |
      | [?(@.memberCode == '67129')].addressLine3     | SENNEN                 |
      | [?(@.memberCode == '67129')].addressLine4     | [null]                 |
      | [?(@.memberCode == '67129')].postcode         | TR19 7AD               |
      | [?(@.memberCode == '67129')].vatNumber        | [null]                 |
      | [?(@.memberCode == '67129')].supplierAccount  | C24183                 |
      | [?(@.memberCode == '67129')].dateClosed       | [null]                 |

  Scenario: 05 - Search by full member name
    When I query GET endpoint "/search/member?searchTerm=BAKER%20STREET%20NEWS%20LTD"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    Then The following JSON values are present in the response:
      | item                | value                 |
      | [0].memberCode      | 101770                |
      | [0].memberName      | BAKER STREET NEWS LTD |
      | [0].addressLine1    | BAKER STREET NEWS     |
      | [0].addressLine2    | 202 BAKER STREET      |
      | [0].addressLine3    | null                  |
      | [0].addressLine4    | null                  |
      | [0].postcode        | NW1 5RT               |
      | [0].vatNumber       | null                  |
      | [0].supplierAccount | C34365                |
      | [0].dateClosed      | null                  |


  Scenario: 06 - Search by partial member name
    When I query GET endpoint "/search/member?searchTerm=news%20ltd"
    Then I should receive response status code 200
    And I should receive a list of 4 entries
    Then The following JSON values are present in the response:
      | item                                          | value                            |
      | [?(@.memberCode == '113335')].memberName      | CDMK NEWS LTD                    |
      | [?(@.memberCode == '113335')].addressLine1    | COSTCUTTER                       |
      | [?(@.memberCode == '113335')].addressLine2    | 14 FIRGROVE HILL                 |
      | [?(@.memberCode == '113335')].addressLine3    | [null]                           |
      | [?(@.memberCode == '113335')].addressLine4    | [null]                           |
      | [?(@.memberCode == '113335')].postcode        | GU9 8LQ                          |
      | [?(@.memberCode == '113335')].vatNumber       | [null]                           |
      | [?(@.memberCode == '113335')].supplierAccount | C36234                           |
      | [?(@.memberCode == '113335')].dateClosed      | [null]                           |

      | [?(@.memberCode == '101779')].memberName      | ST JAMES NEWS LTD                |
      | [?(@.memberCode == '101779')].addressLine1    | SIMPLY FRESH                     |
      | [?(@.memberCode == '101779')].addressLine2    | 55 THE BROADWAY                  |
      | [?(@.memberCode == '101779')].addressLine3    | UNIT 1-5 ST JAME'S               |
      | [?(@.memberCode == '101779')].addressLine4    | PARK STATION                     |
      | [?(@.memberCode == '101779')].postcode        | SW1H 0BD                         |
      | [?(@.memberCode == '101779')].vatNumber       | [null]                           |
      | [?(@.memberCode == '101779')].supplierAccount | C34590                           |
      | [?(@.memberCode == '101779')].dateClosed      | [null]                           |

      | [?(@.memberCode == '101770')].memberName      | BAKER STREET NEWS LTD            |
      | [?(@.memberCode == '101770')].addressLine1    | BAKER STREET NEWS                |
      | [?(@.memberCode == '101770')].addressLine2    | 202 BAKER STREET                 |
      | [?(@.memberCode == '101770')].addressLine3    | [null]                           |
      | [?(@.memberCode == '101770')].addressLine4    | [null]                           |
      | [?(@.memberCode == '101770')].postcode        | NW1 5RT                          |
      | [?(@.memberCode == '101770')].vatNumber       | [null]                           |
      | [?(@.memberCode == '101770')].supplierAccount | C34365                           |
      | [?(@.memberCode == '101770')].dateClosed      | [null]                           |

      | [?(@.memberCode == '118276')].memberName      | SAI NEWS LTD                     |
      | [?(@.memberCode == '118276')].addressLine1    | PORCHER AVENUE CONVENIENCE STORE |
      | [?(@.memberCode == '118276')].addressLine2    | 70 PORCHER AVENUE                |
      | [?(@.memberCode == '118276')].addressLine3    | [null]                           |
      | [?(@.memberCode == '118276')].addressLine4    | [null]                           |
      | [?(@.memberCode == '118276')].postcode        | CF37 3DD                         |
      | [?(@.memberCode == '118276')].vatNumber       | [null]                           |
      | [?(@.memberCode == '118276')].supplierAccount | C39854                           |
      | [?(@.memberCode == '118276')].dateClosed      | [null]                           |

  Scenario: 07 - Search by full post code
    When I query GET endpoint "/search/member?searchTerm=BT30%206QD"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    Then The following JSON values are present in the response:
      | item                | value              |
      | [0].memberCode      | 85012              |
      | [0].memberName      | CHARLES WALSH      |
      | [0].addressLine1    | SUPERSHOP          |
      | [0].addressLine2    | 33 GLEBETOWN DRIVE |
      | [0].addressLine3    | KILLOUGH ROAD      |
      | [0].addressLine4    | Sometown           |
      | [0].postcode        | BT30 6QD           |
      | [0].vatNumber       | V87456321          |
      | [0].supplierAccount | C34704             |
      | [0].dateClosed      | null               |


  Scenario: 08 - Search by partial post code
    When I query GET endpoint "/search/member?searchTerm=BT30"
    Then I should receive response status code 200
    And I should receive a list of 3 entries
    Then The following JSON values are present in the response:
      | item                                         | value                |
      | [?(@.memberCode == '66301')].memberName      | CENTRAL GARAGES LTD  |
      | [?(@.memberCode == '66301')].addressLine1    | COSTCUTTER CROSSGAR  |
      | [?(@.memberCode == '66301')].addressLine2    | 21 KILLYLEAGH STREET |
      | [?(@.memberCode == '66301')].addressLine3    | [null]               |
      | [?(@.memberCode == '66301')].addressLine4    | [null]               |
      | [?(@.memberCode == '66301')].postcode        | BT30 9DQ             |
      | [?(@.memberCode == '66301')].vatNumber       | [null]               |
      | [?(@.memberCode == '66301')].supplierAccount | C22225               |
      | [?(@.memberCode == '66301')].dateClosed      | [null]               |

      | [?(@.memberCode == '85012')].memberName      | CHARLES WALSH        |
      | [?(@.memberCode == '85012')].addressLine1    | SUPERSHOP            |
      | [?(@.memberCode == '85012')].addressLine2    | 33 GLEBETOWN DRIVE   |
      | [?(@.memberCode == '85012')].addressLine3    | KILLOUGH ROAD        |
      | [?(@.memberCode == '85012')].addressLine4    | Sometown             |
      | [?(@.memberCode == '85012')].postcode        | BT30 6QD             |
      | [?(@.memberCode == '85012')].vatNumber       | V87456321            |
      | [?(@.memberCode == '85012')].dateClosed      | [null]               |

      | [?(@.memberCode == '85255')].memberName      | BRONACH HYNDS        |
      | [?(@.memberCode == '85255')].addressLine1    | SUPERSHOP            |
      | [?(@.memberCode == '85255')].addressLine2    | ARDGLASS POST OFFICE |
      | [?(@.memberCode == '85255')].addressLine3    | 2 QUAY STREET        |
      | [?(@.memberCode == '85255')].addressLine4    | ARDGLASS             |
      | [?(@.memberCode == '85255')].postcode        | BT30 7SA             |
      | [?(@.memberCode == '85255')].vatNumber       | [null]               |
      | [?(@.memberCode == '85255')].dateClosed      | [null]               |


  Scenario: 09 - Search with non-matching parameter
    When I query GET endpoint "/search/member?searchTerm=zzz"
    Then I should receive response status code 200
    And I should receive a list of 0 entries

  Scenario: 10 - Search closed member - return closed date
    When I query GET endpoint "/search/member?searchTerm=23579"
    Then I should receive response status code 200
    And I should receive a list of 1 entries
    Then The following JSON values are present in the response:
      | item                | value                |
      | [0].memberCode      | 23579                |
      | [0].memberName      | MRS L M McCORQUODALE |
      | [0].addressLine1    | COSTCUTTER           |
      | [0].addressLine2    | 2 STATION ROAD       |
      | [0].addressLine3    | null                 |
      | [0].addressLine4    | null                 |
      | [0].postcode        | EH22 3EU             |
      | [0].vatNumber       | null                 |
      | [0].supplierAccount | C08978               |
      | [0].dateClosed      | 2020-02-03           |