@AbapCatalog.sqlViewName: 'ZVPRDODRF42'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_PRODUCTION_ORDER_F4_2
  as select from I_ManufacturingOrderItem as a

    inner join   I_MfgOrderWithStatus     as b on b.ManufacturingOrder = a.ManufacturingOrder
{
  key  a.ManufacturingOrder,
       a.PlanningPlant
}
where
  (
       a.ManufacturingOrderType      = 'ZBIL'
    or a.ManufacturingOrderType      = 'ZTMT'
    or a.ManufacturingOrderType      = 'ZPP'
    or a.ManufacturingOrderType      = 'ZFAB'
    or a.ManufacturingOrderType      = 'ZDRI'
  )
  and  a.OrderIsReleased             = 'X'

  and  b.OrderIsTechnicallyCompleted = ''
