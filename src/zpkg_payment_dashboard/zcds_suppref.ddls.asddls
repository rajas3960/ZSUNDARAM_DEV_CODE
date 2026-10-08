@AbapCatalog.sqlViewName: 'ZQS_SUPPREF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS to fetch supplier reference'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_suppref
  as select from I_OperationalAcctgDocItem as A
{
  A.ClearingJournalEntry,
  A.CompanyCode,
  A.FiscalYear,
  A.AccountingDocument,
  A.AccountingDocumentType
}
