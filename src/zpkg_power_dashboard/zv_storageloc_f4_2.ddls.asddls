@AbapCatalog.sqlViewName: 'ZVSLOCF4_2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Storage Location F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_STORAGELOC_F4_2
  as select from I_ProductStorageLocationBasic
{
  key    Product,
  key    Plant,
  key    StorageLocation
}
