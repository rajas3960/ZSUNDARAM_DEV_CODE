@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRPT_V16
  as select from    I_SalesContractItem as a
    left outer join ZV_CONTRACTRPT_V15  as b on  a.SalesContract     = b.SalesContract
                                             and a.SalesContractItem = b.SalesContractItem
{
  key b.SalesContract,
  key b.SalesContractItem,
      b.TransactionCurrency, 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(b.TotalBilledAmount) as TotalBilledAmount
}
group by
  b.SalesContract,
  b.TransactionCurrency,
  b.SalesContractItem
