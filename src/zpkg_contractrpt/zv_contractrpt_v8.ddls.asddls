@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRPT_V8
  as select from I_SalesContractItem as a
    inner join   ZV_CONTRACTRPT_V1   as b on  a.SalesContract     = b.SalesContract
                                          and a.SalesContractItem = b.SalesContractItem
{
  key b.SalesContract,
  key b.SalesContractItem,
      b.BillingQuantityUnit, 
      //      sum( cast( b.amountincompanycode as abap.dec(21,2)) ) as amountincompanycode,
      //cast( b.Netamount as abap.dec(21,2))  as Netamount,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      sum( b.BillingQuantity ) as BillingQuantity,
      b.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum (b.TotalAmount)      as TotalAmount

}

group by
  b.SalesContract,
  b.SalesContractItem,
  b.BillingQuantityUnit,
  b.TransactionCurrency
// b.Netamount
