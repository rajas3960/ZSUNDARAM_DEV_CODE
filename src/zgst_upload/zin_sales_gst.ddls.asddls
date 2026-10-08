@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Integration View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZIN_SALES_GST 
as select from ZIN_INVOICE_VIEW as a

left outer join ZIN_JOURNAL_VIEW as b on b.ReferenceDocument = a.invoiceno
                                    and b.ReferenceDocumentItem = a.BillingDocumentItem
{
    key a.invoiceno,
    key a.BillingDocumentItem,
    key b.AccountingDocument,
    key b.AccountingDocumentItem,
    a.transtypecode,
    a.systemcd,
    a.branchcd,
    a.verticalcd,
    a.resultflag,
    a.invoicetype,
    a.invoicedt,
    a.pos,
    a.selfgstin,
    a.clientid,
    a.Cpgstinname,
    a.cpgstin,
    a.TransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.TaxableValue,
    a.CGSTAmount,
    a.SGSTAmount,
    a.IGSTAmount,
    a.Taxrate,
    a.invoiceValue,
    
// Journal Entry
//    b.AccountingDocument,
    b.FiscalYear,
//    b.AccountingDocumentItem,
    b.AccountingDocumentType,
    b.orignalinvoiceno,
    b.MonthYear,
    b.PostingDate,
    a.PortCode    
}
