@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Production - 101'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BILLET_101 

as select from zdt_billet_101

  association to parent ZR_BILLET_HDR as _Head on $projection.id = _Head.id
{
    key zdt_billet_101.id,
    key zdt_billet_101.item,
    zdt_billet_101.referenceid,
    zdt_billet_101.heatnumber,
    zdt_billet_101.lengthmtr,
    zdt_billet_101.batch,
    zdt_billet_101.piece,
    zdt_billet_101.material,
    zdt_billet_101.plant,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    zdt_billet_101.quantity,
    zdt_billet_101.uom,
    zdt_billet_101.storagelocation,    
    _Head
}
