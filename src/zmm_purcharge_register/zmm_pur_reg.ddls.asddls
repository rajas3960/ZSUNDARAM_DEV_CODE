@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register for pricing condition'
@Metadata.ignorePropagatedAnnotations: true


define view entity ZMM_PUR_REG
  as select from I_PurchaseOrderAPI01 as po
left outer join I_SuplrInvcItemPurOrdRefAPI01 as spo on spo.PurchaseOrder = po.PurchaseOrder
{
  key po.PurchaseOrder,
  key spo.PurchaseOrderItem,
      spo.PurchaseOrderQuantityUnit as PurorderQuantityUnit,
      po.PurchaseOrderDate,
      
      @Semantics.quantity.unitOfMeasure: 'PurorderQuantityUnit'
      sum( spo.QuantityInPurchaseOrderUnit ) as TotalQuantity,
      spo.ReferenceDocument
}
where
  spo.ReferenceDocument = '' // Ensure this matches your data criteria
  and spo.SuplrInvcDeliveryCostCndnType = 'ZEF2'
  
group by
  po.PurchaseOrder,
  spo.PurchaseOrderItem,
  po.PurchaseOrderDate,
  spo.PurchaseOrderQuantityUnit,
  spo.ReferenceDocument





//  as select from I_JournalEntry     as JE
//    inner join   I_JournalEntryItem as JEI on  JE.CompanyCode        = JEI.CompanyCode
//                                           and JE.AccountingDocument = JEI.AccountingDocument
//                                           and JE.FiscalYear         = JEI.FiscalYear
//                                           and JEI.Ledger = '0L'
//{
//  key JE.CompanyCode,
//  key JE.AccountingDocument,
//  key JE.FiscalYear,
//  key JEI.LedgerGLLineItem, -- Adding this key prevents technical row merging issues
//
//  JEI.GLAccount,
//  @Semantics.amount.currencyCode: 'TransactionCurrency'
//  JEI.AmountInTransactionCurrency,
//  JEI.TransactionCurrency,
//  JEI.ReferenceDocument
//}
//where
//  JEI.GLAccount = '0000475014'
