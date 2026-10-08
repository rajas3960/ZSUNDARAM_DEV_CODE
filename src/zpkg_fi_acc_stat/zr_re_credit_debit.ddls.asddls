@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RE - Credit/Debit Invoice Gross Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RE_CREDIT_DEBIT as select from I_OperationalAcctgDocItem
{
     key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
      CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     AmountInCompanyCodeCurrency 
}
where AccountingDocumentItemType is initial
and TransactionTypeDetermination = 'KBS'
and AmountInCompanyCodeCurrency > 0
