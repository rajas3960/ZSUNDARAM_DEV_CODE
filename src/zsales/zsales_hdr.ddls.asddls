@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER HEADER'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSALES_HDR 
as select from I_SalesDocument as sd
left outer join zsales_table as table on table.salesdocument = sd.SalesDocument

{
   key sd.SalesDocument,
      sd.SalesDocumentDate,
      sd.SalesDocumentDescription,
      sd.SoldToParty,
      sd.DistributionChannel,
      sd.CreatedByUser,
      sd.CreationDate,
      table.attachment,
      table.filename,
      table.mimetype 
}
