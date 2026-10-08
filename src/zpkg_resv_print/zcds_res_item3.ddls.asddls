@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Item Print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcds_Res_Item3
  as select distinct from Zcds_Res_Item1          as a
    inner join            I_ProductValuationBasic as b on  b.ValuationArea = a.Plant
                                                       and b.Product       = a.Product
{
  key a.Reservation,
  key a.ReservationItem,
   a.Product,
      a.BaseUnit,
      a.Plant,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.reqty,
      b.InventoryValuationProcedure,
      cast(b.MovingAveragePrice as abap.dec( 23, 2 )) as mv,
      cast(b.StandardPrice as abap.dec( 23, 2 ))      as SP
}
