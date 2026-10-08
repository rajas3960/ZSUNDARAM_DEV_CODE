@AbapCatalog.sqlViewName: 'ZSQ_SUPPREF1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS to fetch supplier reference'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_suppref1
  as select from I_JournalEntry as A
{
  A.AccountingDocument,
  A.CompanyCode,
  A.FiscalYear,
  A.DocumentReferenceID,
  A.PostingDate
}
