@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER HEADER PROJECTION VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZSALES_HDR_C provider contract transactional_query
as projection on ZSALES_HDR_I
{
    key SalesDocument,
    SalesDocumentDate,
    SalesDocumentDescription,
    SoldToParty,
    DistributionChannel,
    CreatedByUser,
    CreationDate,
    @Semantics.largeObject: {   mimeType: 'mimetype', 
                                fileName: 'filename', 
                                contentDispositionPreference: #INLINE }
    attachment,
    filename,
    mimetype,
    
    /* Associations */
    _item :redirected to composition child ZSALES_ITEM_C
}
