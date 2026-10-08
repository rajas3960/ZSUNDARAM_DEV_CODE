@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Input Register'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZR_INPUTREGN_3
  as select from    ZR_INPUTREGN_2              as a

    left outer join ZR_INPUTREGN_2              as h   on  a.CompanyCode                =  h.CompanyCode
                                                       and a.AccountingDocument         =  h.AccountingDocument
                                                       and a.FiscalYear                 =  h.FiscalYear
                                                       and (
                                                          h.IN_GSTPartner               <> ''
                                                          or h.Housebankname            <> ''
                                                        )
                                                       and h.AccountingDocumentItemType =  ''

    left outer join I_PurchaseOrderItemAPI01    as b   on  a.PurchasingDocument     = b.PurchaseOrder
                                                       and a.PurchasingDocumentItem = b.PurchaseOrderItem

    left outer join I_PurchaseOrderAPI01        as c   on a.PurchasingDocument = c.PurchaseOrder

    left outer join I_GLAccountTextRawData      as d   on  a.GLAccount       = d.GLAccount
                                                       and d.ChartOfAccounts = 'YCOA'
                                                       and d.Language        = 'E'


    left outer join I_Supplier                  as e   on e.Supplier = h.IN_GSTPartner

    left outer join I_RegionText                as f   on  e.Country  = f.Country
                                                       and e.Region   = f.Region
                                                       and f.Language = 'E'

    left outer join I_ProductText               as g   on  a.Product  = g.Product
                                                       and g.Language = 'E'

    left outer join I_TaxCodeText               as i   on  a.TaxCode                 = i.TaxCode
                                                       and i.TaxCalculationProcedure = '0TXIN'
                                                       and i.Language                = 'E'

    left outer join ZR_INPUTREGN_4              as j   on  a.CompanyCode                  = j.CompanyCode
                                                       and a.AccountingDocument           = j.AccountingDocument
                                                       and a.FiscalYear                   = j.FiscalYear
                                                       and a.TaxItemAcctgDocItemRef       = j.TaxItemAcctgDocItemRef
                                                       and j.TransactionTypeDetermination = 'JIS'

    left outer join ZR_INPUTREGN_4              as k   on  a.CompanyCode                  = k.CompanyCode
                                                       and a.AccountingDocument           = k.AccountingDocument
                                                       and a.FiscalYear                   = k.FiscalYear
                                                       and a.TaxItemAcctgDocItemRef       = k.TaxItemAcctgDocItemRef
                                                       and k.TransactionTypeDetermination = 'JIC'

    left outer join ZR_INPUTREGN_4              as l   on  a.CompanyCode                  = l.CompanyCode
                                                       and a.AccountingDocument           = l.AccountingDocument
                                                       and a.FiscalYear                   = l.FiscalYear
                                                       and a.TaxItemAcctgDocItemRef       = l.TaxItemAcctgDocItemRef
                                                       and l.TransactionTypeDetermination = 'JII'

    left outer join I_IN_BusinessPlaceTaxDetail as m   on  a.CompanyCode   = m.CompanyCode
                                                       and a.BusinessPlace = m.BusinessPlace

    left outer join I_SupplierInvoiceAPI01      as inv on  a.Invoiceno  = inv.SupplierInvoice
                                                       and a.FiscalYear = inv.FiscalYear

    left outer join I_Supplier                  as sup on sup.Supplier = inv.InvoicingParty

{
  key a.CompanyCode,
  key a.AccountingDocumentType,
  key a.FiscalYear,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.AccountingDocumentItemType,
  key a.GLAccount,
      sup.Supplier as IN_GSTPartner,
      a.IN_HSNOrSACCode,
      a.Material,
      h.IN_GSTPlaceOfSupply,
      a.Plant,
      a.Product,
      a.ProfitCenter,
      a.PurchasingDocument,
      a.PurchasingDocumentItem,
      a.TaxItemAcctgDocItemRef,
      a.TransactionCurrency,
      a.CompanyCodeCurrency,
      a.TaxCode,
      i.TaxCodeName,

      // $@
      cast( division( a.AmountInTransactionCurrency, j.TaxBaseAmountInCoCodeCrcy, 5 ) as abap.dec(10,5) ) as SGSTRatio,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      // case when a.taxchar1 <> 'R' then case when a.TransactionTypeDetermination <> 'BSX' then j.taxamt else null end
      //     else null end                                      as SGST,

      case when a.taxchar1 <> 'R' then j.taxamt else null end                                             as SGST,
      // $@

      // $@
      cast( division( a.AmountInTransactionCurrency, k.TaxBaseAmountInCoCodeCrcy, 5 ) as abap.dec(10,5) ) as CGSTRatio,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      // case when a.taxchar1 <> 'R' then case when a.TransactionTypeDetermination <> 'BSX' then k.taxamt else null end // then k.taxamt
      //    else null end                                           as CGST,
      case when a.taxchar1 <> 'R' then k.taxamt else null end                                             as CGST,
      // $@

      // $@
      cast( division( a.AmountInTransactionCurrency, l.TaxBaseAmountInCoCodeCrcy, 5 ) as abap.dec(10,5) ) as IGSTRatio,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      // case when a.taxchar1 <> 'R' then case when a.TransactionTypeDetermination <> 'BSX' then l.taxamt else null end // then l.taxamt
      //    else null end                                       as IGST,
      case when a.taxchar1 <> 'R' then l.taxamt else null end                                             as IGST,
      // $@

      case a.taxchar1 when 'R' then 'YES' else 'NO' end                                                   as Rcmstat,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when a.taxchar1 = 'R' then j.taxamt  else null end                                             as RCMSGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when a.taxchar1 = 'R' then k.taxamt  else null end                                             as RCMCGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when a.taxchar1 = 'R' then l.taxamt  else null end                                             as RCMIGST,

      a.TransactionTypeDetermination,
      a.ValuationArea,
      a.DebitCreditCode,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case a.DebitCreditCode
      //          when 'H' then a.AmountInTransactionCurrency * -1
          when 'H' then a.AmountInTransactionCurrency
          else a.AmountInTransactionCurrency end                                                          as AmountInTransactionCurrency,

      a.Invoiceno,
      a.Invoicenoyr,
      a.DocumentDate,
      a.creationdate,
      a.DocumentReferenceID,

      case b.ProductType when '2' then 'SERVICE'
                         when '1' then 'PURCHASE'
                         else 'OTHER' end                                                                 as ProductType,

      c.PurchaseOrderDate,
      d.GLAccountLongName,

      //      e.SupplierName,
      case when (a.AccountingDocumentType = 'SA' and h.Housebankname is not null)
              then  h.Housebankname else  sup.SupplierName end                                            as SupplierName,

      //      e.TaxNumber3,
      sup.TaxNumber3,
      sup.Region as RegionName,
      g.ProductName,
      a.BusinessPlace,
      m.BusinessPlaceDescription,
      m.IN_GSTIdentificationNumber
}

where
      a.AccountingDocumentItemType <> 'T'
  and a.TaxItemAcctgDocItemRef     <> '000000'
