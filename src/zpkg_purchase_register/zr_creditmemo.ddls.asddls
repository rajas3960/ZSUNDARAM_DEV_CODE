@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Credit Memo Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CREDITMEMO
  as select distinct from I_SupplierInvoiceAPI01        as h
    inner join            I_SuplrInvcItemPurOrdRefAPI01 as i on  i.SupplierInvoice = h.SupplierInvoice
                                                             and i.FiscalYear      = h.FiscalYear
{
  key i.SupplierInvoice                                                 as SupplierInvoice,
  key i.FiscalYear                                                      as FiscalYear,
  key i.SupplierInvoiceItem,
      i.PurchaseOrder                                                   as PurchaseOrder,
      i.PurchaseOrderItem                                               as PurchaseOrderItem,
      i.ReferenceDocument                                               as ReferenceDocument,
      i.ReferenceDocumentFiscalYear                                     as ReferenceDocumentFiscalYear,
      i.ReferenceDocumentItem                                           as ReferenceDocumentItem,
      h.DocumentDate,
      h.PostingDate,
      cast( -1 * abs(i.QuantityInPurchaseOrderUnit) as abap.dec(13,3) ) as QuantityInPurchaseOrderUnit,
      cast( -1 * abs(i.SupplierInvoiceItemAmount) as abap.dec(13,2))    as SupplierInvoiceItemAmount

}
where
      i.ReferenceDocument is not initial
  and i.ReferenceDocument is not null
