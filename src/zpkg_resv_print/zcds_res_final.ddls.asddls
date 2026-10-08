@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'final Item CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_RES_FINAL
  as select distinct from Zcds_Res_Item1 as a
    left outer join            Zcds_Res_Item2 as b on  b.Reservation     = a.Reservation
                                              and b.ReservationItem = a.ReservationItem
                                              and b.Plant           = a.Plant
                                              and b.Product         = a.Product
    left outer join            Zcds_Res_Item4 as c on  c.Reservation     = a.Reservation
                                              and c.ReservationItem = a.ReservationItem
                                              and c.Plant           = a.Plant
                                              and c.Product         = a.Product

{
  
  key a.Reservation                    as Reservation,
  key a.ReservationItem                as resitem,
      ltrim( a.ReservationItem , '0' ) as ReservationItem,
      a.Product                        as Product,
      a.ProductDescription,
      a.BaseUnit,
      a.Plant                          as plant,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.reqty,
      a.issloc,
      a.recloc,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      b.currstock,
      c.avgvalue
}
