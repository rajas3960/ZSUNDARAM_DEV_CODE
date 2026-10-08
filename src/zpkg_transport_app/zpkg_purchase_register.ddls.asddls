@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPKG_PURCHASE_REGISTER
  as select from I_MaterialDocumentItem_2 as matdocitem
  left outer join I_PurchaseOrderItemAPI01 as purchaseorder on  purchaseorder.PurchaseOrder     = matdocitem.PurchaseOrder
                                                            and purchaseorder.PurchaseOrderItem = matdocitem.PurchaseOrderItem
  left outer join ZMM_PUR_REG as purreg on purreg.PurchaseOrder     = matdocitem.PurchaseOrder
                                    and purreg.PurchaseOrderItem = matdocitem.PurchaseOrderItem                                                          
  
{
  key matdocitem.PurchaseOrder     as Purchase_Order,
  key matdocitem.PurchaseOrderItem as Purchase_Order_Item,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum(matdocitem.QuantityInBaseUnit) as Quantity,
  matdocitem.MaterialBaseUnit,
  purchaseorder.Material,
  purchaseorder.PurchaseOrderItemText as POItemText,
  @Semantics.quantity.unitOfMeasure: 'PurorderQuantityUnit'
  purreg.TotalQuantity as invoice_quantity,
  purreg.PurorderQuantityUnit
  
}
 
group by
  matdocitem.PurchaseOrder,
  matdocitem.PurchaseOrderItem,
  matdocitem.MaterialBaseUnit,
  purchaseorder.Material,
  purchaseorder.PurchaseOrderItemText,
  purreg.TotalQuantity,
  purreg.PurorderQuantityUnit
