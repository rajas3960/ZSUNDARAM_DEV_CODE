@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Production - 531'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZR_BILLET_531

  as select from zdt_billet_531

  association to parent ZR_BILLET_HDR as _Head on $projection.id = _Head.id
{
  key zdt_billet_531.id,
  key zdt_billet_531.item,
      zdt_billet_531.referenceid,
      zdt_billet_531.heatnumber,
      zdt_billet_531.material,
      zdt_billet_531.materialdescription,
      zdt_billet_531.plant,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_531.quantity,
      zdt_billet_531.uom,
      zdt_billet_531.storagelocation,
      _Head
}
