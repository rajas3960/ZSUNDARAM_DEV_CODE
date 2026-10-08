@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_HEAD_L2
  as select distinct from I_OperationalAcctgDocItem as a

{
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.CompanyCode,
      a.AccountingDocumentType,
      a.DocumentDate,
      a.PostingDate,
      a.ValueDate,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( a.AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency
}
where
  (
    (
         a.AccountingDocumentType =  'ZP'
      or a.AccountingDocumentType =  'KZ'
    )
    and  a.HouseBank              is not initial
    and  a.HouseBankAccount       is not initial
    and  a.Supplier               is initial
    and  a.ClearingIsReversed     <> 'X'
    and  a.FinancialAccountType   =  'S'
    and  a.FiscalYear >= '2025'
  )
group by
  a.AccountingDocument,
  a.FiscalYear,
  a.CompanyCode,
  a.AccountingDocumentType,
  a.CompanyCodeCurrency,
  a.DocumentDate,
  a.PostingDate,
  a.ValueDate,
  a.PaymentMethod,
  a.HouseBank,
  a.HouseBankAccount
