//@AbapCatalog.sqlViewName: 'ZIINSPPLAN01'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Plan'
define view entity ZI_INSPECTIONPLAN01 

 as select from    I_InspPlnMatlAssgmtVersion_2 as a

    inner join      I_InspPlanOpCharcVersion_2   as b on  b.InspectionPlan      = a.InspectionPlan
                                                      and b.InspectionPlanGroup = a.InspectionPlanGroup
    left outer join I_UnitOfMeasureText          as c on  c.UnitOfMeasure = b.InspectionSpecificationUnit
                                                      and c.Language      = 'E'

{
  key a.Material,
  key a.Plant,
  key a.InspectionPlanGroup,
  key a.InspectionPlan,
  key b.InspectionSpecification,
      b.InspectionSpecificationText,
      b.InspSpecUpperLimit,
      b.InspSpecLowerLimit,
      b.InspectionSpecificationUnit,
      c.UnitOfMeasureTechnicalName as UnitOfMeasureName,
      b.InspSpecInformationField1,
      b.InspSpecInformationField2,
      b.InspSpecInformationField3,
      b.BOOCharacteristic
}
where
   b.IsDeleted <> 'X'
