Feature: 028 Fee Search

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
      | billing.fee_types             |
      | billing.fee_charges           |


    And I quickly load table data specified in files:
      | filepath                                  |
      | testdata/setup/fee_charges.json           |
      | testdata/setup/fee_types.json             |
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

    Scenario: 01 - I search using wrong user role
      Given I set OAuth for user testinv01
      And I set the query URL to /fees/search/ZCRSH
      When I execute the api GET query
      Then I should receive response status code 403
    
    Scenario: 02 - Search by Supplier Code Only
      Given I set OAuth for user testcpos01
      And I set the query URL to /fees/search/ZCRSH
      When I execute the api GET query
      Then I should receive response status code 200
      And The following JSON values are present in the response:
        | item                | value                    |
        | [0].id              | 3050                     |
        | [0].memberCode      | 100744                   |
        | [0].memberName      | MR HARPAWAN SINGH SAHOTA |
        | [0].memberTown      | HACKNEY                  |
        | [0].memberOpenDate  | 2015-07-23               |
        | [0].memberCloseDate | null                     |
        | [0].feeCode         | PHC                      |
        | [0].frequency       | W                        |
        | [0].amount          | 10.0                     |
        | [0].feeStartDate    | 2014-01-02               |
        | [0].feeEndDate      | 2014-01-30               |
        | [0].invoice         | 1928870                  |



        | [1].id         | 3060  |
        | [1].memberCode | 23579 |
