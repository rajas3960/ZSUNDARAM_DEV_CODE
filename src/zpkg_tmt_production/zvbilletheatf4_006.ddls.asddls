@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LHM Heat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVBILLETHEATF4_006

  as select from ZVBILLETHEATF4_005

{

  key Material,
  key Plant,
  key StorageLocation,
      @EndUserText.label: 'Heat Material'
  key HeatNumber as Batchno,
      @EndUserText.label: 'Product Name'
      ProductName,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'Stock'
      Stock

}

where
      Stock > 0
  and Plant = '2008'
