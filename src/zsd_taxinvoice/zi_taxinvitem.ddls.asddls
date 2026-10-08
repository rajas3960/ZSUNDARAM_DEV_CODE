@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Tax Invoice Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_TAXINVITEM
  as select from ZR_ITEMLINE_FINAL as a
  association to parent ZI_TAXINVHDR as _Head on $projection.BillingDocument = _Head.SerialInvoiceNo
                                              
                    
  //     and $projection.BillingDocumentItem = _Head.BillingDocumentItem



{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.BillingDocumentItemText  as DescOfGoods,
      a.hsncode                  as HSNCode,
      //      a.OrderQuantityUnit,
      //      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      //      a.OrderQuantity           as OrderQuantity,
      //      a.ItemWeightUnit          as OrderUnit,
      a.BillingQuantityUnit      as OrderUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      a.BillingQuantity          as InvoiceQuantity,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.NetAmount                as RatePerUnit,
      a.HandlingUnitQuantityUnit as PackingUnit,
      @Semantics.quantity.unitOfMeasure: 'PackingUnit'
      a.HandlingUnitQtyMax       as PackingQuantityMax,
      @Semantics.quantity.unitOfMeasure: 'PackingUnit'
      a.HandlingUnitQtyMin       as PackingQuantityMin,
      _Head

}
//where a.HandlingUnitQtyMax is not initial
