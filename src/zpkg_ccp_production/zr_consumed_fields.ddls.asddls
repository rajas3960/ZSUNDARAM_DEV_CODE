@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumed Fields Logic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CONSUMED_FIELDS
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
  as select from I_GoodsMovementCube as GM
{
  key GM.PostingDate,
  key GM.Material,
      cast( sum( GM.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14) ) as TOTALGDSMVTQTYINBASEUNIT
}
where
        GM.Plant              = $parameters.p_plant
  and   GM.PostingDate        >= $parameters.p_from_date
  and   GM.PostingDate        <= $parameters.p_to_date
  and(
        GM.ManufacturingOrder is not initial
    and GM.ManufacturingOrder is not null
  )
  and(
        GM.GoodsMovementType  = '261'
    or  GM.GoodsMovementType  = '262'
  )
  and(
        GM.Material           = '000000000150000023'
    or  GM.Material           = '000000000940000012'
    or  GM.Material           = '000000000100000063'
    or  GM.Material           = '000000000940000006'
  )

group by
  GM.PostingDate,
  GM.Material
