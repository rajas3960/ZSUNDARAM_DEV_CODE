@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Captive power sms'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CAPTIVEPOWERSMS
  with parameters
    p_from_date : datum,
    p_to_date   : datum
  as select from I_GoodsMovementCube
{
  key PostingDate,
  key case Plant
  when '2005'
  then '2006'
  when '1005'
  then '1006' end                   as plant,
  key MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(TotalGdsMvtQtyInBaseUnit) as TotalGdsMvtQtyInBaseUnit

}
where
       PostingDate        >= $parameters.p_from_date
  and  PostingDate        <= $parameters.p_to_date
  and  MaterialBaseUnit   = 'MWH'
  and(
       Plant              = '2005'
    or Plant              = '1005'
  )
  and  ManufacturingOrder is not initial
  and(
       GoodsMovementType  = '261'
    or GoodsMovementType  = '262'
  )
group by
  PostingDate,
  Plant,
  MaterialBaseUnit
