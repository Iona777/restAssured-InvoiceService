Feature: 011 Invoice Header Validate On GET

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

   # Transferred

 #Check that date comes back as VALID - that shows validation has run against these fields
  #Data amended so all header, supplier and retailer fields return a value
  Scenario: 02 - Search by ID
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200
    And The following values are present in the response:
    #Header
      | item                        | value                                    | status | message |
      | header.invoiceNumber        | EPI3662277                               | VALID  | null    |
      | header.invoiceType          | E                                        | VALID  | null    |
      | header.invoiceDate          | 2020-12-16                               | VALID  | null    |
      | header.weekNumber           | 50                                       | VALID  | null    |
      | header.yearNumber           | 2021                                     | VALID  | null    |
      | header.invoiceStatus        | O                                        | VALID  | null    |
      | header.description          | This is a description                    | VALID  | null    |
    #Retailer
      | retailer.code               | 72196                                    | VALID  | null    |
      | retailer.name               | SIMPLY FRESH -DRINKSWORLD LTD MR K KHERA | VALID  | null    |
      | retailer.addressLine1       | SIMPLY FRESH                             | VALID  | null    |
      | retailer.addressLine2       | 5 - 7 HIGH STREET                        | VALID  | null    |
      | retailer.addressLine3       | Midtown                                  | VALID  | null    |
      | retailer.addressLine4       | Dunney-on-the-wold                       | VALID  | null    |
      | retailer.postcode           | B49 5AE                                  | VALID  | null    |
      | retailer.vatNumber          | V78912378                                | VALID  | null    |
      | retailer.supplierAccount    | C31688                                   | VALID  | null    |
      #Supplier
      | supplier.generation         | 567                                      | VALID  | null    |
      | supplier.code               | NISA                                     | VALID  | null    |
      | supplier.name               | NISAWAY                                  | VALID  | null    |
      | supplier.addressLine1       | P.O BOX 58                               | VALID  | null    |
      | supplier.addressLine2       | SCUNTHORPE                               | VALID  | null    |
      | supplier.addressLine3       | NORTH LINCOLNSHIRE                       | VALID  | null    |
      | supplier.addressLine4       | Someplace                                | VALID  | null    |
      | supplier.postcode           | DN15 8QQ                                 | VALID  | null    |
      | supplier.partnerStatus      | L                                        | VALID  | null    |
    #Lines
      | lines[0].productCode        | 34200                                    | VALID  | null    |
      | lines[0].unitWeight         | 1.500                                    | null   | null    |
      | lines[0].units              | 5.000                                    | null   | null    |
      | lines[0].unitCost           | 21.2500                                  | null   | null    |
      | lines[0].unitCostExVat      | 106.25                                   | null   | null    |
      | lines[0].vatPercent         | 20                                       | null   | null    |
      | lines[0].vatCode            | S                                        | null   | null    |
      | lines[0].discountAmount     | 5.5000                                   | null   | null    |
      | lines[0].vatAmount          | null                                     | null   | null    |
      | lines[0].totalAmount        | 127.50                                   | null   | null    |
      | lines[0].productDescription | CADBURY CREME EGG TIN                    | VALID  | null    |


    ##EDI
  Scenario: 03 - Search by ID - EDI
    When I query GET endpoint "/invoice/edi/50"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                 | value   | status  | message                                  |
      | header.invoiceNumber | 2020556 | VALID   | null                                     |
      | header.invoiceType   | B       | INVALID | The invoice type must be 'E', 'I' or 'M' |
      | retailer.code        | null    | INVALID | The retailer code must not be blank      |
      | supplier.code        | CAMB    | VALID   | null                                     |


    #Check that date comes back as VALID - that shows validation has run against these fields
  Scenario: 04 - Search by ID - EDI
    When I query GET endpoint "/invoice/edi/3"
    Then I should receive response status code 200
    And The following values are present in the response:
      | item                     | value                  | status | message |
      | header.invoiceNumber     | 3725073                | VALID  | null    |
      | header.invoiceType       | E                      | VALID  | null    |
      | header.invoiceDate       | 2021-02-14             | VALID  | null    |
      | header.invoiceStatus     | P                      | VALID  | null    |
      | header.description       | null                   | VALID  | null    |
    #Retailer
      | retailer.code            | 85012                  | VALID  | null    |
      | retailer.name            | CHARLES WALSH          | VALID  | null    |
      | retailer.addressLine1    | SUPERSHOP              | VALID  | null    |
      | retailer.addressLine2    | 33 GLEBETOWN DRIVE     | VALID  | null    |
      | retailer.addressLine3    | KILLOUGH ROAD          | VALID  | null    |
      | retailer.addressLine4    | Sometown               | VALID  | null    |
      | retailer.postcode        | BT30 6QD               | VALID  | null    |
      | retailer.vatNumber       | V87456321              | VALID  | null    |
      | retailer.supplierAccount | C34704                 | VALID  | null    |
#Supplier
      | supplier.code            | CAMB                   | VALID  | null    |
      | supplier.name            | COOP AMBIENT           | VALID  | null    |
      | supplier.addressLine1    | COOPERATIVE GROUP FOOD | VALID  | null    |
      | supplier.addressLine2    | ANGEL AQUARE           | VALID  | null    |
      | supplier.addressLine3    | MANCHESTER             | VALID  | null    |
      | supplier.addressLine4    | null                   | VALID  | null    |
      | supplier.postcode        | M60 0AG                | VALID  | null    |
      | supplier.partnerStatus   | L                      | VALID  | null    |


