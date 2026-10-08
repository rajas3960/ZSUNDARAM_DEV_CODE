@AbapCatalog.sqlViewName: 'ZSQL_SUPP_INV1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS  to fetch Supplier Invoice for Payment Advice'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SUPP_INV1
  as select from ZCDS_SUPP_INV          as a
    inner join   I_SupplierInvoiceAPI01 as b on(
      a.supp_inv = b.SupplierInvoice
    )
{
  a.ClearingJournalEntry,
  a.FiscalYear,
  a.CompanyCode,
  a.AccountingDocument,
  a.AccountingDocumentType,
  a.supp_inv,
  b.SupplierInvoiceIDByInvcgParty as supp_ref
}
