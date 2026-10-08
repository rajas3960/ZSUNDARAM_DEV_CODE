@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for power generation'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_POWER_GENERATION
  as select from zdt_power_gen
  association to parent ZR_POWER_HEADER as _Head on $projection.Id = _Head.Id
{
  key id                  as Id,
  key item                as Item,
      referenceid         as Referenceid,
      turbine             as Turbine,
      zdt_power_gen.plant,
      description         as Description,
      material            as Material,
      materialdescription as Materialdescription,
      powergenerated      as Powergenerated,
      uom                 as Uom,
      storagelocation     as Storagelocation,
      movementtype        as Movementtype,
      _Head


}
