@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Item Custom View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_GATEITEM_VIEW
  as select from zmm_gateitem_db
{
  key id               as Id,
  key item             as Item,
      purchaseorder    as Purchaseorder,
      gateitem         as Gateitem,
      gatepassno       as Gatepassno,
      gateitemapi      as Gateitemapi,
      material         as Material,
      materialdesc     as Materialdesc,
      uom              as Uom,
      wuom             as Wuom,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qty              as Qty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      maxqty           as Maxqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      avlqty           as Avlqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qtybought        as Qtybought,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      grossqty         as Grossqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      tareqty          as Tareqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qtyactual        as Qtyactual,
      storagelocation  as Storagelocation,
      tconfirm         as Tconfirm,
      tgr              as Tgr,
      fconfirm         as Fconfirm,
      gr               as Gr,
      salesorder       as Salesorder,
      billingreference as Billingreference,
      bgross           as Bgross,
      bnet             as Bnet,
      weighbentrydate  as Weighbentrydate,
      weighbentrytime  as Weighbentrytime,
      weighbexitdate   as Weighbexitdate,
      weighbexittime   as Weighbexittime,
      postinglog       as Postinglog,
      sconfirm         as Sconfirm,
      ssconfirm        as Ssconfirm,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      pendqty          as Pendqty
}
