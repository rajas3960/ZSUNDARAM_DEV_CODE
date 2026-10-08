@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTReport_V6 as select from I_OperationalAcctgDocItem
{

  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  key AccountingDocumentItem,
      Customer,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency

}

where
      Customer               is not initial
  and AccountingDocumentType = 'RV'
