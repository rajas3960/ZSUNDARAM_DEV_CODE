@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPV_PUR_HDR provider contract transactional_query as projection on ZPKG_PUR_HDR
{
    key Purchase_Order,
    key SupplierInvoice,
    key SupplierInvoiceItem,
    key Purchase_Order_Item,
    Material_Document,
    Material_Document_Year,
    Material_Document_Item,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    Quantity,
    MaterialBaseUnit,
    CompanyCode,
    Supplier,
    GoodsMovementType,
    DocumentDate,
    AccountingDocument,
    poCreationDate,
    Material,
    POitemtext,
    SupplierName,
    GLAccount,
    GLAccountName,
    GoodsMovementTypeName,
    MaterialDocumentHeaderText,
    GRNValue,
    /* Associations */
    _Item : redirected to composition child ZPV_PUR_ITM
}
