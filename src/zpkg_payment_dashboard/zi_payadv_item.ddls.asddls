@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PAYADV_ITEM
 as select from zcds_payment_item1 as a --ZV_PAYMENT_ITEM
 association to parent ZI_PAYADV_HEAD as _Head on  $projection.CompanyCode        = _Head.Companycode
                                                  and $projection.AccountingDocument = _Head.Accountingdoc
                                                  and $projection.FiscalYear = _Head.Fiscalyear
{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.ClearingJournalEntryFiscalYear as FiscalYear,
  key a.SupplierInvoice,
  key a.AccountingDocumentItem,
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
      a.FI_Invoice, --++AK 29/04/2025
      a.SupplierInvoiceReference, --++AK 29/04/2025 
      a.total_retention_amount,--++ AK 05/05/2025
      a.total_advance_amount,--++ AK 05/05/2025
      a.total_amount,--++ AK 05/05/2025
      a.total_ded_amount, --++AK 28/05/2025
      _Head
}
