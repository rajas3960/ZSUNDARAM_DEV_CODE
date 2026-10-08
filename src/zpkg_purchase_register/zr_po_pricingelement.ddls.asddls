@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO item Pricing element Condition Amt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PO_PRICINGELEMENT
  as select from I_PurOrdItmPricingElementAPI01
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key ConditionType,
      cast( sum( ConditionAmount ) as abap.dec(16,2) ) as Amt
}

group by
  PurchaseOrder,
  PurchaseOrderItem,
  ConditionType
