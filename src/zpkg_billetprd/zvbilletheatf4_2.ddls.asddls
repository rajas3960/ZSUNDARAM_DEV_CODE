@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Heat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVBILLETHEATF4_2
  as select from I_ManufacturingOrder
{
  key ManufacturingOrder,
      Product,
      dats_add_days( CreationDate, 30, 'INITIAL' )  as FutureDate,
      dats_add_days( CreationDate, -30, 'INITIAL' ) as PrevDate

}

where
  ManufacturingOrderType = 'ZLHM'
