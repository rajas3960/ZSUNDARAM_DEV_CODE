@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Power Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_POWER_CONS
  as projection on ZR_POWER_CONS
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference Id'
      Referenceid,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'PlantName'
      Plantname,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Description'
      Materialdescription,
      @EndUserText.label: 'Consumption'
      @Semantics.quantity.unitOfMeasure : 'Uom'
      Consumption,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Production Order No'
      Productionorderno,
      @EndUserText.label: 'Cost Center'
      Costcenter,
      @EndUserText.label: 'Cost Center Text'
      Costcentertext,
      @EndUserText.label: 'Storage Location'
      storagelocation,
      /* Associations */
      _Head : redirected to parent ZC_POWER_HEADER

}
