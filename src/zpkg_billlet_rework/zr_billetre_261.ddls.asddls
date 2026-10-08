@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '261'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BILLETRE_261
  as select from zdt_billetre_261
  association to parent ZR_BILLETRE_HDR as _Head on $projection.Id = _Head.id
{
  key id                  as Id,
  key item                as Item,
      referenceid         as Referenceid,
      material            as Material,
      materialdescription as Materialdescription,
      batch               as Batch,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      quantity            as Quantity,
      uom                 as Uom,
      storagelocation     as Storagelocation,
      plant,
      piece,
      _Head // Make association public
}
