@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Captive power DRI'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_Auxiliarycons
  with parameters
    p_from_date : datum,
    p_to_date   : datum
  as select from I_GoodsMovementCube
{
  key PostingDate,
  key  Plant,
  key MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(TotalGdsMvtQtyInBaseUnit) as TotalGdsMvtQtyInBaseUnit

}
where
       PostingDate        >= $parameters.p_from_date
  and  PostingDate        <= $parameters.p_to_date
  and  MaterialBaseUnit   = 'MWH'
  and  ManufacturingOrder is not initial
  and(
       GoodsMovementType  = '261'
    or GoodsMovementType  = '262'
  )
group by
  PostingDate,
  Plant,
  MaterialBaseUnit
