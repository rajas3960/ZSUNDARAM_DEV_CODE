@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRPT_V14
  as select from    I_SalesContractItem as i
    left outer join ZV_CONTRACTRPT_V10  as k on  i.SalesContract     = k.SalesContract
                                             and i.SalesContractItem = k.SalesContractItem


{ 
  key k.SalesContract,
  key k.SalesContractItem,
      k.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(k.AmountInFunctionalCurrency_H) as AmountInFunctionalCurrency_H
}
group by
  k.SalesContract,
  k.SalesContractItem,
  k.TransactionCurrency
