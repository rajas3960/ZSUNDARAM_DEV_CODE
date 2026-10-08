@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST INPUT REGISTER INTEGRATION RV'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPO_I_POGSTT
  as select from ZPO_GST_HEADD
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
