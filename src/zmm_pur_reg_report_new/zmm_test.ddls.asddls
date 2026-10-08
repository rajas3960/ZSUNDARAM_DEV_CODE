@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_TEST 
//as select distinct from I_SupplierInvoiceAPI01        as h
//    inner join            I_SuplrInvcItemPurOrdRefAPI01 as i on  i.SupplierInvoice = h.SupplierInvoice
//                                                             and i.FiscalYear      = h.FiscalYear
//{
//  key i.SupplierInvoice             as SupplierInvoice,
//  key i.FiscalYear                  as FiscalYear,
//  key i.SupplierInvoiceItem,
//      i.DebitCreditCode,
//      i.PurchaseOrder               as PurchaseOrder,
//      i.PurchaseOrderItem           as PurchaseOrderItem,
//      i.ReferenceDocument           as ReferenceDocument,
//      i.ReferenceDocumentFiscalYear as ReferenceDocumentFiscalYear,
//      i.ReferenceDocumentItem       as ReferenceDocumentItem,
//      h.DocumentDate,
//      h.PostingDate,
//
//      case when i.DebitCreditCode = 'S'
//      then cast(  abs(i.QuantityInPurchaseOrderUnit) as abap.dec(13,3) )
//      when i.DebitCreditCode = 'H'
//      then cast(  abs(i.QuantityInPurchaseOrderUnit) as abap.dec(13,3) )
//      else cast(  i.QuantityInPurchaseOrderUnit as abap.dec(13,3) )
//      end                           as QuantityInPurchaseOrderUnit,
//
//      case when i.DebitCreditCode = 'S'
//      then cast(  abs(i.SupplierInvoiceItemAmount) as abap.dec(13,2) )
//      when i.DebitCreditCode = 'H'
//      then cast(  abs(i.SupplierInvoiceItemAmount) as abap.dec(13,2) )
//      else cast(  i.SupplierInvoiceItemAmount as abap.dec(13,2) )
//      end                           as SupplierInvoiceItemAmount
//
//
//}
//where
//     i.ReferenceDocument       is not initial
//   and i.ReferenceDocument       is not null
//   and  i.IsSubsequentDebitCredit = 'X'
 



as select from I_JournalEntryItem as JEI

{
    key JEI.AccountingDocument,
    key JEI.FiscalYear,
    key JEI.CompanyCode,
        JEI.ReferenceDocument,
        JEI.ReferenceDocumentItem,
        JEI.PurchasingDocument,
        JEI.PurchasingDocumentItem,
        JEI.ReversalReferenceDocument,
        JEI.TransactionTypeDetermination,
        JEI.IsReversal
        
   

}
where JEI.Ledger = '0L'
  and JEI.TransactionTypeDetermination = 'WRX'
  and JEI.ReversalReferenceDocument <> ''














