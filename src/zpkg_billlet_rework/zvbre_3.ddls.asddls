@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Heat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVBRE_3
  as select distinct from ZVBREBATCH01
{
  key Product
}

where
      PrevDate   <= $session.system_date
  and FutureDate >= $session.system_date
