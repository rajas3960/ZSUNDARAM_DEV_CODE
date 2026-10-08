@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grid power consumed (SMS)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_GRIDPOWCONS_SMS
  with parameters
    p_from_date : datum,
    p_to_date   : datum
  as select from I_MfgOrderConfirmation
{
  key PostingDate,
  key case Plant
  when '2005'
  then '2006'
  when '1005'
  then '1006' end                                               as plant,
  key ManufacturingOrderType,
      cast( sum( OpConfirmedWorkQuantity2 ) as abap.dec(13,3) ) as OPCONFIRMEDWORKQUANTITY2
}
where
       PostingDate            >= $parameters.p_from_date
  and  PostingDate            <= $parameters.p_to_date
  and  ManufacturingOrderType = 'ZBIL'
  and(
       Plant                  = '2005'
    or Plant                  = '1005'
  )
group by
  PostingDate,
  Plant,
  ManufacturingOrderType
