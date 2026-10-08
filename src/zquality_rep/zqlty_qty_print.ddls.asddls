@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View to calculate total quantity against Delivery No'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZQLTY_QTY_PRINT
  as select from I_DeliveryDocumentItem
{
  key DeliveryDocument,

      sum(cast( OriginalDeliveryQuantity as abap.dec(21,2))) as delqty
}
group by
  DeliveryDocument
