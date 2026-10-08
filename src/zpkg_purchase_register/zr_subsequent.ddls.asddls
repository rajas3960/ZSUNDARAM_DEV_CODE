@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for subsequent credit & Debit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZR_SUBSEQUENT
  as select distinct from I_SupplierInvoiceAPI01        as h
    inner join            I_SuplrInvcItemPurOrdRefAPI01 as i on  i.SupplierInvoice = h.SupplierInvoice
                                                             and i.FiscalYear      = h.FiscalYear
{
  key i.SupplierInvoice             as SupplierInvoice,
  key i.FiscalYear                  as FiscalYear,
  key i.SupplierInvoiceItem,
      i.DebitCreditCode,
      i.PurchaseOrder               as PurchaseOrder,
      i.PurchaseOrderItem           as PurchaseOrderItem,
      i.ReferenceDocument           as ReferenceDocument,
      i.ReferenceDocumentFiscalYear as ReferenceDocumentFiscalYear,
      i.ReferenceDocumentItem       as ReferenceDocumentItem,
      h.DocumentDate,
      h.PostingDate,

      case when i.DebitCreditCode = 'S'
      then cast(  abs(i.QuantityInPurchaseOrderUnit) as abap.dec(13,3) )
      when i.DebitCreditCode = 'H'
      then cast(  abs(i.QuantityInPurchaseOrderUnit) as abap.dec(13,3) )
      else cast(  i.QuantityInPurchaseOrderUnit as abap.dec(13,3) )
      end                           as QuantityInPurchaseOrderUnit,

      case when i.DebitCreditCode = 'S'
      then cast(  abs(i.SupplierInvoiceItemAmount) as abap.dec(13,2) )
      when i.DebitCreditCode = 'H'
      then cast(  abs(i.SupplierInvoiceItemAmount) as abap.dec(13,2) )
      else cast(  i.SupplierInvoiceItemAmount as abap.dec(13,2) )
      end                           as SupplierInvoiceItemAmount


}
where
     i.ReferenceDocument       is not initial
   and i.ReferenceDocument       is not null
   and  i.IsSubsequentDebitCredit = 'X'
