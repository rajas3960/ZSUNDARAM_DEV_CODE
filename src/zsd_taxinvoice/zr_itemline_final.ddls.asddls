@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final View for Itemline'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_ITEMLINE_FINAL 
  as select distinct from I_BillingDocumentItem      as a
   left outer join I_SalesDocumentItem     as b on b.SalesDocument = a.SalesDocument
   left outer join I_ProductPlantBasic     as c on c.Product = b.Material
   left outer join I_HandlingUnitItem      as d on d.HandlingUnitReferenceDocument = a.ReferenceSDDocument
                                                and d.HandlingUnitRefDocumentItem = a.ReferenceSDDocumentItem
   left outer join I_BillingDocumentItemPrcgElmnt as J on  J.BillingDocument     = a.BillingDocument
                                                        and J.BillingDocumentItem = a.BillingDocumentItem
   left outer join I_SerialNumberDeliveryDocument as e on e.DeliveryDocument = a.ReferenceSDDocument
                                                        and e.DeliveryDocumentItem = a.ReferenceSDDocumentItem
{
  key a.BillingDocument,
  key a.BillingDocumentItem,
  a.BillingDocumentItemText,
  c.ConsumptionTaxCtrlCode as hsncode,
//  b.OrderQuantityUnit,
//  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
//  b.OrderQuantity,
//  b.ItemWeightUnit,
  a.BillingQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
  a.BillingQuantity,
  a.TransactionCurrency,
  case 
  when J.ConditionType = 'ZPR1'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZPR0'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZPEX'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZPR2'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZSRP'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZAST'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZSAM'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZSTO'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZP01'
  then cast( J.ConditionAmount as abap.dec(23,2))
  when J.ConditionType = 'ZP02'
  then cast( J.ConditionAmount as abap.dec(23,2))
  else 
  cast( 0 as abap.dec(23,2))
  end  as NetAmount,
  d.HandlingUnitQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
  max(d.HandlingUnitQuantity) as HandlingUnitQtyMax,
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
  min(d.HandlingUnitQuantity) as HandlingUnitQtyMin,
  e.SerialNumber
  
}
where c.ConsumptionTaxCtrlCode is not initial 
group by
a.BillingDocument,
  a.BillingDocumentItem,
  a.BillingDocumentItemText,
  c.ConsumptionTaxCtrlCode,
  a.BillingQuantityUnit,
  a.BillingQuantity,
  a.TransactionCurrency,
  a.NetAmount,
  d.HandlingUnitQuantityUnit,
  J.ConditionType,
  J.ConditionAmount,
  e.SerialNumber
  
