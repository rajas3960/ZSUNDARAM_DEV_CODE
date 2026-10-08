@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTREPORT_V7 as select from ZV_CONTRACTReport_V6
{
  key Customer,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency
}
group by
  Customer,
  CompanyCodeCurrency
