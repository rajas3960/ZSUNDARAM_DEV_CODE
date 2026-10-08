@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Integration RV'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGST_INVOICE_UPRV 
as select from ZIN_SALES_GST as BOI
//    inner join ZIN_HEAD_VIEW as BOH on BOH.Invoiceno = BOI.Invoiceno

association [0..*] to ZGST_STATUS as _Status on _Status.Invoiceno = $projection.invoiceno
                                                and _Status.Billingdocumentitem = $projection.BillingDocumentItem
                                                and _Status.Accountingdocument = $projection.AccountingDocument
                                                and _Status.Accountingdocumentitem = $projection.AccountingDocumentItem
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
