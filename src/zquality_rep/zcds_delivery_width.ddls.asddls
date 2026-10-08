@AbapCatalog.sqlViewName: 'ZCDS_DEL_WDTH'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS VIEW FOR WIDTH AGAINST DELIVERY'
define view ZCDS_DELIVERY_WIDTH
  as select from I_DeliveryDocumentItem
{
  DeliveryDocument,
  count(distinct YY1_ITEM_VC_WIDTH_DLI) as DelCount
}
group by
  DeliveryDocument
