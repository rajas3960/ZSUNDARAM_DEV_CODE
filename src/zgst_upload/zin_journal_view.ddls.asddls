@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Invoice'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZIN_JOURNAL_VIEW 
as select from I_JournalEntry as a
inner join I_JournalEntryItem as b on a.CompanyCode = b.CompanyCode
                                    and a.FiscalYear = b.FiscalYear
                                    and a.AccountingDocument = b.AccountingDocument
                                    and b.Ledger = '0L'
{
 key b.CompanyCode,
 key b.FiscalYear,
 key b.AccountingDocument,
 key b.LedgerGLLineItem,
     b.AccountingDocumentItem,
     a.AccountingDocumentType,
     b.ReferenceDocument,
     b.ReferenceDocumentItem,
     b.GLAccountType,
     a.PostingDate,
     a.OriginalReferenceDocument as orignalinvoiceno,
    concat(
    substring( cast( a.DocumentDate as abap.char(8) ), 5, 2 ),
    substring( cast( a.DocumentDate as abap.char(8) ), 1, 4 )
) as MonthYear
        
}
where a.AccountingDocumentType = 'RV'
and b.GLAccountType = 'P'

