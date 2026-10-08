@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Plan'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INSPECTIONPLAN02 
  as select from I_InspPlnMatlAssgmtVersion_2 as a


{
  key a.Material,
  key a.Plant,
  key a.InspectionPlanGroup,
  key a.InspectionPlan,
      concat( InspectionPlanGroup, InspectionPlan ) as TGroup
}
where
  a.IsDeleted <> 'X'
