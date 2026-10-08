@AbapCatalog.sqlViewName: 'ZSQ_PAY_ITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS to club lineitems for payment advice'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_payment_item
  as select from ZCDS_PAYMENT_ADV --ZV_PAYMENT_ITEM
{
  key CompanyCode,
  key AccountingDocument,
  key ClearingJournalEntryFiscalYear,
  key FiscalYear,
  key SupplierInvoice,
  key AccountingDocumentItem,
      AccountingDocumentType,
      SpecialGLCode,
      DocumentDate,
      PostingDate,
      AmountInCompanyCodeCurrency,
      CompanyCodeCurrency,
      NetDueDate,
      PaymentTerms,
      WithholdingTaxAmount,
      PurchasingDocument,
      FI_Invoice,
      SupplierInvoiceReference,
      cast( ZCDS_PAYMENT_ADV.AmountInCompanyCodeCurrency as abap.dec(13,2)) as retention_amount,
      cast( 0 as abap.dec(13,2))                                           as advance_amount,
      cast( 0 as abap.dec(13,2))                                           as amount,
      cast( 0 as abap.dec(13,2))                                           as ded_amount

}
where
  SpecialGLCode = 'C'

union all select from ZCDS_PAYMENT_ADV
{
  key CompanyCode,
  key AccountingDocument,
  key ClearingJournalEntryFiscalYear,
  key FiscalYear,
  key SupplierInvoice,
  key AccountingDocumentItem,
      AccountingDocumentType,
      SpecialGLCode,
      DocumentDate,
      PostingDate,
      AmountInCompanyCodeCurrency,
      CompanyCodeCurrency,
      NetDueDate,
      PaymentTerms,
      WithholdingTaxAmount,
      PurchasingDocument,
      FI_Invoice,
      SupplierInvoiceReference,
      cast( 0 as abap.dec(13,2))                                          as retention_amount,
      cast(ZCDS_PAYMENT_ADV.AmountInCompanyCodeCurrency as abap.dec(13,2)) as advance_amount,
      case( AccountingDocumentType )
      when 'ZP'
      then (cast(ZCDS_PAYMENT_ADV.NetAmountInCompanyCodeCurrency as abap.dec(13,2)))
      else
      (cast(0 as abap.dec(13,2)))
      end                                                                 as amount,
      cast( 0 as abap.dec(13,2))                                          as ded_amount
}
where
    SpecialGLCode = 'A'
  or(
    SpecialGLCode = 'F'
  )

union all select from ZCDS_PAYMENT_ADV
{
  key CompanyCode,
  key AccountingDocument,
  key ClearingJournalEntryFiscalYear,
  key FiscalYear,
  key SupplierInvoice,
  key AccountingDocumentItem,
      AccountingDocumentType,
      SpecialGLCode,
      DocumentDate,
      PostingDate,
      AmountInCompanyCodeCurrency,
      CompanyCodeCurrency,
      NetDueDate,
      PaymentTerms,
      WithholdingTaxAmount,
      PurchasingDocument,
      FI_Invoice,
      SupplierInvoiceReference,
      cast( 0 as abap.dec(13,2))                                               as retention_amount,
      cast( 0 as abap.dec(13,2))                                               as advance_amount,
      cast(  ZCDS_PAYMENT_ADV.NetAmountInCompanyCodeCurrency as abap.dec(13,2)) as amount,
      cast( 0 as abap.dec(13,2))                                               as ded_amount
}
where
  SpecialGLCode = ''
union all select from ZCDS_PAYMENT_ADV
{
  key CompanyCode,
  key AccountingDocument,
  key ClearingJournalEntryFiscalYear,
  key FiscalYear,
  key SupplierInvoice,
  key AccountingDocumentItem,
      AccountingDocumentType,
      SpecialGLCode,
      DocumentDate,
      PostingDate,
      AmountInCompanyCodeCurrency,
      CompanyCodeCurrency,
      NetDueDate,
      PaymentTerms,
      WithholdingTaxAmount,
      PurchasingDocument,
      FI_Invoice,
      SupplierInvoiceReference,
      cast( 0 as abap.dec(13,2))                                           as retention_amount,
      cast( 0 as abap.dec(13,2))                                           as advance_amount,
      cast( 0 as abap.dec(13,2))                                           as amount,
      cast( ZCDS_PAYMENT_ADV.AmountInCompanyCodeCurrency as abap.dec(13,2)) as ded_amount
}
where
    SpecialGLCode = 'D'
  or(
    SpecialGLCode = 'G'
  )
