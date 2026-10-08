@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Item View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_GST_JVIT_VIEW1 
as select from ZPO_GST_JVIT_VIEW
{
    key FiscalYear,
    key SourceLedger,
    key CompanyCode,
    key AccountingDocument,
    key LedgerGLLineItem,
    TaxCode,
    InvoiceValue,
    CgstAmt,
    CgstRate,
    CgstType,
    SgstAmt,
    SgstRate,
    SgstType,
    IgstAmt,
    IgstRate,
    IgstType,
     cast(
              cast( InvoiceValue as abap.dec(15,2)) 
            + cast(coalesce(CgstAmt,0) as abap.dec(15,2))
            + cast(coalesce(SgstAmt,0) as abap.dec(15,2))
            + cast(coalesce(IgstAmt,0) as abap.dec(15,2))
        as abap.dec(15,2)) as TaxableValue
}
