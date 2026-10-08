@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_CONTRACTRPT_V13
  as select from I_SalesContractItem as i
    left outer join   ZV_CONTRACTRPT_V12  as k on i.SalesContract = k.SalesContract
                                               and i.SalesContractItem = k.SalesContractItem


{
  key k.SalesContract,
  key k.SalesContractItem, 
      k.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(k.AmountInFunctionalCurrency_s) as AmountInFunctionalCurrency_s
}
group by
  k.SalesContract,
  k.SalesContractItem,
  k.TransactionCurrency
