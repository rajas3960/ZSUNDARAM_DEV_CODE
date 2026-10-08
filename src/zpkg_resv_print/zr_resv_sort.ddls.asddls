@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation sort'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZR_RESV_SORT
returns
{
  key mandt                          : abap.clnt;
  key reservation                    : abap.char(10);
  key reservationitem                : abap.char(4);
      product                        : abap.char(40);
      productdescription             : abap.char(40);
      entryunit                      : abap.unit(3);
      resvnitmrequiredqtyinentryunit : abap.dec(13,3);
      goodsrecipientname             : abap.char(12);
      reservationitemtext            : abap.char(50);


}
implemented by method
  ZCL_RES_SORT=>SORT;