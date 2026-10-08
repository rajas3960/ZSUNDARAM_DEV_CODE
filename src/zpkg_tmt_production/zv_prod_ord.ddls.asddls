@AbapCatalog.sqlViewName: 'ZZVPRODTMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_PROD_ORD
  as select from I_ManufacturingOrderItem
{
  key ManufacturingOrder,
      ProductionPlant
}
where
      ManufacturingOrderType = 'ZTMT'
  and(
      ProductionPlant        = '2008'
  )
  and OrderIsReleased        = 'X'

  and IsMarkedForDeletion    = ''
