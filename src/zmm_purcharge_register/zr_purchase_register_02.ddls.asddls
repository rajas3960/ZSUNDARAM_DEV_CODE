@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR_PURCHASE_REGISTER_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PURCHASE_REGISTER_02
  as select from ZR_PURCHASE_REGISTER_01
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key PricingDocument,
  key PricingDocumentItem,
  key PricingProcedureStep,
  key PricingProcedureCounter,
  BasePrice - Discount as BasePrice
}
