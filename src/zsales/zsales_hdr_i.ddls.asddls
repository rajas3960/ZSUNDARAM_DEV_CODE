@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER INTERFACE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSALES_HDR_I 
as select from ZSALES_HDR
composition [0..*] of ZSALES_ITEM_I as _item

{
key SalesDocument,
SalesDocumentDate,
SalesDocumentDescription,
SoldToParty,
DistributionChannel,
CreatedByUser,
CreationDate,
attachment,
filename,
mimetype,
_item
    
}
