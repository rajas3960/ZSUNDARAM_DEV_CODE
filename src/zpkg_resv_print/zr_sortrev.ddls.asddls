@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sort'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SORTREV as select distinct from ZR_RESV_SORT
{
    key reservation,
    key reservationitem,
    product,
    productdescription,
    entryunit,
    resvnitmrequiredqtyinentryunit,
    goodsrecipientname,
    reservationitemtext
}
