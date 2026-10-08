@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Head Print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_RES_FINAL_N
  with parameters
    client : abap.clnt
  as select from ZCDS_RES_FINAL
{
  key Reservation,
  key resitem,
      ReservationItem,
      Product,
      ProductDescription,
      BaseUnit,
      plant,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      reqty,
      issloc,
      recloc,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      currstock,
      avgvalue
}
