@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR_PURCHASE_REGISTER_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PURCHASE_REGISTER_2
  as select from ZR_PURCHASE_REGISTER_1
{
  PurchaseOrder,
  PurchaseOrderItem,
  BasePrice - Discount as BasePrice
}
