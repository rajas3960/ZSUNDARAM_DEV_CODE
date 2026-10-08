@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CSQ Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_CSQ_ITEM
  as select distinct from I_RfqItem_Api01               as a
    inner join            I_SupplierQuotationItem_Api01 as c on  a.RequestForQuotation     = c.RequestForQuotation
                                                             and a.RequestForQuotationItem = c.RequestForQuotationItem
    inner join            I_SupplierQuotation_Api01     as d on d.SupplierQuotation = c.SupplierQuotation
    inner join            I_Requestforquotation_Api01   as b on a.RequestForQuotation = b.RequestForQuotation
    left outer join       I_Supplier                    as e on d.Supplier = e.Supplier

{
  key a.RequestForQuotation,
  key a.RequestForQuotationItem,
  key c.SupplierQuotation,
  key c.SupplierQuotationItem,

      a.Material,
      a.PurchasingDocumentItemText,
      a.OrderQuantityUnit,
      b.PurchasingGroup,
      c.PurgDocPriceDate,
      b.DocumentCurrency as curr,
      d.IncotermsClassification,
      d.IncotermsLocation1,
      b.PaymentTerms,
      a.Plant,
      d.Supplier,
      e.SupplierName,
      @Semantics.amount.currencyCode: 'curr'
      c.NetAmount,
      c.OrderPriceUnit

}
