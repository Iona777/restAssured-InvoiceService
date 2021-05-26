Feature: 018 Retrieve User Details

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

    #Read Only user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
    #"ROLE_READ_INVOICE",
  Scenario: 02 - I call retrieve user details as Read Only user
    Given I set OAuth for user testread01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/readOnlylUserDetails.json

    #CPos user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
    #"ROLE_READ_CPOS_FEES",
    #"ROLE_READ_INVOICE",
    #"ROLE_WRITE_CPOS_FEES",
  Scenario: 03 - I call retrieve user details as CPoS user
    Given I set OAuth for user testcpos01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/cposUserDetails.json

    

    #Customer Services user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
    #"ROLE_READ_CPOS_FEES",
    #"ROLE_LEAFLET_MAINTENANCE",
    #"ROLE_READ_INVOICE",
  Scenario: 04 - I call retrieve user details as Customer Services  user
    Given I set OAuth for user testcustsv01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/customerServiceUserDetails.json

     #Credit Control user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
    #"ROLE_WRITE_INVOICE",
    #"ROLE_DIRECT_DEBIT",
    #"ROLE_READ_INVOICE",
  Scenario: 05 - I call retrieve user details as Credit Control  user
    Given I set OAuth for user testcrcont01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/creditControlUserDetails.json


    #Treasury user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
    #"ROLE_DIRECT_DEBIT",
    #"ROLE_END_OF_WEEK",
    #"ROLE_INVOICE_SUMMARY",
    #"ROLE_READ_INVOICE",
  Scenario: 06 - I call retrieve user details as Treasury  user
    Given I set OAuth for user testtreas01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/treasuryUserDetails.json

    #Invoicing user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
    #"ROLE_WRITE_INVOICE",
    #"ROLE_WRITE_INVOICE_AFTER_CUTOFF",
    #"ROLE_EDI_TRANSFER",
    #"ROLE_END_OF_WEEK",
    #"ROLE_INVOICE_SUMMARY",
    #"ROLE_EXTENDED_CREDIT",
    #"ROLE_READ_INVOICE",
  Scenario: 07 - I call retrieve user details as Invoicing  user
    Given I set OAuth for user testinv01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/invoicingUserDetails.json

    
    #Super user will have the following roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    #back as the roles do not come back in a consistent order.)
  #"ROLE_WRITE_INVOICE",
  #"ROLE_WRITE_INVOICE_AFTER_CUTOFF",
  #"ROLE_EDI_TRANSFER",
  #"ROLE_LEAFLET_MAINTENANCE",
  #"ROLE_END_OF_WEEK",
  #"ROLE_EXTENDED_CREDIT",
  #"ROLE_INVOICE_SUMMARY",
  #"ROLE_READ_INVOICE",
  #"ROLE_WRITE_CPOS_FEES",
  #"ROLE_READ_CPOS_FEES",
  #"ROLE_SUPER",
  #"ROLE_DIRECT_DEBIT",
  Scenario: 08 - I call retrieve user details as super user
    Given I set OAuth for user testsuper01
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/superUserDetails.json


    #No Access user will have no roles on Activ Billing (they will have other roles for other
    #systems, but we are not checking for them. They are included only because we have to check the whole file that comes
    # back as the roles do not come back in a consistent order.)
  Scenario: 09 - I call retrieve user details as No Access user
    Given I set OAuth for user testnoaccess
    When I set the query URL to /user/details
    When I execute the api GET query
    Then I should receive response status code 200
    Then response body matches JSON file testdata/userDetails/noAccessUserDetails.json



