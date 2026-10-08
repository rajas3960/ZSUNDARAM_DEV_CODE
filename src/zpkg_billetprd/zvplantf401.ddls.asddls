@AbapCatalog.sqlViewName: 'ZBILLETPLANT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant F4 for Billet Dashbaord'
@Metadata.ignorePropagatedAnnotations: true
define view ZVPLANTF401
  as select from I_Plant
{
  key Plant,
      PlantName,
      ValuationArea,
      BusinessPlace
}
where
     Plant = '1005'
  or Plant = '2005'
