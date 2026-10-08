@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Heat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVBILLETHEATF4_005
  as select from ZVBILLETHEATF4_004
{

  key Material,
  key Plant,
  key StorageLocation,
      @EndUserText.label: 'Heat Material'
  key HeatNumber,
      @EndUserText.label: 'Product Name'
      ProductName,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'Stock'
      cast( IncreaseQty - DecreaseQty as abap.dec(13,3) ) as Stock

}
