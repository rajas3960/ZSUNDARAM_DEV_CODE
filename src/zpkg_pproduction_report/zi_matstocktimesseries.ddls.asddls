@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATSTOCKTIMESSERIES 
as select from I_MaterialStockTimeSeries( P_StartDate: '20250401', P_EndDate: $session.system_date , P_PeriodType: 'D' )
{
    Material,
    Plant,
    EndDate,
    MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    sum(MatlWrhsStkQtyInMatlBaseUnit) as closingstock
}
group by  Material,
    Plant,
    EndDate,
    MaterialBaseUnit
