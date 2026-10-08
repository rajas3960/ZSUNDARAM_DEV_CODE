@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details for Item Line Section'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_ITEMLINE 
 as select from I_BillingDocumentItem      as a
   left outer join I_SalesDocumentItem     as b on b.SalesDocument = a.SalesDocument
   left outer join I_ProductPlantBasic     as c on c.Product = b.Material
   left outer join I_HandlingUnitItem      as d on d.HandlingUnitReferenceDocument = a.ReferenceSDDocument
                                                and d.HandlingUnitRefDocumentItem = a.ReferenceSDDocumentItem
   
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
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  a.NetAmount,
  d.HandlingUnitQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
  d.HandlingUnitQuantity
  
}
