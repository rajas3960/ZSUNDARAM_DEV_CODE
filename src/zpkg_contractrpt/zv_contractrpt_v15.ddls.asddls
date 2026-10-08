@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRPT_V15
  as select from    I_SalesContractItem                                                           as a
    left outer join I_SalesOrderItem                                                              as b on  b.ReferenceSDDocument     = a.SalesContract
                                                                                                       and b.ReferenceSDDocumentItem = a.SalesContractItem
    left outer join I_BillingDocumentItemCube( P_ExchangeRateType:'M', P_DisplayCurrency: 'INR' ) as c on  c.SalesDocument     = b.SalesOrder
                                                                                                       and c.SalesDocumentItem = b.SalesOrderItem
{
  key a.SalesContract,  
  key a.SalesContractItem,
      b.SalesOrder,
      b.SalesOrderItem,
      b.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(c.ItemNetAmountOfBillingDoc_2)               as ItemNetAmountOfBillingDoc_2,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(c.TaxAmount)                                 as TaxAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(c.ItemNetAmountOfBillingDoc_2 + c.TaxAmount) as TotalBilledAmount

}

where
      c.CancelledBillingDocument   is initial
  and c.BillingDocumentIsCancelled != 'X'

group by
  a.SalesContract,
  a.SalesContractItem,
  b.SalesOrder,
  b.SalesOrderItem,
  b.TransactionCurrency
////  c.ItemNetAmountOfBillingDoc_2,
////  c.TaxAmount
