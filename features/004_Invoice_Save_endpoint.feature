Feature: 004 Invoice Save endpoint

  Background:
    Given  I start a new test
    And  I set oAuth
    And I set connection details to seymour
    And I create directory "src/test/resources/testdata/sqlActualResults"

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


  Scenario: 02 I Call endpoint with valid EDI payload and check audit tables for update
    Given request body is set to contents of file: testdata/savePayloads/saveValidEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                 | value   | status | message |
      | header.invoiceNumber | 7405907 | VALID  | null    |
      | header.invoiceStatus | P       | VALID  | null    |
      | retailer.code        | 100564  | VALID  | null    |
      | supplier.code        | NISA    | VALID  | null    |


    #Looks like status is null on the GET, so need to check on both the POST and GET to check everything
  Scenario: 03.5 - Check values saved correctly for valid EDI payload (and invoice status = P)
    Given I set the query URL to /invoice/edi/1
    When I execute the api GET query
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value   | status | message |
      | header.invoiceNumber | 7405907 | VALID  | null    |
      | header.invoiceStatus | P       | VALID  | null    |
      | retailer.code        | 100564  | VALID  | null    |
      | supplier.code        | NISA    | VALID  | null    |



  #A null invoice status will be defaulted to P
  Scenario: 04 I Call endpoint with EDI payload with null invoice status, retailer and supplier codes
    Given request body is set to contents of file: testdata/savePayloads/saveNullValues.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                 | value | status  | message                             |
      | header.invoiceStatus | P     | VALID   | null                                |
      | retailer.code        | null  | INVALID | The retailer code must not be blank |
      | supplier.code        | null  | INVALID | The supplier code must not be blank |


  Scenario: 05 I Call endpoint with EDI payload with invoice status of E
    Given request body is set to contents of file: testdata/savePayloads/saveInvoiceStatusIsE.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                 | value | status  | message |
      | header.invoiceStatus | E     | WARNING | null    |


  Scenario: 06 I Call endpoint with EDI payload with invalid invoice status
    Given request body is set to contents of file: testdata/savePayloads/saveInvoiceStatusIsX.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                 | value | status  | message                           |
      | header.invoiceStatus | X     | INVALID | The EDI status must be 'E' or 'P' |


  Scenario: 07 I Call endpoint with EDI payload with invalid retailer code
    Given request body is set to contents of file: testdata/savePayloads/saveInvalidRetailerCode.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item          | value | status  | message                       |
      | retailer.code | xxx   | INVALID | Retailer 'xxx' does not exist |

  Scenario: 08 I Call endpoint with EDI payload with invalid supplier code
    Given request body is set to contents of file: testdata/savePayloads/saveInvalidSupplierCode.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item          | value | status  | message                       |
      | supplier.code | xxx   | INVALID | Supplier 'xxx' does not exist |


  Scenario: 09 I Call endpoint with EDI payload with invalid Id
    Given request body is set to contents of file: testdata/savePayloads/saveInvalidID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | 207                                 |
      | message   | HTTP message not readable exception |

  Scenario: 10 I Call endpoint with EDI payload with unrecognised Id
    Given request body is set to contents of file: testdata/savePayloads/saveUnrecognisedID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                   |
      | errorCode | INVOICE_NOT_FOUND       |
      | message   | Invoice 99999 not found |

  Scenario: 11 I Call endpoint with EDI payload with null Id
    Given request body is set to contents of file: testdata/savePayloads/saveNullID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | INVOICE_CREATE_FAILED               |
      | message   | New EDI invoices cannot be created. |

  Scenario: 12 I Call endpoint with EDI payload with white space Id
    Given request body is set to contents of file: testdata/savePayloads/saveWhiteSpaceID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | INVOICE_CREATE_FAILED               |
      | message   | New EDI invoices cannot be created. |

  #Add Transferred tests here - NOTE scenarios 13 and 14 will fail if run more than once per data set up
  #This is because the invoice number has to be unique and it will not be on the second run
  Scenario: 13 - I Call endpoint with Transferred payload with null Id
    Given request body is set to contents of file: testdata/savePayloads/saveNullID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value                 | status | message |
      | header.invoiceNumber        | EPI3659410-A          | VALID  | null    |
      | header.invoiceStatus        | P                     | VALID  | null    |
      | header.description          | This is a description | VALID  | null    |
      | retailer.code               | 102418                | VALID  | null    |
      | supplier.code               | NISA                  | VALID  | null    |
      | retailer.orderNumber        | 3659410-A             | null   | null    |
      | retailer.orderDate          | 2021-01-01            | null   | null    |
      | retailer.deliveryDate       | 2021-01-02            | null   | null    |
      | retailer.deliveryNumber     | 123                   | null   | null    |
      | retailer.unitsDelivered     | 5                     | null   | null    |
      | lines[0].productCode        | PROD-01               | VALID  | null    |
      | lines[0].unitWeight         | 1.123                 | VALID  | null    |
      | lines[0].unitCost           | 7.5000                | VALID  | null    |
      | lines[0].vatCode            | L                     | VALID  | null    |
      | lines[0].discountAmount     | 1.0000                | VALID  | null    |
      | lines[0].productDescription | Cuddly toy            | VALID  | null    |
    And I run queries and store results:
    #use source root
      | queryfilepath                                    | savefilepath                                              |
      | testdata/sqlQueries/016_invoice_groups_query.sql | testdata/sqlActualResults/016_invoice_groups_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                           | secondfilepath                                                               |
      | src/test/resources/testdata/sqlExpectedResults/016_invoice_groups_Expected_results.json | src/test/resources/testdata/sqlActualResults/016_invoice_groups_results.json |





#Change the member code here to 100564 and do same as above
  Scenario: 14 - I Call endpoint with Transferred payload with white space Id
    Given request body is set to contents of file: testdata/savePayloads/saveWhiteSpaceID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                        | value                 | status | message |
      | header.invoiceNumber        | EPI3659410-B          | VALID  | null    |
      | header.invoiceStatus        | O                     | VALID  | null    |
      | header.description          | This is a description | VALID  | null    |
      | retailer.code               | 100564                | VALID  | null    |
      | supplier.code               | NISA                  | VALID  | null    |
      | retailer.orderNumber        | 3659410-A             | null   | null    |
      | retailer.orderDate          | 2021-01-01            | null   | null    |
      | retailer.deliveryDate       | 2021-01-02            | null   | null    |
      | retailer.deliveryNumber     | 123                   | null   | null    |
      | retailer.unitsDelivered     | 5                     | null   | null    |
      | lines[0].productCode        | PROD-01               | VALID  | null    |
      | lines[0].unitWeight         | 1.123                 | VALID  | null    |
      | lines[0].unitCost           | 7.5000                | VALID  | null    |
      | lines[0].vatCode            | L                     | VALID  | null    |
      | lines[0].discountAmount     | 1.0000                | VALID  | null    |
      | lines[0].productDescription | Cuddly toy            | VALID  | null    |
    And I run queries and store results:
    #use source root
      | queryfilepath                                           | savefilepath                                                     |
      | testdata/sqlQueries/017_not_on_invoice_groups_query.sql | testdata/sqlActualResults/017_not_on_invoice_groups_results.json |
    Then I compare JSON files:
    #use repostitory root
      | firstfilepath                                                                                  | secondfilepath                                                                      |
      | src/test/resources/testdata/sqlExpectedResults/017_not_on_invoice_groups_Expected_results.json | src/test/resources/testdata/sqlActualResults/017_not_on_invoice_groups_results.json |



  Scenario: 15 - I Call endpoint with Transferred payload with valid existing invoice
    Given request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                          | value                       | status | message |
      | header.invoiceNumber          | EPI3662277                  | VALID  | null    |
      | header.invoiceStatus          | O                           | VALID  | null    |
      | header.description            | This is another description | VALID  | null    |
      | retailer.code                 | 72439                       | VALID  | null    |
      | supplier.code                 | NISA                        | VALID  | null    |
      | retailer.orderNumber          | 3659410-B                   | null   | null    |
      | retailer.orderDate            | 2021-01-02                  | null   | null    |
      | retailer.deliveryDate         | 2021-01-03                  | null   | null    |
      | retailer.deliveryNumber       | 124                         | null   | null    |
      | retailer.unitsDelivered       | 5                           | null   | null    |
      | lines[0].productCode          | PROD-01-B                   | VALID  | null    |
      | lines[0].units                | 4                           | VALID  | null    |
      | lines[0].unitWeight           | 1.123                       | VALID  | null    |
      | lines[0].unitCost             | 5.0000                      | VALID  | null    |
      | lines[0].unitCostExVat        | 20.00                       | VALID  | null    |
      | lines[0].vatAmount            | 4.00                        | VALID  | null    |
      | lines[0].totalAmount          | 24.00                       | VALID  | null    |
      | lines[0].vatCode              | S                           | VALID  | null    |
      | lines[0].discountAmount       | 0.0000                      | VALID  | null    |
      | lines[0].productDescription   | Toy boat                    | VALID  | null    |
      | lines[0].measurementIndicator | S                           | VALID  | null    |


  Scenario: 16 I Call endpoint with transferred payload with invalid Id
    Given request body is set to contents of file: testdata/savePayloads/saveInvalidID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following JSON values are present in the response:
      | item      | value                               |
      | errorCode | 207                                 |
      | message   | HTTP message not readable exception |

  Scenario: 17 I Call endpoint with Transferred payload with unrecognised Id
    Given request body is set to contents of file: testdata/savePayloads/saveUnrecognisedID.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 404
    And The following JSON values are present in the response:
      | item      | value                   |
      | errorCode | INVOICE_NOT_FOUND       |
      | message   | Invoice 99999 not found |



  #Validation tests for Additional Invoice Header Validation
  #Create invoices (no ID)
  Scenario: 18 - I Call endpoint with Transferred payload with null Id - Closed Flag = Y
    Given request body is set to contents of file: testdata/savePayloads/saveNullIDClosed.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                 | status  | message                                                 |
      | header.invoiceNumber        | EPI3659410-C          | VALID   | null                                                    |
      | header.weekNumber           | 2                     | INVALID | This week has been closed and changes will not be saved |
      | header.yearNumber           | 2021                  | INVALID | This week has been closed and changes will not be saved |
      | header.invoiceStatus        | P                     | VALID   | null                                                    |
      | header.description          | This is a description | VALID   | null                                                    |
      | retailer.code               | 102418                | VALID   | null                                                    |
      | supplier.code               | NISA                  | VALID   | null                                                    |
      | retailer.orderNumber        | 3659410-A             | null    | null                                                    |
      | retailer.orderDate          | 2021-01-01            | null    | null                                                    |
      | retailer.deliveryDate       | 2021-01-02            | null    | null                                                    |
      | retailer.deliveryNumber     | 123                   | null    | null                                                    |
      | retailer.unitsDelivered     | 5                     | null    | null                                                    |
      | lines[0].productCode        | PROD-01               | VALID   | null                                                    |
      | lines[0].unitWeight         | 1.123                 | VALID   | null                                                    |
      | lines[0].unitCost           | 7.5000                | VALID   | null                                                    |
      | lines[0].vatCode            | L                     | VALID   | null                                                    |
      | lines[0].discountAmount     | 1.0000                | VALID   | null                                                    |
      | lines[0].productDescription | Cuddly toy            | VALID   | null                                                    |

  Scenario: 19 - I Call endpoint with Transferred payload with null Id - Cut off in past
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/savePayloads/saveNullIDCutOffInPast.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                 | status  | message                                                                 |
      | header.invoiceNumber        | EPI3659410-C          | VALID   | null                                                                    |
      | header.weekNumber           | 12                    | INVALID | The cut off date for this week has passed and changes will not be saved |
      | header.yearNumber           | 2021                  | INVALID | The cut off date for this week has passed and changes will not be saved |
      | header.invoiceStatus        | P                     | VALID   | null                                                                    |
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

  Scenario: 20 - I Call endpoint with Transferred payload with null Id - Week not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveNullIDNoWeekOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
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


  Scenario: 21 - I Call endpoint with Transferred payload with null Id - Year not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveNullIDNoYearOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                 | status  | message                                            |
      | header.invoiceNumber        | EPI3659410-C          | VALID   | null                                               |
      | header.weekNumber           | 50                    | INVALID | This week does not currently exist in the database |
      | header.yearNumber           | 2022                  | INVALID | This week does not currently exist in the database |
      | header.invoiceStatus        | O                     | VALID   | null                                               |
      | header.description          | This is a description | VALID   | null                                               |
      | retailer.code               | 102418                | VALID   | null                                               |
      | supplier.code               | NISA                  | VALID   | null                                               |
      | retailer.orderNumber        | 3659410-A             | null    | null                                               |
      | retailer.orderDate          | 2021-01-01            | null    | null                                               |
      | retailer.deliveryDate       | 2021-01-02            | null    | null                                               |
      | retailer.deliveryNumber     | 123                   | null    | null                                               |
      | retailer.unitsDelivered     | 5                     | null    | null                                               |
      | lines[0].productCode        | PROD-01               | VALID   | null                                               |
      | lines[0].unitWeight         | 1.123                 | VALID   | null                                               |
      | lines[0].unitCost           | 7.5000                | VALID   | null                                               |
      | lines[0].vatCode            | L                     | VALID   | null                                               |
      | lines[0].discountAmount     | 1.0000                | VALID   | null                                               |
      | lines[0].productDescription | Cuddly toy            | VALID   | null                                               |


  Scenario: 22 - I Call endpoint with Transferred payload with null Id - Retailer not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveNullIDRetailerNotOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                 | status  | message                                                                 |
      | header.invoiceNumber        | EPI3659410-C          | VALID   | null                                                                    |
      | header.weekNumber           | 50                    | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.yearNumber           | 2021                  | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.invoiceStatus        | O                     | VALID   | null                                                                    |
      | header.description          | This is a description | VALID   | null                                                                    |
      | retailer.code               | 102319                | VALID   | null                                                                    |
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

    #Validation tests for Additional Invoice Header Validation
    #Save existing invoices
  Scenario: 23 - I Call endpoint with Transferred payload - existing invoice - Closed Flag = Y
    Given request body is set to contents of file: testdata/savePayloads/saveTransferredClosed.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                       | status  | message                                                 |
      | header.invoiceNumber        | EPI3662277                  | VALID   | null                                                    |
      | header.weekNumber           | 2                           | INVALID | This week has been closed and changes will not be saved |
      | header.yearNumber           | 2021                        | INVALID | This week has been closed and changes will not be saved |
      | header.invoiceStatus        | O                           | VALID   | null                                                    |
      | header.description          | This is another description | VALID   | null                                                    |
      | retailer.code               | 72439                       | VALID   | null                                                    |
      | supplier.code               | NISA                        | VALID   | null                                                    |
      | retailer.orderNumber        | 3659410-B                   | null    | null                                                    |
      | retailer.orderDate          | 2021-01-02                  | null    | null                                                    |
      | retailer.deliveryDate       | 2021-01-03                  | null    | null                                                    |
      | retailer.deliveryNumber     | 124                         | null    | null                                                    |
      | retailer.unitsDelivered     | 5                           | null    | null                                                    |
      | lines[0].productCode        | PROD-01-B                   | VALID   | null                                                    |
      | lines[0].unitWeight         | 1.123                       | VALID   | null                                                    |
      | lines[0].unitCost           | 5.0000                      | VALID   | null                                                    |
      | lines[0].unitCostExVat      | 20.00                       | VALID   | null                                                    |
      | lines[0].vatCode            | S                           | VALID   | null                                                    |
      | lines[0].discountAmount     | 0.0000                      | VALID   | null                                                    |
      | lines[0].productDescription | Toy boat                    | VALID   | null                                                    |


  Scenario: 24 - I Call endpoint with Transferred payload - existing invoice - Cut off in past
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/savePayloads/saveTransferredCutoffInPast.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                       | status  | message                                                                 |
      | header.invoiceNumber        | EPI3662277                  | VALID   | null                                                                    |
      | header.weekNumber           | 12                          | INVALID | The cut off date for this week has passed and changes will not be saved |
      | header.yearNumber           | 2021                        | INVALID | The cut off date for this week has passed and changes will not be saved |
      | header.invoiceStatus        | O                           | VALID   | null                                                                    |
      | header.description          | This is another description | VALID   | null                                                                    |
      | retailer.code               | 72439                       | VALID   | null                                                                    |
      | supplier.code               | NISA                        | VALID   | null                                                                    |
      | retailer.orderNumber        | 3659410-B                   | null    | null                                                                    |
      | retailer.orderDate          | 2021-01-02                  | null    | null                                                                    |
      | retailer.deliveryDate       | 2021-01-03                  | null    | null                                                                    |
      | retailer.deliveryNumber     | 124                         | null    | null                                                                    |
      | retailer.unitsDelivered     | 5                           | null    | null                                                                    |
      | lines[0].productCode        | PROD-01-B                   | VALID   | null                                                                    |
      | lines[0].unitWeight         | 1.123                       | VALID   | null                                                                    |
      | lines[0].unitCost           | 5.0000                      | VALID   | null                                                                    |
      | lines[0].unitCostExVat      | 20.00                       | VALID   | null                                                                    |
      | lines[0].vatCode            | S                           | VALID   | null                                                                    |
      | lines[0].discountAmount     | 0.0000                      | VALID   | null                                                                    |
      | lines[0].productDescription | Toy boat                    | VALID   | null                                                                    |


  Scenario: 25 - I Call endpoint with Transferred payload - existing invoice - Week not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveTransferredNoWeekOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                       | status  | message                                                                 |
      | header.invoiceNumber        | EPI3662277                  | VALID   | null                                                                    |
      | header.weekNumber           | 49                          | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.yearNumber           | 2021                        | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.invoiceStatus        | O                           | VALID   | null                                                                    |
      | header.description          | This is another description | VALID   | null                                                                    |
      | retailer.code               | 72439                       | VALID   | null                                                                    |
      | supplier.code               | NISA                        | VALID   | null                                                                    |
      | retailer.orderNumber        | 3659410-B                   | null    | null                                                                    |
      | retailer.orderDate          | 2021-01-02                  | null    | null                                                                    |
      | retailer.deliveryDate       | 2021-01-03                  | null    | null                                                                    |
      | retailer.deliveryNumber     | 124                         | null    | null                                                                    |
      | retailer.unitsDelivered     | 5                           | null    | null                                                                    |
      | lines[0].productCode        | PROD-01-B                   | VALID   | null                                                                    |
      | lines[0].unitWeight         | 1.123                       | VALID   | null                                                                    |
      | lines[0].unitCost           | 5.0000                      | VALID   | null                                                                    |
      | lines[0].unitCostExVat      | 20.00                       | VALID   | null                                                                    |
      | lines[0].vatCode            | S                           | VALID   | null                                                                    |
      | lines[0].discountAmount     | 0.0000                      | VALID   | null                                                                    |
      | lines[0].productDescription | Toy boat                    | VALID   | null                                                                    |

  Scenario: 26 - I Call endpoint with Transferred payload - existing invoice - Year not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveTransferredNoYearOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                       | status  | message                                            |
      | header.invoiceNumber        | EPI3662277                  | VALID   | null                                               |
      | header.weekNumber           | 50                          | INVALID | This week does not currently exist in the database |
      | header.yearNumber           | 2022                        | INVALID | This week does not currently exist in the database |
      | header.invoiceStatus        | O                           | VALID   | null                                               |
      | header.description          | This is another description | VALID   | null                                               |
      | retailer.code               | 72439                       | VALID   | null                                               |
      | supplier.code               | NISA                        | VALID   | null                                               |
      | retailer.orderNumber        | 3659410-B                   | null    | null                                               |
      | retailer.orderDate          | 2021-01-02                  | null    | null                                               |
      | retailer.deliveryDate       | 2021-01-03                  | null    | null                                               |
      | retailer.deliveryNumber     | 124                         | null    | null                                               |
      | retailer.unitsDelivered     | 5                           | null    | null                                               |
      | lines[0].productCode        | PROD-01-B                   | VALID   | null                                               |
      | lines[0].unitWeight         | 1.123                       | VALID   | null                                               |
      | lines[0].unitCost           | 5.0000                      | VALID   | null                                               |
      | lines[0].unitCostExVat      | 20.00                       | VALID   | null                                               |
      | lines[0].vatCode            | S                           | VALID   | null                                               |
      | lines[0].discountAmount     | 0.0000                      | VALID   | null                                               |
      | lines[0].productDescription | Toy boat                    | VALID   | null                                               |


  Scenario: 27 - I Call endpoint with Transferred payload - existing invoice  - Retailer not on member invoices
    Given request body is set to contents of file: testdata/savePayloads/saveTransferredRetailerNotOnMemInv.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 400
    And The following values are present in the response:
      | item                        | value                       | status  | message                                                                 |
      | header.invoiceNumber        | EPI3662277                  | VALID   | null                                                                    |
      | header.weekNumber           | 50                          | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.yearNumber           | 2021                        | INVALID | This week does not have a summary invoice and changes will not be saved |
      | header.invoiceStatus        | O                           | VALID   | null                                                                    |
      | header.description          | This is another description | VALID   | null                                                                    |
      | retailer.code               | 102319                      | VALID   | null                                                                    |
      | supplier.code               | NISA                        | VALID   | null                                                                    |
      | retailer.orderNumber        | 3659410-A                   | null    | null                                                                    |
      | retailer.orderDate          | 2021-01-01                  | null    | null                                                                    |
      | retailer.deliveryDate       | 2021-01-02                  | null    | null                                                                    |
      | retailer.deliveryNumber     | 123                         | null    | null                                                                    |
      | retailer.unitsDelivered     | 5                           | null    | null                                                                    |
      | lines[0].productCode        | PROD-01-B                   | VALID   | null                                                                    |
      | lines[0].unitWeight         | 1.123                       | VALID   | null                                                                    |
      | lines[0].unitCost           | 5.0000                      | VALID   | null                                                                    |
      | lines[0].unitCostExVat      | 20.00                       | VALID   | null                                                                    |
      | lines[0].vatCode            | S                           | VALID   | null                                                                    |
      | lines[0].discountAmount     | 0.0000                      | VALID   | null                                                                    |
      | lines[0].productDescription | Toy boat                    | VALID   | null                                                                    |

  Scenario: 28 - I create a new invoice that uses unit weights instead of units to calculate totals
    Given request body is set to contents of JSON format file: testdata/savePayloads/saveValidTransferredWithUnitWeight.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201
    And The following values are present in the response:
      | item                          | value | status | message |
      | lines[0].units                | 0     | VALID  | null    |
      | lines[0].unitWeight           | 1.123 | VALID  | null    |
      | lines[0].unitCost             | 5.00  | VALID  | null    |
      | lines[0].unitCostExVat        | 5.62  | VALID  | null    |
      | lines[0].vatAmount            | 1.12  | VALID  | null    |
      | lines[0].totalAmount          | 6.74  | VALID  | null    |
      | lines[0].measurementIndicator | KG    | VALID  | null    |
      | lines[1].units                | 2     | VALID  | null    |
      | lines[1].unitWeight           | null  | VALID  | null    |
      | lines[1].unitCost             | 18.00 | VALID  | null    |
      | lines[1].unitCostExVat        | 36.00 | VALID  | null    |
      | lines[1].vatAmount            | 7.20  | VALID  | null    |
      | lines[1].totalAmount          | 43.20 | VALID  | null    |
      | lines[1].measurementIndicator | EA    | VALID  | null    |
