@EndUserText.label: 'Test'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_TEST 
as select from I_BillingDocumentItemPrcgElmnt as a

{
    a.TransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case a.ConditionType
      when 'JTC1'
        then cast( a.ConditionAmount as abap.dec(23,2))
        else ( 0 ) end as TCS
}
