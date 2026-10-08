@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grid power consumed (CPP)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_GRIDPOWCONS_CPP
  with parameters
    p_from_date : datum,
    p_to_date   : datum
  as select from I_MfgOrderConfirmation
{
  key PostingDate,
  key Plant,
  key ManufacturingOrderType,
      cast( sum( OpConfirmedWorkQuantity5 ) as abap.dec(13,3) ) as OPCONFIRMEDWORKQUANTITY5
}
where
      PostingDate            >= $parameters.p_from_date
  and PostingDate            <= $parameters.p_to_date
  and ManufacturingOrderType = 'ZPP'
group by
  PostingDate,
  Plant,
  ManufacturingOrderType
