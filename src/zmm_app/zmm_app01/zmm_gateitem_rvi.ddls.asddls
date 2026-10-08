@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gatepass Item Interface'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_GATEITEM_RVI 
  as select from zmm_gateitem_db
  association to parent ZMM_GATEHEAD_RVI as _Head on $projection.Id = _Head.Id
{
  key id            as Id,
  key item          as item,
      purchaseorder as Purchaseorder,
      gateitem,
      salesorder,
      gatepassno,
      gateitemapi,
      material      as Material,
      materialdesc  as Materialdesc,
      uom           as Uom,
      wuom,
      @Semantics.quantity.unitOfMeasure : 'UOM'
      qty           as Qty,
      @Semantics.quantity.unitOfMeasure : 'UOM'
      maxqty,
      @Semantics.quantity.unitOfMeasure : 'UOM'
      avlqty,
//      @Semantics.quantity.unitOfMeasure : 'UOM'
      cast(qtybought as abap.dec( 13, 3 ) )     as Qtybought ,
      @Semantics.quantity.unitOfMeasure : 'WUOM'
      grossqty      as grossqty,
      @Semantics.quantity.unitOfMeasure : 'WUOM'
      tareqty       as tareqty,
      @Semantics.quantity.unitOfMeasure : 'WUOM'
      qtyactual     as Qtyactual,
      tconfirm      as tconfirm,
      tgr           as tgr,
      fconfirm,
      gr,
      bgross,
      bnet,
      storagelocation,
      weighbentrydate,
      weighbentrytime,
      weighbexitdate,
      weighbexittime,
      postinglog,
      sconfirm,
      ssconfirm,
      qtyboughtsts,
      @Semantics.quantity.unitOfMeasure : 'UOM'      
      pendqty,
      billingreference,
      _Head

}
