@AbapCatalog.sqlViewName: 'ZSQL_SUPP_INV_KZ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch Supplier Inv for Payment Advice'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SUPP_INV_KZ
  as select from I_OperationalAcctgDocItem as a
{
  a.ClearingJournalEntry,
  a.ClearingJournalEntryFiscalYear,
  a.CompanyCode,
  a.AccountingDocument,
  a.AccountingDocumentType,
  a.InvoiceReference as supp_inv,
  a.AmountInCompanyCodeCurrency
}
where a.AccountingDocumentType <> 'ZP'
and a.AccountingDocumentType <> 'KZ'

