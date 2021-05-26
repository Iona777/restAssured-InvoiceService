Feature: 017 Create Permissions Annotations

  Background:
    Given  I start a new test
    #And  I set oAuth
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


# Call these  endpoints
  #Read Only
  #GET /search/invoiceGET/search/member
  #POST /validate/headerPOST /validate/line
  #POST /validate/retailerPOST /validate/supplier
  #POST /validate/{type}/header
  #POST /validate/{type}/line
  #POST /validate/{type}/retailer
  #POST /validate/{type}/supplier
  #GET /invoice/{id}
  #GET /invoice/{type}/{id}

  #Write
  #POST /invoice
  #POST /invoice/{type}
  #DELETE /invoice/delete/{id}
  #DELETE /invoice/{type}/delete/{id}

  #Read Only user Read Only endpoints
  Scenario: 02 - I Call /search/invoice endpoint as Read Only user
    Given I set OAuth for user testread01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 03 - I Call /search/member endpoint as Read Only user
    Given I set OAuth for user testread01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

  Scenario: 04 - I Call /validate/header endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 05 - I Call /validate/edi/header endpoint as Read Only user
    Given I set OAuth for user testread01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 06 - I Call /validate/line endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 07 - I Call /validate/edi/line endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 08 - I Call /validate/retailer endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 09 - I Call /validate/edi/retailer endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 10 - I Call /validate/supplier endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 11 - I Call /validate/edi/supplier endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 12 - I Call /invoice/{id} endpoint as Read Only user
    Given I set OAuth for user testread01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 13 - I Call /invoice/{type}/{id} endpoint as Read Only user
    Given I set OAuth for user testread01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200


  #Read Only user Write endpoints
  Scenario: 14 - I Call /invoice/ endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 15 - I Call /invoice/edi endpoint as Read Only user
    Given I set OAuth for user testread01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 16 - I Call /invoice/delete/{id} endpoint as Read Only user
    Given I set OAuth for user testread01
    And I set the query URL to /invoice/delete/999
    When I execute the api DELETE query
    Then I should receive response status code 403

  Scenario: 17 - I Call /invoice/EDI/delete endpoint as Read Only user
    Given I set OAuth for user testread01
    And I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 403

  #CPoS Read Only endpoints
  Scenario: 18 - I Call /search/invoice endpoint as CPoS user
    Given I set OAuth for user testcpos01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 19 - I Call /search/member endpoint as CPoS user
    Given I set OAuth for user testcpos01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

  Scenario: 20 - I Call /validate/header endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 21 - I Call /validate/edi/header endpoint as CPoS user
    Given I set OAuth for user testcpos01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 22 - I Call /validate/line endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 23 - I Call /validate/edi/line endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 24 - I Call /validate/retailer endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 25 - I Call /validate/edi/retailer endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 26 - I Call /validate/supplier endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 27 - I Call /validate/edi/supplier endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 28 - I Call /invoice/{id} endpoint as CPoS user
    Given I set OAuth for user testcpos01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 29 - I Call /invoice/{type}/{id} endpoint as CPoS user
    Given I set OAuth for user testcpos01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200


  #CPoS Write endpoints
  Scenario: 30 - I Call /invoice/ endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 31 - I Call /invoice/edi endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 32 - I Call /invoice/delete/{id} endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And I set the query URL to /invoice/delete/999
    When I execute the api DELETE query
    Then I should receive response status code 403

  Scenario: 33 - I Call /invoice/EDI/delete endpoint as CPoS user
    Given I set OAuth for user testcpos01
    And I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 403

#Invoicing Read Only endpoints
  Scenario: 34 - I Call /search/invoice endpoint as Invoicing user
    Given I set OAuth for user testinv01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 35 - I Call /search/member endpoint as Invoicing user
    Given I set OAuth for user testinv01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

    Scenario: 36 - I Call /validate/header endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 37 - I Call /validate/edi/header endpoint as Invoicing user
    Given I set OAuth for user testinv01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 38 - I Call /validate/line endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 39 - I Call /validate/edi/line endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 40 - I Call /validate/retailer endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 41 - I Call /validate/edi/retailer endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 42 - I Call /validate/supplier endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 43 - I Call /validate/edi/supplier endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 44 - I Call /invoice/{id} endpoint as Invoicing user
    Given I set OAuth for user testinv01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 45 - I Call /invoice/{type}/{id} endpoint as Invoicing user
    Given I set OAuth for user testinv01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200


   #Invoicing POSTS
  Scenario: 46 - I Call /invoice/ endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201

  Scenario: 47 - I Call /invoice/edi endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 201

  Scenario: 48 - I Call /invoice/delete/{id} endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And I set the query URL to /invoice/delete/486
    When I execute the api DELETE query
    Then I should receive response status code 200

  Scenario: 49 - I Call /invoice/EDI/delete endpoint as Invoicing user
    Given I set OAuth for user testinv01
    And I set the query URL to /invoice/EDI/delete/1
    When I execute the api DELETE query
    Then I should receive response status code 200

    
    #Credit Control GETS
  Scenario: 50 - I Call /search/invoice endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 51 - I Call /search/member endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

  Scenario: 52 - I Call /validate/header endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 53 - I Call /validate/edi/header endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 54 - I Call /validate/line endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 55 - I Call /validate/edi/line endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 56 - I Call /validate/retailer endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 57 - I Call /validate/edi/retailer endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 58 - I Call /validate/supplier endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 59 - I Call /validate/edi/supplier endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 60 - I Call /invoice/{id} endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 61 - I Call /invoice/{type}/{id} endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200


   #Credit Control POSTS
  Scenario: 62 - I Call /invoice/ endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201

  Scenario: 63 - I Call /invoice/edi endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 201

   Scenario: 64 - I Call /invoice/delete/{id} endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And I set the query URL to /invoice/delete/999
    When I execute the api DELETE query
    Then I should receive response status code 200

  Scenario: 65 - I Call /invoice/EDI/delete endpoint as Credit Control user
    Given I set OAuth for user testcrcont01
    And I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 200

#Customer Services GETS
  Scenario: 66 - I Call /search/invoice endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 67 - I Call /search/member endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

  Scenario: 68 - I Call /validate/header endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 69 - I Call /validate/edi/header endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 70 - I Call /validate/line endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 71 - I Call /validate/edi/line endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 72 - I Call /validate/retailer endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 73 - I Call /validate/edi/retailer endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 74 - I Call /validate/supplier endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 75 - I Call /validate/edi/supplier endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 76 - I Call /invoice/{id} endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 77 - I Call /invoice/{type}/{id} endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200


   #Customer Services POSTS
  Scenario: 78 - I Call /invoice/ endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 79 - I Call /invoice/edi endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 80 - I Call /invoice/delete/{id} endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And I set the query URL to /invoice/delete/999
    When I execute the api DELETE query
    Then I should receive response status code 403

  Scenario: 81 - I Call /invoice/EDI/delete endpoint as Customer Services user
    Given I set OAuth for user testcustsv01
    And I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 403

    #Treasury GETS
  Scenario: 82 - I Call /search/invoice endpoint as Treasury user
    Given I set OAuth for user testtreas01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 83 - I Call /search/member endpoint as Treasury user
    Given I set OAuth for user testtreas01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

  Scenario: 84 - I Call /validate/header endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 85 - I Call /validate/edi/header endpoint as Treasury user
    Given I set OAuth for user testtreas01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 86 - I Call /validate/line endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 87 - I Call /validate/edi/line endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 88 - I Call /validate/retailer endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 89 - I Call /validate/edi/retailer endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 90 - I Call /validate/supplier endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 91 - I Call /validate/edi/supplier endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 92 - I Call /invoice/{id} endpoint as Treasury user
    Given I set OAuth for user testtreas01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 93 - I Call /invoice/{type}/{id} endpoint as Treasury user
    Given I set OAuth for user testtreas01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200

   #Treasury POSTS
  Scenario: 94 - I Call /invoice/ endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 95 - I Call /invoice/edi endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 96 - I Call /invoice/delete/{id} endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And I set the query URL to /invoice/delete/999
    When I execute the api DELETE query
    Then I should receive response status code 403

  Scenario: 97 - I Call /invoice/EDI/delete endpoint as Treasury user
    Given I set OAuth for user testtreas01
    And I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 403


     #No Access GETS
  Scenario: 98 - I Call /search/invoice endpoint as No Access user
    Given I set OAuth for user testnoaccess
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 403

  Scenario: 99 - I Call /search/member endpoint as No Access user
    Given I set OAuth for user testnoaccess
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 403

  Scenario: 100 - I Call /validate/header endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 101 - I Call /validate/edi/header endpoint as No Access user
    Given I set OAuth for user testnoaccess
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 403

  Scenario: 102 - I Call /validate/line endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 103 - I Call /validate/edi/line endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 104 - I Call /validate/retailer endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 105 - I Call /validate/edi/retailer endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 106 - I Call /validate/supplier endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 107 - I Call /validate/edi/supplier endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 108 - I Call /invoice/{id} endpoint as No Access user
    Given I set OAuth for user testnoaccess
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 403

  Scenario: 109 - I Call /invoice/{type}/{id} endpoint as No Access user
    Given I set OAuth for user testnoaccess
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 403



   #No Access POSTS
  Scenario: 110 - I Call /invoice/ endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 111 - I Call /invoice/edi endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 403

  Scenario: 112 - I Call /invoice/delete/{id} endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And I set the query URL to /invoice/delete/999
    When I execute the api DELETE query
    Then I should receive response status code 403

  Scenario: 113 - I Call /invoice/EDI/delete endpoint as No Access user
    Given I set OAuth for user testnoaccess
    And I set the query URL to /invoice/EDI/delete/2
    When I execute the api DELETE query
    Then I should receive response status code 403

    
  #Super user GETS
  Scenario: 114 - I Call /search/invoice endpoint as Super user
    Given I set OAuth for user testsuper01
    When I query GET endpoint "/search/invoice?invoiceNumber=EPI3658757"
    Then I should receive response status code 200

  Scenario: 115 - I Call /search/member endpoint as Super user
    Given I set OAuth for user testsuper01
    When I query GET endpoint "/search/invoice?memberCode=23406"
    Then I should receive response status code 200

  Scenario: 116 - I Call /validate/header endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/header/invoice_number_valid.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/header
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 117 - I Call /validate/edi/header endpoint as Super user
    Given I set OAuth for user testsuper01
    When I query "POST" endpoint "/validate/edi/header" with request body from file: "testdata/validate/header/invoice_status_e_edi_valid.json"
    Then I should receive response status code 200

  Scenario: 118 - I Call /validate/line endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/lines/validateAllValidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 119 - I Call /validate/edi/line endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/lines/validateAllInvalidLines.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/line
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 120 - I Call /validate/retailer endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 121 - I Call /validate/edi/retailer endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/retailer/validateInvalidRetailerEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/retailer
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 122 - I Call /validate/supplier endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/supplier/validateInvalidSupplierGen-0.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 123 - I Call /validate/edi/supplier endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/validate/supplier/validateValidSupplierCodeEDI.json
    And Request Content Type is set to: application/json
    And I set the query URL to /validate/edi/supplier
    When I execute the api POST query
    Then I should receive response status code 200

  Scenario: 124 - I Call /invoice/{id} endpoint as Super user
    Given I set OAuth for user testsuper01
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200

  Scenario: 125 - I Call /invoice/{type}/{id} endpoint as Super user
    Given I set OAuth for user testsuper01
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200



   #Super user POSTS
  Scenario: 126 - I Call /invoice/ endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/savePayloads/saveValidTransferred.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/
    When I execute the api POST query
    Then I should receive response status code 201

  Scenario: 127 - I Call /invoice/edi endpoint as Super user
    Given I set OAuth for user testsuper01
    And request body is set to contents of file: testdata/savePayloads/saveValidEDI_02.json
    And Request Content Type is set to: application/json
    And I set the query URL to /invoice/edi
    When I execute the api POST query
    Then I should receive response status code 201

  Scenario: 128 - I Call /invoice/delete/{id} endpoint as Super user
    Given I set OAuth for user testsuper01
    And I set the query URL to /invoice/delete/170
    When I execute the api DELETE query
    Then I should receive response status code 200

  Scenario: 129 - I Call /invoice/EDI/delete endpoint as Super user
    Given I set OAuth for user testsuper01
    And I set the query URL to /invoice/EDI/delete/22
    When I execute the api DELETE query
    Then I should receive response status code 200

