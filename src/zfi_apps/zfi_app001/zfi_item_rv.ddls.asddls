@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit-Debit Note Item Root View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_ITEM_RV 
as select from ZFI_ITEM_VIEW
association to parent ZFI_HEAD_RV as _Head on $projection.AccountingDocument = _Head.AccountingDocument
                                        and $projection.CompanyCode = _Head.CompanyCode
                                        and $projection.FiscalYear = _Head.FiscalYear
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    AccountingDocumentItem,
    Plant,
    GLAccount,
    GLAccountLongName,
    CompanyCodeCurrency,
    TaxableValue,
    TaxCode,
    TaxItemGroup,
    CgstAmt,
    CgstRate,
    CgstRateRatio,
    SgstAmt,
    SgstRate,
    SgstRateRatio,
    IgstAmt,
    IgstRate,
    IgstRateRatio,
    InvoiceReference,

//""Association for Purchase
    PurchaseOrder,
    PurchaseOrderItem,
    Material,
    PurchaseOrderItemText,
    HSNCode,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    OrderQuantity,
    BaseUnit,
    Rate,
    Amount,    
    _Head
}
