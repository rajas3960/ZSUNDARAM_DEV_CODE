@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Production - 261'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZR_BILLET_261

  as select from zdt_billet_261

  association to parent ZR_BILLET_HDR as _Head on $projection.id = _Head.id
{

  key zdt_billet_261.id,
  key zdt_billet_261.item,
      zdt_billet_261.referenceid,
      zdt_billet_261.heatnumber,
      zdt_billet_261.material,
      zdt_billet_261.materialdescription,
      zdt_billet_261.plant,
      zdt_billet_261.batch,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_261.quantity,
      zdt_billet_261.uom,
      zdt_billet_261.storagelocation,      
      _Head

}
