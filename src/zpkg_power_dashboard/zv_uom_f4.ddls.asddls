@AbapCatalog.sqlViewName: 'ZVUOM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UOM f4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_UOM_F4
  as select from    I_Product                     as a
    left outer join I_ProductStorageLocationBasic as b on a.Product = b.Product
{
  key  a.Product,
       a.BaseUnit,
       b.StorageLocation
}
