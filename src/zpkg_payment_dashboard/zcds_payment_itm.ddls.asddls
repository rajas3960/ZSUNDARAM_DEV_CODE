@AbapCatalog.sqlViewName: 'ZSQ_PAY_ITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS to club lineitems for payment advice'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_payment_itm
  as select from zcds_payment_item
{
  key CompanyCode,
  key AccountingDocument,
  key ClearingJournalEntryFiscalYear,
  key FI_Invoice,
      max( SupplierInvoice )                                                               as SupplierInvoice,
      max( AccountingDocumentItem)                                                         as AccountingDocumentItem,
      max( AccountingDocumentType)                                                         as AccountingDocumentType,
      max( SpecialGLCode)                                                                  as SpecialGLCode,
      max( DocumentDate)                                                                   as DocumentDate,
      max( PostingDate)                                                                    as PostingDate,
      max( AmountInCompanyCodeCurrency)                                                    as AmountInCompanyCodeCurrency,
      max( CompanyCodeCurrency)                                                            as CompanyCodeCurrency,
      max( NetDueDate)                                                                     as NetDueDate,
      max( PaymentTerms)                                                                   as PaymentTerms,
      max( WithholdingTaxAmount)                                                           as WithholdingTaxAmount,
      max( PurchasingDocument)                                                             as PurchasingDocument,
      max( FiscalYear)                                                                     as FiscalYear,
      max( SupplierInvoiceReference)                                                       as SupplierInvoiceReference,
      //sum( abs(retention_amount))             as total_retention_amount,
      sum(case when retention_amount < 0 then -retention_amount else retention_amount end) as total_retention_amount,
      //sum(advance_amount)               as total_advance_amount,
      sum(case when advance_amount < 0 then -advance_amount else advance_amount end)       as total_advance_amount,
      sum(amount)                                                                          as total_amount
}
group by
  CompanyCode,
  AccountingDocument,
  ClearingJournalEntryFiscalYear,
  FI_Invoice
