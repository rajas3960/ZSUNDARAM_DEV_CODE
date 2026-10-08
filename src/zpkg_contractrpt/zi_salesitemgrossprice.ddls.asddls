@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gross Price'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SALESITEMGROSSPRICE as select from  I_SalesDocItemPricingElement 

{
key SalesDocument,
key SalesDocumentItem,
TransactionCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
ConditionAmount

}
where ( ConditionType = 'JOCG'
                                                     or ConditionType = 'JOSG'
                                                     or ConditionType = 'JOIG' )
  and ConditionAmount <> 0.00
