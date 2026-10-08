@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Charges'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_FREIGHT_CHRG 
  as select from ZR_PO_PRICINGELEMENT
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      sum(Amt) as Amt
}
where
     ConditionType = 'ZEF1'
  or ConditionType = 'ZEF2'
group by
  PurchaseOrder,
  PurchaseOrderItem
