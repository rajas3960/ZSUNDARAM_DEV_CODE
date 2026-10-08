@AbapCatalog.sqlViewName: 'ZDR_REP2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DRI REPORT'
@Metadata.ignorePropagatedAnnotations: true
define view ZDR_REPORT2 
with parameters
  p_from_date : datum,
 
    p_to_date   : datum,
    p_plant     : werks_d
as select  from zdt_dri_prd_01  as A
inner join  I_ProductText                                                                                                           as b on b.Product = A.material
inner join       I_MaterialStockTimeSeries( P_StartDate: $parameters.p_from_date , P_EndDate: $parameters.p_to_date , P_PeriodType: 'D') as c on c.Material = A.material
and c.Plant = $parameters.p_plant
{
    key A.material,
    key dats_add_days( c.EndDate , 1 , 'NULL' ) as POSTINGDATE,
  c.MaterialBaseUnit,
  
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    sum(c.MatlWrhsStkQtyInMatlBaseUnit)   as OPENING
}
where A.plant = $parameters.p_plant
group by 
A.material,
c.EndDate,
c.MaterialBaseUnit
