@EndUserText.label: 'Sort of Reservation'
define table function ZR_RESERVATION_SORT

returns
{
  key mandt                          : abap.clnt;
      //  reservation        : abap.numc(10);
      //  reservationitem    : abap.numc(10);
      //  product            : matnr;
      //  baseunit           : meins;
      //  productdescription : abap.char(40);
      //  plant              : abap.char(4);
      //
      //  reqty              : abap.quan(13,3);
      //  issloc             : abap.char(4);
      //  recloc             : abap.char(4);
      //
      //  currstock          : abap.quan(13,3);
      //
      //  avgvalue           : dmbtr;
      //  waers              : waers;
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
  ZCL_RESV_SORT=>SORT;