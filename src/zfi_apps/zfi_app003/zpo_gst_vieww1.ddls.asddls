@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST INPUT REGISTER INTEGRATION VIEW 1'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_GST_VIEWW1
  as select from    I_JournalEntry     as a
    inner join      I_JournalEntryItem as b on  b.FiscalYear         = a.FiscalYear
                                            and b.CompanyCode        = a.CompanyCode
                                            and b.AccountingDocument = a.AccountingDocument
                                            and b.Ledger             = '0L'
                                            and b.LedgerGLLineItem   = '000001'
    left outer join zdt_header_token   as c on c.company = a.CompanyCode
    left outer join I_Supplier         as d on d.Supplier = b.Supplier
{
  key a.FiscalYear,
  key a.CompanyCode,
  key a.AccountingDocument,
  key b.SourceLedger,
      a.DocumentDate,
      a.PostingDate,
      a.AccountingDocumentType,
      b.Supplier,
      concat(
          substring( cast( a.DocumentDate as abap.char(8) ), 5, 2 ),
          substring( cast( a.DocumentDate as abap.char(8) ), 1, 4 )
      )                 as Fiscalperiod,
      c.gstin           as Selfgstin,
      c.clientid,
      d.BPSupplierFullName,
      d.TaxNumber3      as SupGSTIN,
      case
          when ( b.Supplier is not initial and d.TaxNumber3 is not initial ) then 'B2B'
          when ( b.Supplier is not initial and d.TaxNumber3 is initial ) then 'B2BUR'
          else null end as TransType,
      abap.string'A'    as Resultflag

}
where
  (
       a.AccountingDocumentType = 'RE'
    or a.AccountingDocumentType = 'KR'
    or a.AccountingDocumentType = 'KG'
    or a.AccountingDocumentType = 'KA'
  );
