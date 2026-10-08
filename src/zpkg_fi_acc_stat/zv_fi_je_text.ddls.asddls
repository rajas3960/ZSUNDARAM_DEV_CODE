@AbapCatalog.sqlViewName: 'ZZVFITEXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Text'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_FI_JE_TEXT
  as select distinct from I_JournalEntryItem
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
      DocumentItemText
}
where
  DocumentItemText is not initial
