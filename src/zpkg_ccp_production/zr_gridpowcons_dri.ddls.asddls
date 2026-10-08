@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grid power consumed (DRI)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_GRIDPOWCONS_DRI
  with parameters
    p_from_date : datum,
    p_to_date   : datum
  as select from I_MfgOrderConfirmation
{
  key PostingDate,
  key case Plant
  when '1004'
  then '1006'
  when '2004'
  then '2006' end                                               as plant,
  key ManufacturingOrderType,
      cast( sum( OpConfirmedWorkQuantity6 ) as abap.dec(13,3) ) as OPCONFIRMEDWORKQUANTITY2
}
where
       PostingDate            >= $parameters.p_from_date
  and  PostingDate            <= $parameters.p_to_date
  and  ManufacturingOrderType = 'ZDRI'
  and(
       Plant                  = '1004'
    or Plant                  = '2004'
  )
group by
  PostingDate,
  Plant,
  ManufacturingOrderType
