@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PLANT_DATE as select distinct from ZI_PLANT as a
inner join ZI_DATE as b on a.joincond = b.joincond
{
    key a.Plant,
    key b.CalendarDate
}
