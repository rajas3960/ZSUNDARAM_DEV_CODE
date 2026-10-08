@AbapCatalog.sqlViewName: 'ZTYU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Sorted'
@Metadata.ignorePropagatedAnnotations: true
define view ZR_SORTEDRESV
  as select from ZR_RESERVATION_SORT
{
  reservation,
  reservationitem,
  product,
  baseunit,
  productdescription,
  plant,
  @Semantics.quantity.unitOfMeasure : 'baseunit'
  reqty,
  issloc,
  recloc,
  @Semantics.quantity.unitOfMeasure : 'baseunit'
  currstock,
  @Semantics.amount.currencyCode : 'waers'
  avgvalue,
  waers
}
