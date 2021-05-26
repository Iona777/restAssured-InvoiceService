Feature: 002 Invoice Headers endpoint

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

  Scenario: 02 I Call endpoint without ID
    When I query GET endpoint "/invoice/"
    Then I should receive response status code 500

  Scenario: 03 I Call endpoint with invalid ID
    When I query GET endpoint "/invoice/9999"
    Then I should receive response status code 404

  Scenario: 04 - Search by ID
    When I query GET endpoint "/invoice/131"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id  | item                                      | value                                |
      | 131 | header.ediTransferDate                    | <null>                               |
      | 131 | header.weekClosed                         | true                                 |
      | 131 | header.invoiceNumber                      | 1928892                              |
      | 131 | header.invoiceType                        | I                                    |
      | 131 | header.invoiceDate                        | 2021-01-14                           |
      | 131 | header.weekNumber                         | 3                                    |
      | 131 | header.yearNumber                         | 2021                                 |
      | 131 | header.invoiceStatus                      | A                                    |
      | 131 | header.description                        | Weekly Epos Support Fee              |
      | 131 | totals.zeroVatAmount                      | 0.00                                 |
      | 131 | totals.specialVatAmount                   | 0.00                                 |
      | 131 | totals.stdVatAmount                       | 41.25                                |
      | 131 | totals.netAmount                          | 41.25                                |
      | 131 | totals.vatAmount                          | 8.25                                 |
      | 131 | totals.totalAmount                        | 49.50                                |
    #Retailer
      | 131 | retailer.code                             | 100789                               |
      | 131 | retailer.name                             | MR KATHIRKAMALINDAM & MR THARMATHASS |
      | 131 | retailer.addressLine1                     | COSTCUTTER                           |
      | 131 | retailer.addressLine2                     | OLD STOWMARKET ROAD                  |
      | 131 | retailer.addressLine3                     | WOOLPIT                              |
      | 131 | retailer.addressLine4                     | <null>                               |
      | 131 | retailer.postcode                         | IP30 9QT                             |
      | 131 | retailer.vatNumber                        | <null>                               |
      | 131 | retailer.supplierAccount                  | C30470                               |
      | 131 | retailer.orderNumber                      | <null>                               |
      | 131 | retailer.orderDate                        | <null>                               |
      | 131 | retailer.taxDate                          | <null>                               |
      | 131 | retailer.deliveryDate                     | <null>                               |
      | 131 | retailer.unitsDelivered                   | 0                                    |
      | 131 | retailer.deliveryNumber                   | <null>                               |
      #Supplier
      | 131 | supplier.generation                       | 0                                    |
      | 131 | supplier.code                             | ZCRSM                                |
      | 131 | supplier.name                             | RETAIL SOLUTIONS MAINTENANCE         |
      | 131 | supplier.addressLine1                     | UNKNOWN                              |
      | 131 | supplier.addressLine2                     | UNKNOWN                              |
      | 131 | supplier.addressLine3                     | UNKNOWN                              |
      | 131 | supplier.addressLine4                     | <null>                               |
      | 131 | supplier.postcode                         | <null>                               |
      | 131 | supplier.partnerStatus                    | T                                    |
       #Lines
      | 131 | lines[0].productCode                      | FR2B                                 |
      | 131 | lines[0].unitWeight                       | <null>                               |
      | 131 | lines[0].units                            | 1.000                                |
      | 131 | lines[0].unitCost                         | 41.2500                              |
      | 131 | lines[0].unitCostExVat                    | 41.2500                              |
      | 131 | lines[0].vatPercent                       | 20                                   |
      | 131 | lines[0].vatCode                          | S                                    |
      | 131 | lines[0].vatAmount                        | 8.2500                               |
      | 131 | lines[0].discountAmount                   | <null>                               |
      | 131 | lines[0].totalAmount                      | 49.50                                |
      | 131 | lines[0].productDescription               | Weekly Epos Support Fee              |
      | 131 | lines[0].measurementIndicator             | EA                                   |
    #AccountInformation
      |131 | accountInformation.qydaZero  | <null>      |
      |131 | accountInformation.qydaMix   | <null>      |
      |131 | accountInformation.qydaStd   | <null>      |

      |131 | accountInformation.vldaZero  | <null>      |
      |131 | accountInformation.vldaMix   | <null>      |
      |131 | accountInformation.vldaStd   | <null>      |

      |131 | accountInformation.evlaZero | <null>       |
      |131 | accountInformation.evlaMix  | <null>       |
      |131 | accountInformation.evlaStd  | <null>       |

      |131 | accountInformation.asdaZero| <null>        |
      |131 | accountInformation.asdaMix | <null>        |
      |131 | accountInformation.asdaStd | <null>        |

      |131 | accountInformation.vataZero| <null>        |
      |131 | accountInformation.vataMix | <null>        |
      |131 | accountInformation.vataStd | <null>        |

      |131 | accountInformation.sedaZero| <null>        |
      |131 | accountInformation.sedaMix | <null>        |
      |131 | accountInformation.sedaStd | <null>        |

      |131 | accountInformation.apseZero| <null>        |
      |131 | accountInformation.apseMix | <null>        |
      |131 | accountInformation.apseStd | <null>        |

      |131 | accountInformation.lvlaZero| <null>        |
      |131 | accountInformation.lvlaMix | <null>        |
      |131 | accountInformation.lvlaStd | <null>        |

      |131 | accountInformation.nrilZero| <null>        |
      |131 | accountInformation.nrilMix | <null>        |
      |131 | accountInformation.nrilStd | <null>        |

      |131 | accountInformation.apsiZero| <null>        |
      |131 | accountInformation.apsiMix | <null>        |
      |131 | accountInformation.apsiStd | <null>        |

      |131 | accountInformation.aspiZero| <null>        |
      |131 | accountInformation.aspiMix | <null>        |
      |131 | accountInformation.aspiStd | <null>        |

      |131 | accountInformation.evltTotal | <null>      |
      |131 | accountInformation.sedtTotal | <null>      |
      |131 | accountInformation.asdtTotal | <null>      |

      |131 | accountInformation.tvatTotal | <null>      |
      |131 | accountInformation.tpsiTotal | <null>      |
      |131 | accountInformation.vldtTotal | <null>      |
      |131 | accountInformation.tpseTotal | <null>      |

      |131 | accountInformation.retExtA | <null>        |
      |131 | accountInformation.retExtB | <null>        |
      |131 | accountInformation.retExtC | <null>        |

      |131 | accountInformation.invoiceCreditIndicator  | false  |
      |131 | accountInformation.procCode                | false  |
    # ErrorMessage
      |131 | errorMessage.text          | <null>        |


  Scenario: 05 - Search by ID
    When I query GET endpoint "/invoice/51"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id | item                  | value            |
      | 51 | header.ediTransferDate| <null>           |
      | 51 | header.weekClosed     | false            |
      | 51 | header.invoiceNumber  | 1928941          |
      | 51 | header.invoiceType    | I                |
      | 51 | header.invoiceDate    | 2021-01-14       |
      | 51 | header.weekNumber     | 52               |
      | 51 | header.yearNumber     | 2021             |
      | 51 | header.invoiceStatus  | O                |
      | 51 | header.description    | AUTO-GENERATED EBOR VAT CONTRA |
      | 51 | totals.zeroVatAmount  | -1750.00         |
      | 51 | totals.specialVatAmount  | -8.95         |
      | 51 | totals.stdVatAmount   | 0.00             |
      | 51 | totals.netAmount      | -1750.00         |
      | 51 | totals.vatAmount      | 0.00             |
      | 51 | totals.totalAmount    | -1750.00         |
    #Retailer
      |51 | retailer.code          | 71881            |
      |51 | retailer.name          | EBOR COSTCUTTER SUPERMARKET GROUP |
      |51 | retailer.addressLine1  | COSTCUTTER       |
      |51 | retailer.addressLine2  | 247 SKIPTON ROAD |
      |51 | retailer.addressLine3  | .                |
      |51 | retailer.addressLine4  | .                |
      |51 | retailer.postcode      | HG1 3EY          |
      |51 | retailer.vatNumber     | 847206620        |
      |51 | retailer.supplierAccount | C35187         |
      |51 | retailer.orderNumber   | <null>           |
      |51 | retailer.orderDate     | <null>           |
      |51 | retailer.taxDate       | <null>           |
      |51 | retailer.deliveryDate  | <null>           |
      |51 | retailer.unitsDelivered| 0                |
      |51 | retailer.deliveryNumber| <null>           |
      #Supplier
      |51 | supplier.generation    | 0                |
      |51 | supplier.code          | ZVAT             |
      |51 | supplier.name          | EBOR VAT CONTRAS |
      |51 | supplier.addressLine1  | UNKNOWN          |
      |51 | supplier.addressLine2  | UNKNOWN          |
      |51 | supplier.addressLine3  | <null>           |
      |51 | supplier.addressLine4  | <null>           |
      |51 | supplier.postcode      | <null>           |
      |51 | supplier.partnerStatus | T                |
    #Lines
      | 51 | lines[0].productCode    | CREDIT		  |
      | 51 | lines[0].unitWeight     | <null>         |
      | 51 | lines[0].units          | 1.000          |
      | 51 | lines[0].unitCost       | -1750.0000     |
      | 51 | lines[0].unitCostExVat  | -1750.0000     |
      | 51 | lines[0].vatPercent     | 0              |
      | 51 | lines[0].vatCode        | Z              |
      | 51 | lines[0].vatAmount      | 0.0000         |
      | 51 | lines[0].discountAmount | <null>         |
      | 51 | lines[0].totalAmount    | -1750.00       |
      | 51 | lines[0].productDescription | AUTO_GENERATED EBOR VAT CONTRA |
      | 51 | lines[0].measurementIndicator | EA       |

    #AccountInformation
      |51 | accountInformation.qydaZero  | <null>      |
      |51 | accountInformation.qydaMix   | <null>      |
      |51 | accountInformation.qydaStd   | <null>      |

      |51 | accountInformation.vldaZero  | <null>      |
      |51 | accountInformation.vldaMix   | <null>      |
      |51 | accountInformation.vldaStd   | <null>      |

      |51 | accountInformation.evlaZero | <null>       |
      |51 | accountInformation.evlaMix  | <null>       |
      |51 | accountInformation.evlaStd  | <null>       |

      |51 | accountInformation.asdaZero| <null>        |
      |51 | accountInformation.asdaMix | <null>        |
      |51 | accountInformation.asdaStd | <null>        |

      |51 | accountInformation.vataZero| <null>        |
      |51 | accountInformation.vataMix | <null>        |
      |51 | accountInformation.vataStd | <null>        |

      |51 | accountInformation.sedaZero| <null>        |
      |51 | accountInformation.sedaMix | <null>        |
      |51 | accountInformation.sedaStd | <null>        |

      |51 | accountInformation.apseZero| <null>        |
      |51 | accountInformation.apseMix | <null>        |
      |51 | accountInformation.apseStd | <null>        |

      |51 | accountInformation.lvlaZero| <null>        |
      |51 | accountInformation.lvlaMix | <null>        |
      |51 | accountInformation.lvlaStd | <null>        |

      |51 | accountInformation.nrilZero| <null>        |
      |51 | accountInformation.nrilMix | <null>        |
      |51 | accountInformation.nrilStd | <null>        |

      |51 | accountInformation.apsiZero| <null>        |
      |51 | accountInformation.apsiMix | <null>        |
      |51 | accountInformation.apsiStd | <null>        |

      |51 | accountInformation.aspiZero| <null>        |
      |51 | accountInformation.aspiMix | <null>        |
      |51 | accountInformation.aspiStd | <null>        |

      |51 | accountInformation.evltTotal | <null>      |
      |51 | accountInformation.sedtTotal | <null>      |
      |51 | accountInformation.asdtTotal | <null>      |

      |51 | accountInformation.tvatTotal | <null>      |
      |51 | accountInformation.tpsiTotal | <null>      |
      |51 | accountInformation.vldtTotal | <null>      |
      |51 | accountInformation.tpseTotal | <null>      |

      |51 | accountInformation.retExtA | <null>        |
      |51 | accountInformation.retExtB | <null>        |
      |51 | accountInformation.retExtC | <null>        |

      |51 | accountInformation.invoiceCreditIndicator  | false  |
      |51 | accountInformation.procCode                | false  |
    # ErrorMessage
      |51 | errorMessage.text          | <null>        |



  Scenario: 06 - Search by ID
    When I query GET endpoint "/invoice/160"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id  | item                                      | value                        |
      | 160 | header.ediTransferDate                    | <null>                       |
      | 160 | header.weekClosed                         | false                        |
      | 160 | header.invoiceNumber                      | 1401202162863RM              |
      | 160 | header.invoiceType                        | M                            |
      | 160 | header.invoiceDate                        | 2021-01-14                   |
      | 160 | header.weekNumber                         | 50                           |
      | 160 | header.yearNumber                         | 2021                         |
      | 160 | header.invoiceStatus                      | O                            |
      | 160 | header.description                        | <null>                       |
      | 160 | totals.zeroVatAmount                      | 0.00                         |
      | 160 | totals.specialVatAmount                   | -1.95                        |
      | 160 | totals.stdVatAmount                       | 7.50                         |
      | 160 | totals.netAmount                          | 7.50                         |
      | 160 | totals.vatAmount                          | 3.00                         |
      | 160 | totals.totalAmount                        | 10.50                        |
    #Retailer
      |160 | retailer.code          | 62863             |
      |160 | retailer.name          | DAVID & TRACEY STEELE |
      |160 | retailer.addressLine1  | COSTCUTTER        |
      |160 | retailer.addressLine2  | 39 BROOK STREET   |
      |160 | retailer.addressLine3  | <null>            |
      |160 | retailer.addressLine4  | <null>            |
      |160 | retailer.postcode      | EX16 9LU          |
      |160 | retailer.vatNumber     | <null>            |
      |160 | retailer.supplierAccount | C22433          |
      |160 | retailer.orderNumber   | <null>            |
      |160 | retailer.orderDate     | <null>            |
      |160 | retailer.taxDate       | <null>            |
      |160 | retailer.deliveryDate  | <null>            |
      |160 | retailer.unitsDelivered| 0                 |
      |160 | retailer.deliveryNumber| <null>            |
      #Supplier
      |160 | supplier.generation    | 1                 |
      |160 | supplier.code          | ZRADM             |
      |160 | supplier.name          | RADIO MAINTENANCE / INVISION |
      |160 | supplier.addressLine1  | UNKNOWN           |
      |160 | supplier.addressLine2  | UNKNOWN           |
      |160 | supplier.addressLine3  | <null>            |
      |160 | supplier.addressLine4  | <null>            |
      |160 | supplier.postcode      | <null>            |
      |160 | supplier.partnerStatus | T                 |
  #Lines
      | 160 | lines[0].productCode                      | 121                          |
      | 160 | lines[0].unitWeight                       | <null>                       |
      | 160 | lines[0].units                            | 2.000                        |
      | 160 | lines[0].unitCost                         | 7.5000                       |
      | 160 | lines[0].unitCostExVat                    | 7.5000                       |
      | 160 | lines[0].vatPercent                       | 20                           |
      | 160 | lines[0].vatCode                          | S                            |
      | 160 | lines[0].vatAmount                        | 3.0000                       |
      | 160 | lines[0].discountAmount                   | <null>                       |
      | 160 | lines[0].totalAmount                      | 9.00                        |
      | 160 | lines[0].productDescription               | Small Cuddly Toy             |
      | 160 | lines[0].measurementIndicator             | EA                           |

    #AccountInformation
      |160 | accountInformation.qydaZero  | <null>      |
      |160 | accountInformation.qydaMix   | <null>      |
      |160 | accountInformation.qydaStd   | <null>      |

      |160 | accountInformation.vldaZero  | <null>      |
      |160 | accountInformation.vldaMix   | <null>      |
      |160 | accountInformation.vldaStd   | <null>      |

      |160 | accountInformation.evlaZero | <null>       |
      |160 | accountInformation.evlaMix  | <null>       |
      |160 | accountInformation.evlaStd  | <null>       |

      |160 | accountInformation.asdaZero| <null>        |
      |160 | accountInformation.asdaMix | <null>        |
      |160 | accountInformation.asdaStd | <null>        |

      |160 | accountInformation.vataZero| <null>        |
      |160 | accountInformation.vataMix | <null>        |
      |160 | accountInformation.vataStd | <null>        |

      |160 | accountInformation.sedaZero| <null>        |
      |160 | accountInformation.sedaMix | <null>        |
      |160 | accountInformation.sedaStd | <null>        |

      |160 | accountInformation.apseZero| <null>        |
      |160 | accountInformation.apseMix | <null>        |
      |160 | accountInformation.apseStd | <null>        |

      |160 | accountInformation.lvlaZero| <null>        |
      |160 | accountInformation.lvlaMix | <null>        |
      |160 | accountInformation.lvlaStd | <null>        |

      |160 | accountInformation.nrilZero| <null>        |
      |160 | accountInformation.nrilMix | <null>        |
      |160 | accountInformation.nrilStd | <null>        |

      |160 | accountInformation.apsiZero| <null>        |
      |160 | accountInformation.apsiMix | <null>        |
      |160 | accountInformation.apsiStd | <null>        |

      |160 | accountInformation.aspiZero| <null>        |
      |160 | accountInformation.aspiMix | <null>        |
      |160 | accountInformation.aspiStd | <null>        |

      |160 | accountInformation.evltTotal | <null>      |
      |160 | accountInformation.sedtTotal | <null>      |
      |160 | accountInformation.asdtTotal | <null>      |

      |160 | accountInformation.tvatTotal | <null>      |
      |160 | accountInformation.tpsiTotal | <null>      |
      |160 | accountInformation.vldtTotal | <null>      |
      |160 | accountInformation.tpseTotal | <null>      |

      |160 | accountInformation.retExtA | <null>        |
      |160 | accountInformation.retExtB | <null>        |
      |160 | accountInformation.retExtC | <null>        |

      |160 | accountInformation.invoiceCreditIndicator  | false   |
      |160 | accountInformation.procCode  | false       |
    # ErrorMessage
      |160 | errorMessage.text            | <null>      |


   #Data amended so all header, supplier and retailer fields return a value
  Scenario: 07 - Search by ID
    When I query GET endpoint "/invoice/1"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id | item                                      | value                                    |
      | 1  | header.ediTransferDate                    | 2020-12-15                               |
      | 1  | header.weekClosed                         | false                                    |
      | 1  | header.invoiceNumber                      | EPI3662277                               |
      | 1  | header.invoiceType                        | E                                        |
      | 1  | header.invoiceDate                        | 2020-12-16                               |
      | 1  | header.weekNumber                         | 50                                       |
      | 1  | header.yearNumber                         | 2021                                     |
      | 1  | header.invoiceStatus                      | O                                        |
      | 1  | header.description                        | This is a description                    |
      | 1  | totals.zeroVatAmount                      | 100.00                                   |
      | 1  | totals.specialVatAmount                   | 200.00                                   |
      | 1  | totals.stdVatAmount                       | 239.50                                   |
      | 1  | totals.netAmount                          | 539.50                                   |
      | 1  | totals.vatAmount                          | 47.90                                    |
      | 1  | totals.totalAmount                        | 587.40                                   |
    #Retailer
      |1 | retailer.code          | 72196             |
      |1 | retailer.name          | SIMPLY FRESH -DRINKSWORLD LTD MR K KHERA |
      |1 | retailer.addressLine1  | SIMPLY FRESH      |
      |1 | retailer.addressLine2  | 5 - 7 HIGH STREET |
      |1 | retailer.addressLine3  | Midtown           |
      |1 | retailer.addressLine4  | Dunney-on-the-wold|
      |1 | retailer.postcode      | B49 5AE           |
      |1 | retailer.vatNumber     | V78912378         |
      |1 | retailer.supplierAccount | C31688          |
      |1 | retailer.orderNumber   | 3662277           |
      |1 | retailer.orderDate     | 2020-12-14        |
      |1 | retailer.taxDate       | 2020-12-14        |
      |1 | retailer.deliveryDate  | 2020-12-16        |
      |1 | retailer.unitsDelivered| 5                 |
      |1 | retailer.deliveryNumber| 123               |
      #Supplier
      |1 | supplier.generation    | 567               |
      |1 | supplier.code          | NISA              |
      |1 | supplier.name          | NISAWAY           |
      |1 | supplier.addressLine1  | P.O BOX 58        |
      |1 | supplier.addressLine2  | SCUNTHORPE        |
      |1 | supplier.addressLine3  | NORTH LINCOLNSHIRE|
      |1 | supplier.addressLine4  | Someplace         |
      |1 | supplier.postcode      | DN15 8QQ          |
      |1 | supplier.partnerStatus | L                 |
    #Lines
      | 1  | lines[0].productCode                      | 34200                                    |
      | 1  | lines[0].unitWeight                       | 1.500                                    |
      | 1  | lines[0].units                            | 5.000                                    |
      | 1  | lines[0].unitCost                         | 21.2500                                  |
      | 1  | lines[0].unitCostExVat                    | 106.2500                                 |
      | 1  | lines[0].vatPercent                       | 20                                       |
      | 1  | lines[0].vatCode                          | S                                        |
      | 1  | lines[0].discountAmount                   | 5.5000                                   |
      | 1  | lines[0].vatAmount                        | <null>                                   |
      | 1  | lines[0].totalAmount                      | 127.50                                   |
      | 1  | lines[0].productDescription               | CADBURY CREME EGG TIN                    |
      | 1  | lines[0].measurementIndicator             | EA                                       |

    #AccountInformation
      |1 | accountInformation.qydaZero  | <null>   |
      |1 | accountInformation.qydaMix   | <null>   |
      |1 | accountInformation.qydaStd   | <null>   |

      |1 | accountInformation.vldaZero  | <null>   |
      |1 | accountInformation.vldaMix   | <null>   |
      |1 | accountInformation.vldaStd   | <null>   |

      |1 | accountInformation.evlaZero | <null>    |
      |1 | accountInformation.evlaMix  | <null>    |
      |1 | accountInformation.evlaStd  | <null>    |

      |1 | accountInformation.asdaZero| <null>     |
      |1 | accountInformation.asdaMix | <null>     |
      |1 | accountInformation.asdaStd | <null>     |

      |1 | accountInformation.vataZero| <null>     |
      |1 | accountInformation.vataMix | <null>     |
      |1 | accountInformation.vataStd | <null>     |

      |1 | accountInformation.sedaZero| <null>     |
      |1 | accountInformation.sedaMix | <null>     |
      |1 | accountInformation.sedaStd | <null>     |

      |1 | accountInformation.apseZero| <null>     |
      |1 | accountInformation.apseMix | <null>     |
      |1 | accountInformation.apseStd | <null>     |

      |1 | accountInformation.lvlaZero| <null>     |
      |1 | accountInformation.lvlaMix | <null>     |
      |1 | accountInformation.lvlaStd | <null>     |

      |1 | accountInformation.nrilZero| <null>     |
      |1 | accountInformation.nrilMix | <null>     |
      |1 | accountInformation.nrilStd | <null>     |

      |1 | accountInformation.apsiZero| <null>     |
      |1 | accountInformation.apsiMix | <null>     |
      |1 | accountInformation.apsiStd | <null>     |

      |1 | accountInformation.aspiZero| <null>     |
      |1 | accountInformation.aspiMix | <null>     |
      |1 | accountInformation.aspiStd | <null>     |

      |1 | accountInformation.evltTotal | <null>   |
      |1 | accountInformation.sedtTotal | <null>   |
      |1 | accountInformation.asdtTotal | <null>   |

      |1 | accountInformation.tvatTotal | <null>   |
      |1 | accountInformation.tpsiTotal | <null>   |
      |1 | accountInformation.vldtTotal | <null>   |
      |1 | accountInformation.tpseTotal | <null>   |

      |1 | accountInformation.retExtA | <null>     |
      |1 | accountInformation.retExtB | <null>     |
      |1 | accountInformation.retExtC | <null>     |

      |1 | accountInformation.invoiceCreditIndicator  | false  |
      |1 | accountInformation.procCode                | false  |
    # ErrorMessage
      |1 | errorMessage.text          | This is another error message |

  Scenario: 08 - Search by ID - EDI
    When I query GET endpoint "/invoice/edi/7"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id| item                    | value           |
      | 7 | header.ediTransferDate  | <null>          |
      | 7 | header.weekClosed       | false           |
      | 7 | header.invoiceNumber    | 3725077         |
      | 7 | header.invoiceType      | E               |
      | 7 | header.invoiceDate      | 2021-02-14      |
      | 7 | header.weekNumber       | <null>          |
      | 7 | header.yearNumber       | <null>          |
      | 7 | header.invoiceStatus    | P               |
      | 7 | header.description      | <null>          |
      | 7 | totals.zeroVatAmount    | 3.80            |
      | 7 | totals.specialVatAmount | 0.00            |
      | 7 | totals.stdVatAmount     | 0.96            |
      | 7 | totals.netAmount        | 4.76            |
      | 7 | totals.vatAmount        | 0.19            |
      | 7 | totals.totalAmount      | 4.95            |
    #Retailer
      |7 | retailer.code          | 113488            |
      |7 | retailer.name          | EBOR FRANCHISE    |
      |7 | retailer.addressLine1  | EBOR FRANCHISE    |
      |7 | retailer.addressLine2  | CO-OP             |
      |7 | retailer.addressLine3  | MARKET PLACE      |
      |7 | retailer.addressLine4  | <null>            |
      |7 | retailer.postcode      | DN19 7BZ          |
      |7 | retailer.vatNumber     | <null>            |
      |7 | retailer.supplierAccount | XXXXXX          |
      |7 | retailer.orderNumber   | 01212             |
      |7 | retailer.orderDate     | <null>            |
      |7 | retailer.taxDate       | 2021-02-14        |
      |7 | retailer.deliveryDate  | 2021-02-14        |
      |7 | retailer.unitsDelivered| 2                 |
      |7 | retailer.deliveryNumber| <null>            |
       #Supplier
      |7 | supplier.code          | CAMB              |
      |7 | supplier.name          | COOP AMBIENT      |
      |7 | supplier.addressLine1  | COOPERATIVE GROUP FOOD |
      |7 | supplier.addressLine2  | ANGEL AQUARE      |
      |7 | supplier.addressLine3  | MANCHESTER        |
      |7 | supplier.addressLine4  | <null>            |
      |7 | supplier.postcode      | M60 0AG           |
      |7 | supplier.partnerStatus | L                 |
    #Lines
      | 7 | lines[0].productCode    | 205613          |
      | 7 | lines[0].unitWeight     | 1.000           |
      | 7 | lines[0].units          | 1.000           |
      | 7 | lines[0].unitCost       | 3.8000          |
      | 7 | lines[0].unitCostExVat  | 3.8000          |
      | 7 | lines[0].vatPercent     | 0.0000          |
      | 7 | lines[0].vatCode        | Z               |
      | 7 | lines[0].discountAmount | 0.0000          |
      | 7 | lines[0].vatAmount      | 0.00            |
      | 7 | lines[0].totalAmount    | 3.80            |
      | 7 | lines[0].productDescription | Co-op Chow Mein Stir Fry Sauce PMP |
      | 7 | lines[0].measurementIndicator | EA        |
    #VatRates
      | 7 | vatRates[0].code             | S        |
      | 7 | vatRates[0].rate             | 20.00    |
      | 7 | vatRates[0].specialVatAmount | -20.0000 |
      | 7 | vatRates[0].vatPayable       | 1.2500   |
      | 7 | vatRates[0].description      | <null>   |
    #AccountInformation
      |7 | accountInformation.qydaZero  | 0.00    |
      |7 | accountInformation.qydaMix   | 0.00    |
      |7 | accountInformation.qydaStd   | 0.00    |

      |7 | accountInformation.vldaZero  | 0.00    |
      |7 | accountInformation.vldaMix   | 0.00    |
      |7 | accountInformation.vldaStd   | 0.00    |

      |7 | accountInformation.evlaZero  | 3.80    |
      |7 | accountInformation.evlaMix   | 0.00    |
      |7 | accountInformation.evlaStd   | 0.96    |

      |7 | accountInformation.asdaZero  | 3.80    |
      |7 | accountInformation.asdaMix   | 0.00    |
      |7 | accountInformation.asdaStd   | 0.96    |

      |7 | accountInformation.vataZero  | 0.00    |
      |7 | accountInformation.vataMix   | 0.00    |
      |7 | accountInformation.vataStd   | 0.19    |

      |7 | accountInformation.sedaZero  | 0.00    |
      |7 | accountInformation.sedaMix   | 0.00    |
      |7 | accountInformation.sedaStd   | 0.00    |

      |7 | accountInformation.apseZero  | 3.80    |
      |7 | accountInformation.apseMix   | 0.00    |
      |7 | accountInformation.apseStd   | 0.96    |

      |7 | accountInformation.lvlaZero  | 3.80    |
      |7 | accountInformation.lvlaMix   | 0.00    |
      |7 | accountInformation.lvlaStd   | 0.96    |

      |7 | accountInformation.nrilZero  | 1.00    |
      |7 | accountInformation.nrilMix   | 0.00    |
      |7 | accountInformation.nrilStd   | 1.00    |

      |7 | accountInformation.apsiZero  | 0.00    |
      |7 | accountInformation.apsiMix   | 0.00    |
      |7 | accountInformation.apsiStd   | 0.00    |

      |7 | accountInformation.aspiZero  | 0.00    |
      |7 | accountInformation.aspiMix   | 0.00    |
      |7 | accountInformation.aspiStd   | 0.00    |

      |7 | accountInformation.evltTotal | 4.76    |
      |7 | accountInformation.sedtTotal | 0.00    |
      |7 | accountInformation.asdtTotal | 4.76    |

      |7 | accountInformation.tvatTotal | 0.19    |
      |7 | accountInformation.tpsiTotal | 4.95    |
      |7 | accountInformation.vldtTotal | 0.00    |
      |7 | accountInformation.tpseTotal | 4.95    |

      |7 | accountInformation.retExtA   | 0.000   |
      |7 | accountInformation.retExtB   | 0.000   |
      |7 | accountInformation.retExtC   | 0.000   |

      |7 | accountInformation.invoiceCreditIndicator | false   |
      |7 | accountInformation.procCode  | false     |
    # ErrorMessage
      |7 | errorMessage.text            | <null>     |


  Scenario: 09 - Search by ID - EDI
    When I query GET endpoint "/invoice/edi/43"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id  | item                    | value           |
      | 43  | header.ediTransferDate  | <null>          |
      | 43  | header.weekClosed       | false           |
      | 43  | header.invoiceNumber    | 155045          |
      | 43  | header.invoiceType      | E               |
      | 43  | header.invoiceDate      | 2021-02-14      |
      | 43  | header.weekNumber       | <null>          |
      | 43  | header.yearNumber       | <null>          |
      | 43  | header.invoiceStatus    | A               |
      | 43  | header.description      | <null>          |
      | 43  | totals.zeroVatAmount    | 66.17           |
      | 43  | totals.specialVatAmount | 0.00            |
      | 43  | totals.stdVatAmount     | 0.00            |
      | 43  | totals.netAmount        | 66.17           |
      | 43  | totals.vatAmount        | 0.00            |
      | 43  | totals.totalAmount      | 66.17           |
    #Retailer
      |43 | retailer.code          | 50758            |
      |43 | retailer.name          | KNOCKNASHANE ENTERPRIZES LTD    |
      |43 | retailer.addressLine1  | COSTCUTTER - MOUTRAYS           |
      |43 | retailer.addressLine2  | 83 BELFAST ROAD  |
      |43 | retailer.addressLine3  | DOLLINGSTOWN     |
      |43 | retailer.addressLine4  | <null>           |
      |43 | retailer.postcode      | BT66 7JS         |
      |43 | retailer.vatNumber     | <null>           |
      |43 | retailer.supplierAccount | C11692         |
      |43 | retailer.orderNumber   | <null>           |
      |43 | retailer.orderDate     | <null>           |
      |43 | retailer.taxDate       | 2021-02-14       |
      |43 | retailer.deliveryDate  | <null>           |
      |43 | retailer.unitsDelivered| 36               |
      |43 | retailer.deliveryNumber| <null>           |
       #Supplier
      |43 | supplier.generation    | 79               |
      |43 | supplier.code          | WWIN             |
      |43 | supplier.name          | WOODWIN CATERING LTD T/A HOLMES DELI  |
      |43 | supplier.addressLine1  | 18 DIVINY DRIVE  |
      |43 | supplier.addressLine2  | CRAIGAVON        |
      |43 | supplier.addressLine3  | CO ARMAGH        |
      |43 | supplier.addressLine4  | N IRELAND        |
      |43 | supplier.postcode      | BT63 5WE         |
      |43 | supplier.partnerStatus | T                |
    #Lines
      | 43 | lines[0].productCode    | 7790           |
      | 43 | lines[0].unitWeight     | 1.000          |
      | 43 | lines[0].units          | 1.000          |
      | 43 | lines[0].unitCost       | 2.3000         |
      | 43 | lines[0].unitCostExVat  | 2.3000         |
      | 43 | lines[0].vatPercent     | 20.0000        |
      | 43 | lines[0].vatCode        | S              |
      | 43 | lines[0].discountAmount | 0.0000         |
      | 43 | lines[0].vatAmount      | 0.46           |
      | 43 | lines[0].totalAmount    | 2.76           |
      | 43 | lines[0].productDescription | CHOC BUTTER SHORTBREAD |
      | 43 | lines[0].measurementIndicator | EA       |
    #VatRates
      | 43 | vatRates[0].code             | R         |
      | 43 | vatRates[0].rate             | 5.00      |
      | 43 | vatRates[0].specialVatAmount | -20.0000  |
      | 43 | vatRates[0].vatPayable       | 1.2500    |
      | 43 | vatRates[0].description      | <null>    |

    #AccountInformation
      |43 | accountInformation.qydaZero  | 0.00    |
      |43 | accountInformation.qydaMix   | 0.00    |
      |43 | accountInformation.qydaStd   | 0.00    |

      |43 | accountInformation.vldaZero  | 0.00    |
      |43 | accountInformation.vldaMix   | 0.00    |
      |43 | accountInformation.vldaStd   | 0.00    |

      |43 | accountInformation.evlaZero  | 66.17   |
      |43 | accountInformation.evlaMix   | 0.00    |
      |43 | accountInformation.evlaStd   | 0.00    |

      |43 | accountInformation.asdaZero  | 66.17   |
      |43 | accountInformation.asdaMix   | 0.00    |
      |43 | accountInformation.asdaStd   | 0.00    |

      |43 | accountInformation.vataZero  | 0.00    |
      |43 | accountInformation.vataMix   | 0.00    |
      |43 | accountInformation.vataStd   | 0.00    |

      |43 | accountInformation.sedaZero  | 0.00    |
      |43 | accountInformation.sedaMix   | 0.00    |
      |43 | accountInformation.sedaStd   | 0.00    |

      |43 | accountInformation.apseZero  | 66.17   |
      |43 | accountInformation.apseMix   | 0.00    |
      |43 | accountInformation.apseStd   | 0.00    |

      |43 | accountInformation.lvlaZero  | 66.17   |
      |43 | accountInformation.lvlaMix   | 0.00    |
      |43 | accountInformation.lvlaStd   | 0.00    |

      |43 | accountInformation.nrilZero  | 21.00   |
      |43 | accountInformation.nrilMix   | 0.00    |
      |43 | accountInformation.nrilStd   | 0.00    |

      |43 | accountInformation.apsiZero  | 0.00    |
      |43 | accountInformation.apsiMix   | 0.00    |
      |43 | accountInformation.apsiStd   | 0.00    |

      |43 | accountInformation.aspiZero  | 0.00    |
      |43 | accountInformation.aspiMix   | 0.00    |
      |43 | accountInformation.aspiStd   | 0.00    |

      |43 | accountInformation.evltTotal | 66.17   |
      |43 | accountInformation.sedtTotal | 0.00    |
      |43 | accountInformation.asdtTotal | 66.17   |

      |43 | accountInformation.tvatTotal | 0.00    |
      |43 | accountInformation.tpsiTotal | 66.17   |
      |43 | accountInformation.vldtTotal | 0.00    |
      |43 | accountInformation.tpseTotal | 66.17   |

      |43 | accountInformation.retExtA   | 0.000   |
      |43 | accountInformation.retExtB   | 0.000   |
      |43 | accountInformation.retExtC   | 0.000   |

      |43 | accountInformation.invoiceCreditIndicator  | false   |
      |43 | accountInformation.procCode  | false   |
    # ErrorMessage
      |43 | errorMessage.text            |<null>   |

   #Data amended so all fields return a value (except those that should always be null)
  Scenario: 10 - Search by ID - EDI
    When I query GET endpoint "/invoice/edi/3"
    Then I should receive response status code 200
    And I verify the following values are present in the response:
    #Header
      | id  | item                    | value           |
      | 3   | header.ediTransferDate  | <null>          |
      | 3   | header.weekClosed       | false           |
      | 3   | header.invoiceNumber    | 3725073         |
      | 3   | header.invoiceType      | E               |
      | 3   | header.invoiceDate      | 2021-02-14      |
      | 3   | header.weekNumber       | <null>          |
      | 3   | header.yearNumber       | <null>          |
      | 3   | header.invoiceStatus    | P               |
      | 3   | header.description      | <null>          |
      | 3   | totals.zeroVatAmount    | -75.52          |
      | 3   | totals.specialVatAmount | 400.44          |
      | 3   | totals.stdVatAmount     | 500.55          |
      | 3   | totals.netAmount        | -33333.25       |
      | 3   | totals.vatAmount        | 6500.00         |
      | 3   | totals.totalAmount      | -77777.50       |
    #Retailer
      |3 | retailer.code          | 85012             |
      |3 | retailer.name          | CHARLES WALSH     |
      |3 | retailer.addressLine1  | SUPERSHOP         |
      |3 | retailer.addressLine2  | 33 GLEBETOWN DRIVE|
      |3 | retailer.addressLine3  | KILLOUGH ROAD     |
      |3 | retailer.addressLine4  | Sometown          |
      |3 | retailer.postcode      | BT30 6QD          |
      |3 | retailer.vatNumber     | V87456321         |
      |3 | retailer.supplierAccount | C34704          |
      |3 | retailer.orderNumber   | OrdNo 1232020     |
      |3 | retailer.orderDate     | 2020-12-11        |
      |3 | retailer.taxDate       | 2020-12-11        |
      |3 | retailer.deliveryDate  | 2020-12-11        |
      |3 | retailer.unitsDelivered| 10                |
      |3 | retailer.deliveryNumber| 1                 |
      #Supplier
      |3 | supplier.generation    | 7512              |
      |3 | supplier.code          | CAMB              |
      |3 | supplier.name          | COOP AMBIENT      |
      |3 | supplier.addressLine1  | COOPERATIVE GROUP FOOD   |
      |3 | supplier.addressLine2  | ANGEL AQUARE      |
      |3 | supplier.addressLine3  | MANCHESTER        |
      |3 | supplier.addressLine4  | <null>            |
      |3 | supplier.postcode      | M60 0AG           |
      |3 | supplier.partnerStatus | L                 |
    #Lines
      | 3 | lines[0].productCode    | COF00001        |
      | 3 | lines[0].unitWeight     | 1.000           |
      | 3 | lines[0].units          | 1.000           |
      | 3 | lines[0].unitCost       | 30.5400         |
      | 3 | lines[0].unitCostExVat  | 30.5400         |
      | 3 | lines[0].vatPercent     | 20.0000         |
      | 3 | lines[0].vatCode        | S               |
      | 3 | lines[0].discountAmount | 0.0000          |
      | 3 | lines[0].vatAmount      | 6.11            |
      | 3 | lines[0].totalAmount    | 36.65           |
      | 3 | lines[0].productDescription | WAREHOUSE SERVICE CHG |
      | 3 | lines[0].measurementIndicator | EA        |
    #VatRates
      | 3 | vatRates[0].code             | R        |
      | 3 | vatRates[0].rate             | 5.00     |
      | 3 | vatRates[0].specialVatAmount | -20.0000 |
      | 3 | vatRates[0].vatPayable       | -1.0000  |
      | 3 | vatRates[0].description      | <null>   |

    #AccountInformation
      |3 | accountInformation.qydaZero  | 1.11      |
      |3 | accountInformation.qydaMix   | -20.22    |
      |3 | accountInformation.qydaStd   | 300.33    |

      |3 | accountInformation.vldaZero  | 123.00    |
      |3 | accountInformation.vldaMix   | 456.00    |
      |3 | accountInformation.vldaStd   | 789.00    |

      |3 | accountInformation.evlaZero | -75.52     |
      |3 | accountInformation.evlaMix  | 400.44     |
      |3 | accountInformation.evlaStd  | 500.55     |

      |3 | accountInformation.asdaZero| 6000.00     |
      |3 | accountInformation.asdaMix | 7000.77     |
      |3 | accountInformation.asdaStd | -8000.88    |

      |3 | accountInformation.vataZero| -90123.99   |
      |3 | accountInformation.vataMix | 101200.11   |
      |3 | accountInformation.vataStd | 202300.22   |

      |3 | accountInformation.sedaZero| 90123.99    |
      |3 | accountInformation.sedaMix | -101200.11  |
      |3 | accountInformation.sedaStd | 202300.22   |

      |3 | accountInformation.apseZero| 90123.99    |
      |3 | accountInformation.apseMix | 101200.11   |
      |3 | accountInformation.apseStd | -202300.22  |

      |3 | accountInformation.lvlaZero| -90123.99   |
      |3 | accountInformation.lvlaMix | -101200.11  |
      |3 | accountInformation.lvlaStd | -202300.22  |

      |3 | accountInformation.nrilZero| 90123.99    |
      |3 | accountInformation.nrilMix | 90123.99    |
      |3 | accountInformation.nrilStd | 202300.22   |

      |3 | accountInformation.apsiZero| -202300.22  |
      |3 | accountInformation.apsiMix | -101200.11  |
      |3 | accountInformation.apsiStd | -202300.22  |

      |3 | accountInformation.aspiZero| 90123.99    |
      |3 | accountInformation.aspiMix | 90123.99    |
      |3 | accountInformation.aspiStd | 202300.22   |

      |3 | accountInformation.evltTotal | -33333.25   |
      |3 | accountInformation.sedtTotal | 4444.23     |
      |3 | accountInformation.asdtTotal | -55555.99   |

      |3 | accountInformation.tvatTotal | 6500.00     |
      |3 | accountInformation.tpsiTotal | -77777.50   |
      |3 | accountInformation.vldtTotal | 8888888.25  |
      |3 | accountInformation.tpseTotal | 9999999.12  |

      |3 | accountInformation.retExtA | 1.123       |
      |3 | accountInformation.retExtB | 20.123      |
      |3 | accountInformation.retExtC | 300.123     |

      #Cucumber framework does not handle boolean
      |3 | accountInformation.invoiceCreditIndicator  | false   |
      |3 | accountInformation.procCode                | true    |

    # ErrorMessage
      |3 | errorMessage.text | This is an error   |
