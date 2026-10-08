@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Center Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZCOST_CENTER_VH 
as select from I_MaintOrderComponentDEX
{
   @Search: { defaultSearchElement: true, ranking: #HIGH }
    key Reservation,
    key ReservationItem,
    key ReservationType,
    ResponsibleCostCenter as Costcenter
}
