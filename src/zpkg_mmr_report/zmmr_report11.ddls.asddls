@AbapCatalog.sqlViewName: 'ZMMR_REP11'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MMR Report11'
@Metadata.ignorePropagatedAnnotations: true
define view ZMMR_REPORT11 
with parameters
  p_from_date : datum,
 
    p_to_date   : datum,
    p_plant     : werks_d
as select from I_Product as a
inner join       I_MaterialStockTimeSeries( P_StartDate: $parameters.p_from_date , P_EndDate: $parameters.p_to_date , P_PeriodType: 'D') as B on B.Material = a.Product
{
    key a.Product as MATERIAL,
    key B.EndDate as enddate,
    case 
    when B.EndDate  = $parameters.p_to_date
    then sum(B.MatlWrhsStkQtyInMatlBaseUnit) 
    end as closingQTY
}
where B.Plant = $parameters.p_plant
group by
a.Product,
B.EndDate
