@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Item Print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcds_Res_Item4
  as select distinct from Zcds_Res_Item3
{
  key Reservation,
  key ReservationItem,
 Product,
      BaseUnit,
      Plant,
      case
      when InventoryValuationProcedure = 'S'
      then cast( reqty *  SP as abap.dec( 23, 2 ))
      when InventoryValuationProcedure = 'V'
      then cast( reqty *  mv as abap.dec( 23, 2 ))
      end as avgvalue
}
