@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Power Consumption'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_POWER_CONS
  as select from zdt_power_cons
  association to parent ZR_POWER_HEADER as _Head on $projection.Id = _Head.Id

{
  key id                  as Id,
  key item                as Item,
      referenceid         as Referenceid,
      plant               as Plant,
      plantname           as Plantname,
      material            as Material,
      materialdescription as Materialdescription,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      consumption         as Consumption,
      uom                 as Uom,
      productionorderno   as Productionorderno,
      costcenter          as Costcenter,
      costcentertext      as Costcentertext,
      storagelocation,
      _Head

}
