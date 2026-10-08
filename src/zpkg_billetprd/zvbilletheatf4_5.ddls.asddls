@AbapCatalog.sqlViewName: 'ZVHEATLHM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LHM Heat'
@Metadata.ignorePropagatedAnnotations: true
define view ZVBILLETHEATF4_5
  as select from ZVBILLETHEATF4_1
{
  key Material,
  key Plant            as plant,
  key StorageLocation,
  key HeatNumber       as heatnumber,
      ProductName,
      MaterialBaseUnit as UOM,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Stock
}
