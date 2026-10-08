@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit-Debit Note Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZFI_ITEM_PV 
as projection on ZFI_ITEM_RV
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    AccountingDocumentItem,
    Plant,
    @ObjectModel.text.element: [ 'GLAccountLongName' ]
    GLAccount,
    GLAccountLongName,
    CompanyCodeCurrency,
    TaxableValue,
    TaxCode,
    TaxItemGroup,
    CgstAmt,
    @ObjectModel.text.element: [ 'CgstRate' ]
    CgstRateRatio,
    CgstRate,
    SgstAmt,    
    @ObjectModel.text.element: [ 'SgstRate' ]
    SgstRateRatio,
    SgstRate,
    IgstAmt,
    @ObjectModel.text.element: [ 'IgstRate' ]
    IgstRateRatio,
    IgstRate,
    /* Associations for Purchase */
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
    /* Associations  */
    _Head : redirected to parent ZFI_HEAD_PV
}
