@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Loading Charges'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_LOADING_CHRG 
  as select from ZR_PO_PRICINGELEMENT
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      sum(Amt) as Amt
}
where
     ConditionType = 'ZLC1'
  or ConditionType = 'ZLC2'
group by
  PurchaseOrder,
  PurchaseOrderItem
