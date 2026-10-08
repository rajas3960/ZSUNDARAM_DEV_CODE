@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LHM Heat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVBILREF4
  as select from ZVBREF5
{

  key Material,
  key Plant      as plant,
  key StorageLocation,
      @EndUserText.label: 'Billet Batch Number'
  key HeatNumber as Heatnumber,
      @EndUserText.label: 'Product Name'
      ProductName,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'Stock'
      Stock
}

where
  Stock > 0
