@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HEADER'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_HEAD as select from ZPO_VIEW1     as a
    left outer join ZPO_JEI_VIEW1 as b on  b.FiscalYear         = a.FiscalYear
                                            and b.CompanyCode        = a.CompanyCode
                                            and b.AccountingDocument = a.AccountingDocument
                                            and b.SourceLedger       = a.SourceLedger
    left outer join zpo_gst_db   as c on  c.fiscalyear         = a.FiscalYear
                                            and c.companycode        = a.CompanyCode
                                            and c.accountingdocument = a.AccountingDocument
                                            and c.sourceledger       = a.SourceLedger
{

  key a.FiscalYear,
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.SourceLedger,
  key b.LedgerGLLineItem,
      a.DocumentDate,
      a.AccountingDocumentType,
      a.Supplier,
      a.Fiscalperiod,
      a.Selfgstin,
      a.clientid,
      a.BPSupplierFullName,
      a.SupGSTIN,
      a.TransType,
      a.Resultflag,
      b.TaxCode,
      b.InvoiceValue,
      b.CgstAmt,
      b.CgstRate,
      b.CgstType,
      b.SgstAmt,
      b.SgstRate,
      b.SgstType,
      b.IgstAmt,
      b.IgstRate,
      b.IgstType,
      b.TaxableValue,
      c.statuscode,
      c.ackno,
      c.createdname,
      c.createdby,
      c.createdat,
      c.selected

}
where b.LedgerGLLineItem is not null
