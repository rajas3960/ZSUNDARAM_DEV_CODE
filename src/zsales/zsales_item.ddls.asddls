@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER ITEM'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSALES_ITEM 
as select from I_SalesDocumentItem

{ 
   key SalesDocument,
   key SalesDocumentItem,
       Material,
       SalesDocumentItemText,
       Plant,
       BaseUnit,
       @Semantics.quantity.unitOfMeasure: 'BaseUnit'
       OrderQuantity
       
    
}
