@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Approval Item'
define view entity ZR_RESVITEMS  as select from I_ReservationDocumentItem
  association to parent ZR_RESVTTPH as _Head on $projection.Reservation = _Head.Reservation
{

  key I_ReservationDocumentItem.Reservation,
  key I_ReservationDocumentItem.ReservationItem,
  key I_ReservationDocumentItem.RecordType,
      I_ReservationDocumentItem.Plant,
      I_ReservationDocumentItem.StorageLocation,
      I_ReservationDocumentItem.Product,
      I_ReservationDocumentItem.Batch,
      I_ReservationDocumentItem.ValuationType,
      I_ReservationDocumentItem.SpecialStockIdfgWBSElement,
      I_ReservationDocumentItem.GoodsMovementType,

      _Head
}
