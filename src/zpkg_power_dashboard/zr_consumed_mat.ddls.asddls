@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Consumed Materials'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_CONSUMED_MAT
  as select from zdt_consumed_mat
  association to parent ZR_POWER_HEADER as _Head on $projection.Id = _Head.Id
{
  key id                  as Id,
  key item                as Item,
      referenceid         as Referenceid,
      turbine             as Turbine,
      description         as Description,
      material            as Material,
      materialdescription as Materialdescription,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      quantity            as Quantity,
      uom                 as Uom,
      storagelocation     as Storagelocation,
      _Head

}
