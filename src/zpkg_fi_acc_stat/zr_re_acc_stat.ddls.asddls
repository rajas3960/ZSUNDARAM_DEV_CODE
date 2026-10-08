@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RE Base Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RE_ACC_STAT
as select from ZR_RE_CREDIT_DEBIT
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum( AmountInCompanyCodeCurrency ) as amt
}
group by AccountingDocument,
CompanyCode,
FiscalYear,
CompanyCodeCurrency
