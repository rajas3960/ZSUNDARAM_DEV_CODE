@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption For Reservation Print Item'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_resvitems
  as projection on ZR_RESVITEMS
{

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Reservation Number'
  key Reservation,
      @EndUserText.label: 'Reservation Item'
  key ReservationItem,
      @EndUserText.label: 'RecordType'
  key RecordType,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Storage Location'
      StorageLocation,
      @EndUserText.label: 'Product'
      Product,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Valuation Type'
      ValuationType,
      @EndUserText.label: 'Goods Movement Type'
      GoodsMovementType,
      /* Associations */
      _Head : redirected to parent ZC_RESVTTPP
}
