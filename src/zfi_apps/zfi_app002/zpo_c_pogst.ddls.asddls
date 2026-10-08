@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST Integration Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPO_C_POGST 
provider contract transactional_query
as projection on ZPO_I_POGST
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
    @ObjectModel.text.element: [ 'createdname' ]
    createdby,
    createdat
}
