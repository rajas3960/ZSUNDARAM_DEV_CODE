@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTREPORT_V9 as select from I_OperationalAcctgDocItem
{

  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  key AccountingDocumentItem,
      Customer,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      FinancialAccountType,
      BillingDocument

}
where Customer is not initial 
//FinancialAccountType = 'D'

