@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing Charges'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PACKING_CHRG
  as select from ZR_PO_PRICINGELEMENT
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      sum(Amt) as Amt
}
where
     ConditionType = 'ZPF1'
  or ConditionType = 'ZPF2'
  or ConditionType = 'ZPF3'
group by
  PurchaseOrder,
  PurchaseOrderItem
