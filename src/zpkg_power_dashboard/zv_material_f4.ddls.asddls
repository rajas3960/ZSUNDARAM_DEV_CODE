@AbapCatalog.sqlViewName: 'ZVMATF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_MATERIAL_F4
  as select from    I_ManufacturingOrderItem as a
    left outer join I_ProductText            as b on a.Product = b.Product
{
  key a.ManufacturingOrder as productionOrder,
  key a.Product,
      b.ProductName
}
