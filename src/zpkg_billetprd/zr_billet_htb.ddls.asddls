@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Production - Heat Balancing'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BILLET_HTB

  as select from zdt_billet_htb

  association to parent ZR_BILLET_HDR as _Head on $projection.id = _Head.id
{
  key zdt_billet_htb.id,
  key zdt_billet_htb.item,
      zdt_billet_htb.referenceid,
      zdt_billet_htb.heatnumber,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_htb.heatquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_htb.billetquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_htb.byproductquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_htb.balancequantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_htb.yield,
      zdt_billet_htb.uom as Uom,
      _Head
}
