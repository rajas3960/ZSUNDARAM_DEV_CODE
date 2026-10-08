@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gatepass Item Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZMM_GATEITEM_PVC 
as projection on ZMM_GATEITEM_RVI
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key item,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Purchase Order'
      Purchaseorder,
      @EndUserText.label: 'PO/SO Item'
      gateitem,
      @EndUserText.label: 'Purchase Order Item'
      gatepassno,
      @EndUserText.label: 'Gate Item Api'
      gateitemapi,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material desc'
      Materialdesc,
      @EndUserText.label: 'Order UOM'
      Uom,
      @EndUserText.label: 'Weight UOM'
      wuom,
      @Semantics.quantity.unitOfMeasure : 'UOM'
      @EndUserText.label: 'Quantity in PO/SO'
      Qty,
      @Semantics.quantity.unitOfMeasure : 'UOM'      
      @EndUserText.label: 'Maximum Quantity'
      maxqty,
      @Semantics.quantity.unitOfMeasure : 'UOM'      
      @EndUserText.label: 'Available Quantity'
      avlqty,
      @EndUserText.label: 'Gross Quantity'
      @Semantics.quantity.unitOfMeasure : 'UOM'      
      grossqty,
      @EndUserText.label: 'Tare Quantity'
      @Semantics.quantity.unitOfMeasure : 'UOM'      
      tareqty,
      @EndUserText.label: 'Sold/Received Quantity' //'Receive Quantity' //'Actual Quantity'
      Qtybought,
      @EndUserText.label: 'Weighment Quantity'
      @Semantics.quantity.unitOfMeasure : 'UOM'      
      Qtyactual,
      tconfirm,
      tgr,
      @EndUserText.label: 'Confirmation of User Department'
      fconfirm,
      @EndUserText.label: 'GR Posted'
      gr,
      @EndUserText.label: 'Sales Order'
      salesorder,
      @EndUserText.label: 'Storage Location'
      storagelocation,
      @EndUserText.label: 'Gross Weight'
      bgross,
      @EndUserText.label: 'Net Weight'
      bnet,
      @EndUserText.label: 'Weighment Entry Date'
      weighbentrydate,
      @EndUserText.label: 'Weighment Entry Time'
      weighbentrytime,
      @EndUserText.label: 'Weighment Exit Date'
      weighbexitdate,
      @EndUserText.label: 'Weighment Exit Time'
      weighbexittime,
      @EndUserText.label: 'Posting Log'
      postinglog,
      sconfirm,
      @EndUserText.label: 'Confirmation of Stores'
      ssconfirm,
      @EndUserText.label: 'Billing Reference'
      billingreference,
      @Semantics.quantity.unitOfMeasure : 'UOM'
      @EndUserText.label: 'Pending Quantity'      
      pendqty,
      qtyboughtsts,
      /* Associations */
      _Head : redirected to parent ZMM_GATEHEAD_PVC

}
