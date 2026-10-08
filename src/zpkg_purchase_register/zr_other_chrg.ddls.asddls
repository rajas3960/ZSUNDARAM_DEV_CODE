@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Other Charges'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_OTHER_CHRG 
  as select from ZR_PO_PRICINGELEMENT
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      sum(Amt) as Amt
}
where
     ConditionType = 'ZOT1'
  or ConditionType = 'ZOT2'
  or ConditionType = 'ZOT3'
group by
  PurchaseOrder,
  PurchaseOrderItem
