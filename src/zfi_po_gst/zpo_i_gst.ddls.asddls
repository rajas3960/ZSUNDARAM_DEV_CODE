@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST INTERFACE VIEW'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPO_I_GST as select from ZPO_HEAD
{
key FiscalYear,
key CompanyCode,
key AccountingDocument,
key SourceLedger,
key LedgerGLLineItem,
DocumentDate,
AccountingDocumentType,
Supplier,
Fiscalperiod,
Selfgstin,
clientid,
BPSupplierFullName,
SupGSTIN,
TransType,
Resultflag,
TaxCode,
InvoiceValue,
CgstAmt,
CgstRate,
CgstType,
SgstAmt,
IgstAmt,
IgstRate,
IgstType,
TaxableValue,
statuscode,
ackno,
createdname,
createdby,
createdat,
selected
}
