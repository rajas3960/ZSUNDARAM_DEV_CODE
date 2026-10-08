@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Form Output Item View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_ITEM_OUT 
as select from ZFI_ITEM_VIEW
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

//"Association for Purchase order"
PurchaseOrder,
PurchaseOrderItem,
Material,
PurchaseOrderItemText,
HSNCode,
BaseUnit,
@Semantics.quantity.unitOfMeasure: 'BaseUnit'
OrderQuantity,
Rate,
Amount
    
}
