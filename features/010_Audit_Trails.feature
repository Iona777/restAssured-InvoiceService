Feature: 010 Audit Trails

  Background:
    Given  I start a new test
    And  I set oAuth
    And I set connection details to seymour
    And I create directory "src/test/resources/testdata/sqlActualResults"

  Scenario: 01 - I setup test data
    Given I quickly empty the following tables:
      | table                         |
      | billing.edi_inv_hdr_vat_rates       |
      | billing.edi_invoice_lines           |
      | billing.edi_invoice_headers         |
      | billing.inv_hdr_vat_rates           |
      | billing.invoice_lines               |
      | billing.invoice_headers             |
      | billing.week_numbers                |
      | billing.invoice_statuses            |
      | billing.invoice_types               |
      | billing.vat_rates                   |
      | suppliers.suppliers                 |
      | franman.franchises                  |
      | franman.retail_organisations        |
      | franman.shops                       |
      | franman.addresses                   |
      | franman.areas                       |
      | franman.regions                     |
      | billing.invoice_groups              |
      | billing.invoice_clerks              |


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


    And I quickly empty the following tables:
      | table                         |
      | billing.invoice_headers_audit       |
      | billing.invoice_lines_audit         |
      | billing.inv_hdr_vat_rates_audit     |
      | billing.edi_invoice_headers_audit   |
      | billing.edi_invoice_lines_audit     |
      | billing.edi_inv_hdr_vat_rates_audit |


  Scenario: 02 I Call endpoint with valid EDI payload and check audit tables for update
    Given request body is set to contents of file: testdata/savePayloads/saveValidEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 201
    And I run queries and store results:
    #Due to some cucumber weirdness, queryfilepath and savefilepath have to use the source root, while the other
    #files have to use the repository root.
    #savefilepath and secondfilepath will refer to the same physical file.
    #use source root
      | queryfilepath                                                        | savefilepath                                                                                                              |
      | testdata/sqlQueries/001_edi_invoice_headers_audit_update_query.txt   | testdata/sqlActualResults/001_edi_invoice_headers_audit_update_results.json   |
      | testdata/sqlQueries/002_edi_invoice_lines_audit_update_query.txt     | testdata/sqlActualResults/002_edi_invoice_lines_audit_update_results.json     |
      | testdata/sqlQueries/003_edi_inv_hdr_vat_rates_audit_update_query.txt | testdata/sqlActualResults/003_edi_inv_hdr_vat_rates_audit_update_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                               | secondfilepath                                                                                   |
      | src/test/resources/testdata/sqlExpectedResults/001_edi_invoice_headers_audit_update_Expected_results.json   | src/test/resources/testdata/sqlActualResults/001_edi_invoice_headers_audit_update_results.json   |
      | src/test/resources/testdata/sqlExpectedResults/002_edi_invoice_lines_audit_update_Expected_results.json     | src/test/resources/testdata/sqlActualResults/002_edi_invoice_lines_audit_update_results.json     |
      | src/test/resources/testdata/sqlExpectedResults/003_edi_inv_hdr_vat_rates_audit_update_Expected_results.json | src/test/resources/testdata/sqlActualResults/003_edi_inv_hdr_vat_rates_audit_update_results.json |


  Scenario: 03 - I Call endpoint with valid Transferred payload and check audit tables for update
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And I run queries and store results:
    #use source root
      | queryfilepath                                                    | savefilepath                                                              |
      | testdata/sqlQueries/004_invoice_headers_audit_update_query.txt   | testdata/sqlActualResults/004_invoice_headers_audit_update_results.json   |
      | testdata/sqlQueries/005_invoice_lines_audit_update_query.txt     | testdata/sqlActualResults/005_invoice_lines_audit_update_results.json     |
    #Would need to change a special vat rate to test inv_hdr_vat_rates_audit. Which isn't possible at the moment...
      # | testdata/sqlQueries/006_inv_hdr_vat_rates_audit_update_query.txt | testdata/sqlActualResults/006_inv_hdr_vat_rates_audit_update_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                           | secondfilepath                                                                               |
      | src/test/resources/testdata/sqlExpectedResults/004_invoice_headers_audit_update_Expected_results.json   | src/test/resources/testdata/sqlActualResults/004_invoice_headers_audit_update_results.json   |
      | src/test/resources/testdata/sqlExpectedResults/005_invoice_lines_audit_update_Expected_results.json     | src/test/resources/testdata/sqlActualResults/005_invoice_lines_audit_update_results.json     |
      # Would need to change a special vat rate to test inv_hdr_vat_rates_audit. Which isn't possible at the moment...
     # | src/test/resources/testdata/sqlExpectedResults/006_inv_hdr_vat_rates_audit_update_Expected_results.json | src/test/resources/testdata/sqlActualResults/006_inv_hdr_vat_rates_audit_update_results.json |


  Scenario: 04 - I Call endpoint with Transferred payload with null Id and check audit tables for create
    Given request body is set to contents of file: testdata/savePayloads/saveNullID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And I run queries and store results:
    #use source root
      | queryfilepath                                                    | savefilepath                                                              |
      | testdata/sqlQueries/007_invoice_headers_audit_update_query.txt   | testdata/sqlActualResults/007_invoice_headers_audit_update_results.json   |
      | testdata/sqlQueries/008_invoice_lines_audit_update_query.txt     | testdata/sqlActualResults/008_invoice_lines_audit_update_results.json     |
    #Would need to change a special vat rate to test inv_hdr_vat_rates_audit. Which isn't possible at the moment...
      # | testdata/sqlQueries/009_inv_hdr_vat_rates_audit_update_query.txt | testdata/sqlActualResults/009_inv_hdr_vat_rates_audit_update_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                           | secondfilepath                                                                               |
      | src/test/resources/testdata/sqlExpectedResults/007_invoice_headers_audit_update_Expected_results.json   | src/test/resources/testdata/sqlActualResults/007_invoice_headers_audit_update_results.json   |
      | src/test/resources/testdata/sqlExpectedResults/008_invoice_lines_audit_update_Expected_results.json     | src/test/resources/testdata/sqlActualResults/008_invoice_lines_audit_update_results.json     |
      # Would need to change a special vat rate to test inv_hdr_vat_rates_audit. Which isn't possible at the moment...
     # | src/test/resources/testdata/sqlExpectedResults/009_inv_hdr_vat_rates_audit_update_Expected_results.json | src/test/resources/testdata/sqlActualResults/009_inv_hdr_vat_rates_audit_update_results.json |


  Scenario: 04 - I call delete endpoint for EDI invoice and check audit tables for delete
    Given I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 200
    And I query GET endpoint "/invoice/EDI/2"
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value               |
      | errorCode | INVOICE_NOT_FOUND   |
      | message   | Invoice 2 not found |

    And I run queries and store results:
    #use source root
      | queryfilepath                                                        | savefilepath                                                                  |
      | testdata/sqlQueries/010_edi_invoice_headers_audit_delete_query.txt   | testdata/sqlActualResults/010_edi_invoice_headers_audit_delete_results.json   |
      | testdata/sqlQueries/011_edi_invoice_lines_audit_delete_query.txt     | testdata/sqlActualResults/011_edi_invoice_lines_audit_delete_results.json     |
      | testdata/sqlQueries/012_edi_inv_hdr_vat_rates_audit_delete_query.txt | testdata/sqlActualResults/012_edi_inv_hdr_vat_rates_audit_delete_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                               | secondfilepath                                                                                   |
      | src/test/resources/testdata/sqlExpectedResults/010_edi_invoice_headers_audit_delete_Expected_results.json   | src/test/resources/testdata/sqlActualResults/010_edi_invoice_headers_audit_delete_results.json   |
      | src/test/resources/testdata/sqlExpectedResults/011_edi_invoice_lines_audit_delete_Expected_results.json     | src/test/resources/testdata/sqlActualResults/011_edi_invoice_lines_audit_delete_results.json     |
      | src/test/resources/testdata/sqlExpectedResults/012_edi_inv_hdr_vat_rates_audit_delete_Expected_results.json | src/test/resources/testdata/sqlActualResults/012_edi_inv_hdr_vat_rates_audit_delete_results.json |


  Scenario: 05 - I call delete endpoint for Transferred invoice and check audit tables for delete
    Given I set the query URL to /invoice/transferred/delete/101
    When I execute the api DELETE query
    Then I should receive response status code 200
    And I query GET endpoint "/invoice/101"
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value               |
      | errorCode | INVOICE_NOT_FOUND   |
      | message   | Invoice 101 not found |

    And I run queries and store results:
    #use source root
      | queryfilepath                                                     | savefilepath                                                              |
      | testdata/sqlQueries/013_invoice_headers_audit_delete_query.txt    | testdata/sqlActualResults/013_invoice_headers_audit_delete_results.json   |
      | testdata/sqlQueries/014_invoice_lines_audit_delete_query.txt      | testdata/sqlActualResults/014_invoice_lines_audit_delete_results.json     |

    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                           | secondfilepath                                                                               |
      | src/test/resources/testdata/sqlExpectedResults/013_invoice_headers_audit_delete_Expected_results.json   | src/test/resources/testdata/sqlActualResults/013_invoice_headers_audit_delete_results.json   |
      | src/test/resources/testdata/sqlExpectedResults/014_invoice_lines_audit_delete_Expected_results.json     | src/test/resources/testdata/sqlActualResults/014_invoice_lines_audit_delete_results.json     |


