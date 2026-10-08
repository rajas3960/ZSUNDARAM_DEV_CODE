@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_INVOICE_KZ as select from I_OperationalAcctgDocItem as a
inner join          I_JournalEntry            as b on(
    b.AccountingDocument = a.AccountingDocument
    and b.FiscalYear     = a.FiscalYear
    and b.CompanyCode    = a.CompanyCode
  )
left outer join I_JournalEntry as c on
( c.AccountingDocument = a.InvoiceReference and c.FiscalYear = a.InvoiceReferenceFiscalYear and c.CompanyCode = a.CompanyCode )
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
    a.InvoiceReference,
    a.InvoiceReferenceFiscalYear,
    left( c.OriginalReferenceDocument,10 ) as SupplierInvoice,
    right( c.OriginalReferenceDocument,4 ) as SupplierFiscalYear 
}
where a.DebitCreditCode = 'S'
and b.AccountingDocumentType = 'KZ'
and a.InvoiceReference <> ''
and c.OriginalReferenceDocument <> ''
