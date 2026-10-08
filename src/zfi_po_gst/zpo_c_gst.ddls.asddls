@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST CONSUMPTION VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPO_C_GST
  provider contract transactional_query
  as projection on ZPO_I_GST
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
//      @UI.lineItem: [{position: 2,label: 'Select'}]
//      selected
}
