@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption ~ Consumed Material'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_CONSUMED_MAT
  as projection on ZR_CONSUMED_MAT
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference Id'
      Referenceid,
      @EndUserText.label: 'Turbine'
      Turbine,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Description'
      Materialdescription,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure : 'Uom'
      Quantity,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Storage Location'
      Storagelocation,
      /* Associations */
      _Head : redirected to parent ZC_POWER_HEADER

}
