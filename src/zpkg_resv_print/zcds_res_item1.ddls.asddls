@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Item'
define view entity Zcds_Res_Item1
  as select distinct from I_ReservationDocumentItem as a
    left outer join       I_ProductDescription      as b on  b.Product  = a.Product
                                                         and b.Language = $session.system_language
{
  key  a.Reservation,
  key  a.ReservationItem,
  key  a.Product,
       b.ProductDescription,
       a.BaseUnit,
       a.Plant,
       a.ResvnItmRequiredQtyInBaseUnit as reqty,
       a.StorageLocation               as issloc,
       a.IssuingOrReceivingStorageLoc  as recloc
}
