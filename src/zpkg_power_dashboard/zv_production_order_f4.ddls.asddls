@AbapCatalog.sqlViewName: 'ZVPRDODR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production order F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_PRODUCTION_ORDER_F4
  as select distinct from I_ManufacturingOrderItem as a

    inner join            I_MfgOrderWithStatus     as b on b.ManufacturingOrder = a.ManufacturingOrder
{
  key a.ManufacturingOrder,
  key a.PlanningPlant
}
where
      a.ManufacturingOrderType      = 'ZPP'
  and a.OrderIsReleased             = 'X'
  and b.OrderIsTechnicallyCompleted = ''
