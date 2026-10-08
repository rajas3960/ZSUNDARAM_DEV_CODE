@AbapCatalog.sqlViewName: 'ZSQL_SUPP_INV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS  to fetch Supplier Invoice for Payment Advice'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SUPP_INV
  as select from I_OperationalAcctgDocItem as a
{
  a.ClearingJournalEntry,
  a.FiscalYear,
  a.CompanyCode,
  a.AccountingDocument,
  a.AccountingDocumentType,
  left( a.OriginalReferenceDocument,10 ) as supp_inv
}
