@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption ~ power Generation'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_POWER_GENERATION
  as projection on ZR_POWER_GENERATION
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference Id'
      Referenceid,
      @EndUserText.label: 'Turbine'
      Turbine,
      @EndUserText.label: 'Plant'
      plant,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Description'
      Materialdescription,
      @EndUserText.label: 'Power Generated'
      Powergenerated,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Storage Location'
      Storagelocation,
      @EndUserText.label: 'Movement Type'
      Movementtype,
      /* Associations */
      _Head : redirected to parent ZC_POWER_HEADER

}
