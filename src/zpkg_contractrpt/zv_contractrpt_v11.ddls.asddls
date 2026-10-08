@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
} 
define view entity ZV_CONTRACTRPT_V11
  as select from    I_SalesContractItem as i
    left outer join ZV_CONTRACTRPT_V14  as k on  i.SalesContract     = k.SalesContract
                                             and i.SalesContractItem = k.SalesContractItem
    left outer join ZV_CONTRACTRPT_V16  as m on  i.SalesContract     = m.SalesContract
                                             and i.SalesContractItem = m.SalesContractItem
{
  key k.SalesContract,
  key i.SalesContractItem,
      k.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast(
      //        k.AmountInFunctionalCurrency_H
      //        + coalesce( m.AmountInFunctionalCurrency_s,
      //                    cast( 0 as abap.curr( 15, 2 ) ) )
      //      as abap.dec( 21, 2 ) ) as customercreditlimit
      cast(cast( k.AmountInFunctionalCurrency_H as abap.dec(21,2) ) - coalesce( cast( m.TotalBilledAmount as abap.dec(21,2) ),0)
      as abap.dec(21,2)) as customercreditlimit

}
group by
  k.SalesContract,
  i.SalesContractItem,
  k.TransactionCurrency,
  k.AmountInFunctionalCurrency_H,
  //m.AmountInFunctionalCurrency_s
  m.TotalBilledAmount
