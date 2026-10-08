@AbapCatalog.sqlViewName: 'ZVPLNTNAMEF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant name f4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_PLANTNAME_F4
  as select from I_CnsldtnPlantT as a
    inner join   ZV_PLANT_F4     as b on a.Plant = b.value_low
{
  key a.Plant,
      a.PlantName as Plantname
}
