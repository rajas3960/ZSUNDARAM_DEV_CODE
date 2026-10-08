@AbapCatalog.sqlViewName: 'ZVTURBINE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Turbine F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_TURNBINE_F4
  as select from    I_WorkCenterStdVH as a
    left outer join I_WorkCenterText  as b on a.WorkCenterInternalID = b.WorkCenterInternalID
{
  key   a.WorkCenter     as Turbine,
  key   a.Plant          as plant,
  key   b.WorkCenterText as Description
}

where
  a.WorkCenterCategoryCode = '0001'
