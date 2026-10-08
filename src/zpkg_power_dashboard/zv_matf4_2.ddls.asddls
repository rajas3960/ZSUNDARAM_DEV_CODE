@AbapCatalog.sqlViewName: 'ZVMAT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_MATF4_2
  as select from I_ManufacturingOrder     as a
//    inner join   I_BillOfMaterialItem as b on a.BillOfMaterial = b.BillOfMaterial
{
  key a.ManufacturingOrder
//      a.BillOfMaterial,
//      b.BillOfMaterialComponent as Material,
//      b.ComponentDescriptio    as MaterialDescription

}
//where
//  b.BillOfMaterialItemQuantity > 0
