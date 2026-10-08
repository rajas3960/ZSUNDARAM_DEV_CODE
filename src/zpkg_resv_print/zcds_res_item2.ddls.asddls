@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Item Print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcds_Res_Item2
  as select distinct from Zcds_Res_Item1    as a
    inner join            I_MaterialStock_2 as b on  b.Plant    = a.Plant
                                                 and b.Material = a.Product
{
  key  a.Reservation,
  key  a.ReservationItem,
       a.Product,
       a.Plant,
       a.BaseUnit,
       @Semantics.quantity.unitOfMeasure: 'BaseUnit'
       sum(b.MatlWrhsStkQtyInMatlBaseUnit) as currstock
}
group by
  a.Reservation,
  a.ReservationItem,
  a.Product,
  a.Plant,
  a.BaseUnit
