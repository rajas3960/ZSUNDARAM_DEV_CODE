@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Freight Tax'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_PURCHASE_TAX
  as select from I_SuplrInvcItemPurOrdRefAPI01 as SIIP
left outer join I_OperationalAcctgDocItem as OADI on SIIP.SupplierInvoice = substring( OADI.OriginalReferenceDocument, 1, 10 )
                                                  and SIIP.SupplierInvoiceItem = OADI.TaxItemAcctgDocItemRef
                                                 // and OADI.TransactionTypeDetermination = 'JIC'
                                                  and (OADI.TransactionTypeDetermination = 'JII' or OADI.TransactionTypeDetermination = 'JIC')
                                                  //and OADI.TransactionTypeDetermination = 'JIS'  
//left outer join I_OperationalAcctgDocItem as OADI1 on SIIP.SupplierInvoice = substring( OADI1.OriginalReferenceDocument, 1, 10 )
//                                                  and SIIP.SupplierInvoiceItem = OADI1.TaxItemAcctgDocItemRef
//                                                  and OADI1.TransactionTypeDetermination = 'JIC' 
  
  {
     key SIIP.SupplierInvoice,
     key SIIP.SupplierInvoiceItem,
     key SIIP.FiscalYear,
     key SIIP.PurchaseOrder,
     key SIIP.PurchaseOrderItem,
         SIIP.ReferenceDocument,
         SIIP.ReferenceDocumentItem,
         SIIP.ReferenceDocumentFiscalYear,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         OADI.AmountInCompanyCodeCurrency,
//         case
//          when SIIP.SuplrInvcDeliveryCostCndnType <> 'ZEF2'or SIIP.SuplrInvcDeliveryCostCndnType <> 'ZEF2' or SIIP.SuplrInvcDeliveryCostCndnType is initial
//          then cast( 0 as abap.curr(15,2) )
//          else OADI.AmountInCompanyCodeCurrency
//          end as AmountInCompanyCodeCurrency,
          
         OADI.CompanyCodeCurrency,
         OADI.TransactionTypeDetermination,
         OADI.OriginalReferenceDocument,
         SIIP.DebitCreditCode,
         substring( OADI.OriginalReferenceDocument, 1, 10 ) as SUPINV
  
  
  }
  
  where SIIP.SuplrInvcDeliveryCostCndnType = 'ZEF2' or SIIP.SuplrInvcDeliveryCostCndnType = 'ZEF1'
 // or SIIP.SuplrInvcDeliveryCostCndnType = ''  // added 06-07-2026
  
  
  group by SIIP.SupplierInvoice,
    SIIP.SupplierInvoiceItem,
    SIIP.FiscalYear,
    SIIP.PurchaseOrder,
    SIIP.PurchaseOrderItem,
    SIIP.ReferenceDocument,
    SIIP.ReferenceDocumentItem,
    SIIP.ReferenceDocumentFiscalYear,
    OADI.AmountInCompanyCodeCurrency,
    OADI.CompanyCodeCurrency,
    OADI.TransactionTypeDetermination,
    OADI.OriginalReferenceDocument,
    SIIP.DebitCreditCode,
    SIIP.SuplrInvcDeliveryCostCndnType
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

//    left outer join I_JournalEntryItem as JIC
//      on  JIC.CompanyCode          = BASE.CompanyCode
//      and JIC.AccountingDocument   = BASE.AccountingDocument
//      and JIC.FiscalYear           = BASE.FiscalYear
//      and JIC.TransactionTypeDetermination = 'JIC'
//
//    left outer join I_JournalEntryItem as JIS
//      on  JIS.CompanyCode          = BASE.CompanyCode
//      and JIS.AccountingDocument   = BASE.AccountingDocument
//      and JIS.FiscalYear           = BASE.FiscalYear
//      and JIS.TransactionTypeDetermination = 'JIS'
//
//    left outer join I_JournalEntryItem as JII
//      on  JII.CompanyCode          = BASE.CompanyCode
//      and JII.AccountingDocument   = BASE.AccountingDocument
//      and JII.FiscalYear           = BASE.FiscalYear
//      and JII.TransactionTypeDetermination = 'JII'
//
//{
//    key BASE.CompanyCode,
//    key BASE.AccountingDocument,
//    key BASE.FiscalYear,
//    key BASE.PurchasingDocument,
//        BASE.ReferenceDocument,
//
//    cast( JIC.AmountInCompanyCodeCurrency as abap.dec(15,2) ) as CGSTAmt,
//    cast( JIS.AmountInCompanyCodeCurrency as abap.dec(15,2) ) as SGSTAmt,
//    cast( JII.AmountInCompanyCodeCurrency as abap.dec(15,2) ) as IGSTAmt
//}
//where BASE.Ledger = '0L'
//and BASE.PurchasingDocument <> ''
