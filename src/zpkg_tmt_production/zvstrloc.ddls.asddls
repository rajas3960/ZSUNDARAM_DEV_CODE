@AbapCatalog.sqlViewName: 'ZVSLLCOF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Storage Location'
@Metadata.ignorePropagatedAnnotations: true
define view ZVSTRLOC
  as select from I_ProductStorageLocationBasic
{
  key Product,
  key Plant,
  key StorageLocation as SLOC

}
