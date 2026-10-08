@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZPV_PUR_ITM as projection on ZPKG_PUR_ITM
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    key SupplierInvoice,
    key SupplierInvoiceItem,
    PricingDocument,
    PricingDocumentItem,
    PricingProcedureStep,
    PricingProcedureCounter,
    Supplier1,
    CompanyCode,
    PurchaseOrderQuantityUnit,
    FreightSupplier,
    TransactionCurrency,
    SuplrInvcDeliveryCostCndnType,
    SupplierInvoice1,
    FreightSupplierName,
    SupplierName1,
    InvoicingParty,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    UnplannedDeliveryCost,
    ConditionTypeName,
    FrghtGLAccount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    AmountInCompanyCodeCurrency,
    /* Associations */
    _Hdr : redirected to parent ZPV_PUR_HDR
}
