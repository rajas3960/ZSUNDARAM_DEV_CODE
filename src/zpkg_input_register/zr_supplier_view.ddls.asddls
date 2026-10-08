@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Supplier Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_SUPPLIER_VIEW 
as select from I_JournalEntry as a 
inner join I_JournalEntryItem as b on b.CompanyCode = a.CompanyCode
                                    and b.AccountingDocument = a.AccountingDocument
                                    and b.FiscalYear = a.FiscalYear
                                    and b.Ledger = '0L'
left outer join I_Supplier as c on c.Supplier = b.Supplier
{
    key b.CompanyCode,
    key b.FiscalYear,
    key b.AccountingDocument,
        b.Supplier,
        c.BPSupplierFullName,
        c.TaxNumber3
        
}
where b.Supplier is not initial
group by b.CompanyCode,
         b.FiscalYear,
         b.AccountingDocument,
         b.Supplier,
         c.BPSupplierFullName,
         c.TaxNumber3
         

