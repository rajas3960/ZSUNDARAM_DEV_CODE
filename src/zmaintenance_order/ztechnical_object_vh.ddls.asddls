@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Technical Object Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZTECHNICAL_OBJECT_VH 
as select from I_MaintOrderComponentDEX

{
    @Search: { defaultSearchElement: true, ranking: #HIGH }
    key Reservation,
    key ReservationItem,
    key ReservationType,
       Equipment as TechnicalObject
}
