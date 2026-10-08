@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'connect1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zconnect1
  as select from   I_SalesContractItem as i
  inner join zconnect as k on i.SalesContract = k.SalesContract
                           and i.SalesContractItem = k.SalesContractItem
{
    key k.SalesContract,
    key k.SalesContractItem,
    k.TransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(k.AmountInFunctionalCurrency) as customercreditlimit
    
}
group by 
k.SalesContract,
k.SalesContractItem,
k.TransactionCurrency
