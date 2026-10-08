@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Print Item View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZGATE_PRINT_ITEM_VIEW
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
      @Semantics.quantity.unitOfMeasure: 'Uom'
      qty              as Qty,
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
      salesorder       as Salesorder
}
