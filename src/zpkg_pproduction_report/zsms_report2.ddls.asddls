@AbapCatalog.sqlViewName: 'ZSMS_REP2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SMS Report2'
@Metadata.ignorePropagatedAnnotations: true
define view ZSMS_REPORT2 
with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d

as select from ZSMS_REPORT1 ( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date,p_plant:$parameters.p_plant ) as A
{
   A.postdate,
   A.material,
   A.MaterialBaseUnit,
//  A.BaseUnit,
  //  A.Uom,
   A.Captivepower,
   A.Gridpower,
   ( A.Captivepower * 1000 ) + A.Gridpower as TotalPower
    
}
