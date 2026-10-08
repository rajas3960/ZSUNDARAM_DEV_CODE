@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER ITEM INTERFACE'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSALES_ITEM_I 
as select from ZSALES_ITEM
association to parent ZSALES_HDR_I as _header on $projection.SalesDocument = _header.SalesDocument

{
    key SalesDocument,
    key SalesDocumentItem,
    Material,
    SalesDocumentItemText,
    Plant,
    BaseUnit,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    OrderQuantity,
    _header
}
