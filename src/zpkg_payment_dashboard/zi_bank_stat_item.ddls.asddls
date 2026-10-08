@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_bank_stat_item
  as select from ZV_PAYMENT_ITEM as a
  association to parent ZI_bank_stat_head as _Head on  $projection.CompanyCode                    = _Head.Companycode
                                                   and $projection.AccountingDocument             = _Head.Accountingdoc
                                                   and $projection.ClearingJournalEntryFiscalYear = _Head.Fiscalyear
{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.ClearingJournalEntryFiscalYear,
  key a.FiscalYear,
  key a.SupplierInvoice,
  key a.AccountingDocumentItem,
  key a.FI_Invoice,
      a.AccountingDocumentType,
      a.SpecialGLCode,
      a.DocumentDate,
      a.PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.NetDueDate,
      a.PaymentTerms,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.WithholdingTaxAmount,
      a.PurchasingDocument,
      _Head
}
group by a.CompanyCode,a.AccountingDocument,a.ClearingJournalEntryFiscalYear,a.FiscalYear,a.SupplierInvoice,
         a.AccountingDocumentItem,a.AccountingDocumentType,a.SpecialGLCode,
         a.DocumentDate,a.PostingDate,a.AmountInCompanyCodeCurrency,a.CompanyCodeCurrency,a.NetDueDate,
         a.PaymentTerms,a.WithholdingTaxAmount,a.PurchasingDocument,a.FI_Invoice
