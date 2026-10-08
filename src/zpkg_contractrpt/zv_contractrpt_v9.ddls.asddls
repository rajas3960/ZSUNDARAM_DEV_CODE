@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRPT_V9
  as select from I_OperationalAcctgDocItem
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode, 
  key AccountingDocumentItem,
      Customer,
      CompanyCodeCurrency,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      AmountInCompanyCodeCurrency,
      FinancialAccountType,
      BillingDocument,
      ClearingJournalEntry,
      cast( AbsltAmtInAdditionalCurrency1 as abap.dec(15,2) ) as netvalue
}
where
      Customer             is not initial
  and FinancialAccountType = 'D'
  //and ClearingJournalEntry like '14%'

  
