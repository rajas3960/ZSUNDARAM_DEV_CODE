@AbapCatalog.sqlViewName: 'ZZVVDEPTF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZVDEPTF4
  as select distinct from I_ManufacturingOrderOperation as a
    inner join            I_WorkCenterStdVH             as b on a.WorkCenterInternalID = b.WorkCenterInternalID
{
  key    ManufacturingOrder,
  key    b.WorkCenter as department
}
where
  a.ManufacturingOrderType = 'ZTMT'
