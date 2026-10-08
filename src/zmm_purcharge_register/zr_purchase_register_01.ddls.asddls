@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR_PURCHASE_REGISTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PURCHASE_REGISTER_01

  as select from I_PurOrdItmPricingElementAPI01 as a

{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
  key a.PricingDocument,
  key a.PricingDocumentItem,
  key a.PricingProcedureStep,
  key a.PricingProcedureCounter,
  sum( case when a.ConditionType = 'PMP0' then cast( a.ConditionRateValue as abap.dec(15,2) ) else 0 end )                                                         as BasePrice,
  sum( case when a.ConditionType = 'ZABD' or a.ConditionType = 'ZADV' or a.ConditionType = 'ZDPQ' then cast( a.ConditionRateValue as abap.dec(15,2) ) else 0 end ) as Discount

}
where
     a.ConditionType = 'PMP0'
  or a.ConditionType = 'ZABD'
  or a.ConditionType = 'ZADV'
  or a.ConditionType = 'ZDPQ'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.PricingDocument,
  a.PricingDocumentItem,
  a.PricingProcedureStep,
  a.PricingProcedureCounter
