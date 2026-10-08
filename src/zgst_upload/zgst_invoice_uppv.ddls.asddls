@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Integration PV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZGST_INVOICE_UPPV
provider contract transactional_query 
as projection on ZGST_INVOICE_UPRV
{
key invoiceno,
key BillingDocumentItem,
key AccountingDocument,
key AccountingDocumentItem,
transtypecode,
systemcd,
branchcd,
verticalcd,
resultflag,
invoicetype,
invoicedt,
pos,
selfgstin,
clientid,
Cpgstinname,
cpgstin,
TransactionCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
TaxableValue,
CGSTAmount,
SGSTAmount,
IGSTAmount,
Taxrate,
invoiceValue,
//AccountingDocument,
FiscalYear,
//AccountingDocumentItem,
AccountingDocumentType,
orignalinvoiceno,
MonthYear,
PostingDate,
PortCode,

_Status
}
