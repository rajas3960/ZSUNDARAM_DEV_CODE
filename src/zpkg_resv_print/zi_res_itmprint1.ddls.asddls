@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'item print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RES_ITMPRINT1
  as select from    I_ReservationDocumentItem as a
    left outer join I_ProductDescription      as b on a.Product = b.Product
{
  key a.Reservation,
  key a.ReservationItem,
      a.Product,
      b.ProductDescription,
      a.EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      a.ResvnItmRequiredQtyInEntryUnit,
      a.GoodsRecipientName,
      a.ReservationItemText


}
