@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unloading Charges'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_UNLOADING_CHRG 
  as select from ZR_PO_PRICINGELEMENT
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      sum(Amt) as Amt
}
where
     ConditionType = 'ZUC1'
  or ConditionType = 'ZUC2'
group by
  PurchaseOrder,
  PurchaseOrderItem
