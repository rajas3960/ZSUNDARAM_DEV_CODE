@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Main Workcenter Plant Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZMAINWORK_CENTER_PLANT_VH 
as select from I_MaintenanceOrderBasic
{
   @Search: { defaultSearchElement: true, ranking: #HIGH }
    key MaintenanceOrder,
    I_MaintenanceOrderBasic.MainWorkCenterPlant
    
}
