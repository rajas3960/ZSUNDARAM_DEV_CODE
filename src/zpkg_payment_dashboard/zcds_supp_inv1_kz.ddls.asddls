@AbapCatalog.sqlViewName: 'ZSQ_SUPP_INV1_KZ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch Supplier Inv for Payment Advice'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SUPP_INV1_KZ
  as select from    ZCDS_SUPP_INV_KZ       as a
    left outer join I_SupplierInvoiceAPI01 as b on(
      a.supp_inv = b.SupplierInvoice
    )
{
  a.ClearingJournalEntry,
  a.ClearingJournalEntryFiscalYear,
  a.CompanyCode,
  a.AccountingDocument,
  a.AccountingDocumentType,
  a.supp_inv,
  b.SupplierInvoiceIDByInvcgParty as supp_ref,
  a.AmountInCompanyCodeCurrency as InvoiceGrossAmount
}
