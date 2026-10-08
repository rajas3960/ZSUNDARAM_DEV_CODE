@EndUserText.label: 'Reservation Print'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_RES_ITMPRINT
  //  as select from ZR_RESVITEMS
  as select distinct from ZR_SORTREV
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
