@AbapCatalog.sqlViewName: 'ZVPRODORDF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZVPRODF4

  as select from I_ManufacturingOrderItem as a

    inner join   I_MfgOrderWithStatus     as b on b.ManufacturingOrder = a.ManufacturingOrder

{
  key a.ManufacturingOrder,
  key ManufacturingOrderItem,
      a.ManufacturingOrderType,
      a.Product,
      a.ProductionPlant,
      a.MRPController
}
where
       a.ManufacturingOrderType      = 'ZBIL'
  and(
       a.ProductionPlant             = '1005'
    or a.ProductionPlant             = '2005'
  )
  and  a.OrderIsReleased             = 'X'

  and  b.OrderIsTechnicallyCompleted = ''

  and  a.IsMarkedForDeletion         = ''
