@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST INPUT REGISTER INTEGRATION CV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPO_POGST_CV
  provider contract transactional_query
  as projection on ZPO_POGST_IV
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
      @ObjectModel.text.element: [ 'createdname' ]
      createdby,
      createdat
}
