@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST Mass Processing Items'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_I_PO_GST_MASS_ITEM as select from ZPO_POGST_IV
{
    key FiscalYear,
    key CompanyCode,
    key AccountingDocument,
    key SourceLedger,
    key LedgerGLLineItem,
    DocumentDate,
    PostingDate,
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
    createdat
}
