@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for CGST,SGST and IGST for SOA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RE_GST
  as select distinct from I_OperationalAcctgDocItem
{
  key AccountingDocument,
  key CompanyCode,
  key FiscalYear,
      GLAccount,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(AmountInCompanyCodeCurrency) as gstamt
}
where
     GLAccount = '0000248007'
  or GLAccount = '0000248008'
//  or GLAccount = '0000248009'
  or GLAccount = '0000248017'
group by
  AccountingDocument,
  CompanyCode,
  FiscalYear,
  GLAccount,
  CompanyCodeCurrency
