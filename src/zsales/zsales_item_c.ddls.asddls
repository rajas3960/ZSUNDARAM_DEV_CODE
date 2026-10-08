@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER ITEM CONSUMPTION'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZSALES_ITEM_C as projection on ZSALES_ITEM_I
{
    key SalesDocument,
    key SalesDocumentItem,
    Material,
    SalesDocumentItemText,
    Plant,
    BaseUnit,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    OrderQuantity,
    /* Associations */
    _header : redirected to parent ZSALES_HDR_C
}
