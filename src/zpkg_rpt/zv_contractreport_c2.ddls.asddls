@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit limit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTReport_C2 as select distinct from ZV_CONTRACTReport_C
{
  key Customer,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency
}

group by
  Customer,
  CompanyCodeCurrency
