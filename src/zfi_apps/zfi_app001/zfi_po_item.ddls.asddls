@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase order details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_PO_ITEM 
as select from I_PurchaseOrderAPI01 as POH
inner join I_PurchaseOrderItemAPI01 as POI on POI.PurchaseOrder = POH.PurchaseOrder
left outer join I_ProductPlantBasic as HSN on HSN.Product = POI.Material
                                and HSN.Plant = POI.Plant
left outer join I_PurOrdItmPricingElementAPI01 as PMP0 on PMP0.PurchaseOrder = POI.PurchaseOrder
                                and PMP0.PurchaseOrderItem = POI.PurchaseOrderItem
                                and PMP0.ConditionType = 'PMP0'
{
    key POI.PurchaseOrder,
    key POI.PurchaseOrderItem,
        POH.PurchaseOrderType,
        POH.PurchaseOrderDate,
        POI.Material,
        POI.PurchaseOrderItemText,
        HSN.ConsumptionTaxCtrlCode as HSNCode,
        POI.BaseUnit,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        POI.OrderQuantity,
        cast( PMP0.ConditionRateValue as abap.dec( 15, 2 ) ) as Rate,
        cast( POI.NetAmount as abap.dec( 15,2 ) ) as Amount
}
