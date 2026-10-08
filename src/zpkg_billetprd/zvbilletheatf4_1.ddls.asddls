@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LHM Heat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVBILLETHEATF4_1

  as select from ZVBILLETHEATF4_4

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
      Stock

}

where
  Stock > 0
