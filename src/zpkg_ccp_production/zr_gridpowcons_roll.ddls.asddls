@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grid power consumed (ROLLING MILL)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_GRIDPOWCONS_ROLL
  with parameters
    p_from_date : datum,
    p_to_date   : datum
  as select from I_MfgOrderConfirmation
{
  key PostingDate,
  key case Plant
  when '1008'
  then '1006'
  when '2008'
  then '2006' end                                               as plant,
  key ManufacturingOrderType,
      cast( sum( OpConfirmedWorkQuantity2 ) as abap.dec(13,3) ) as OPCONFIRMEDWORKQUANTITY2
}
where
       PostingDate            >= $parameters.p_from_date
  and  PostingDate            <= $parameters.p_to_date
  and  ManufacturingOrderType = 'ZTMT'
  and(
       Plant                  = '1008'
    or Plant                  = '2008'
  )
group by
  PostingDate,
  Plant,
  ManufacturingOrderType
