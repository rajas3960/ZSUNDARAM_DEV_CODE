@ObjectModel.query.implementedBy: 'ABAP:ZCL_PAYADV_BO_IMPL'
@EndUserText.label: 'Receipt Voucher'
define custom entity ZCE_PAYADV
{
  key accountingdoc           : belnr_d ;
  key fiscalyear              : gjahr ;
  key companycode             : bukrs ;
  paymentrunid                : laufi;
  documentdate                : bldat;
  postingdate                 : fis_budat;
  valuedate                   : datum;
  supplier                    : abap.char(10);
  suppliername                : abap.char(80);
  streetname                  : abap.char(80);
  cityname                    : abap.char(80);
  districtname                : abap.char(80);
  phonenumber1                : abap.char(10);
  taxnumber3                  : abap.char(10);
  email                       : abap.char(80);
  -- @Semantics.amount.currencyCode : 'ZCE_PAYADV.companycodecurrency'
  amountincompanycodecurrency : abap.dec(23,2);--dmbtr;
  companycodecurrency         : waers;
  paymentmethod               : abap.char(1);
  housebank                   : hbkid;
  housebankaccount            : hktid;
  bankname                    :abap.char(40);
  bankaccountnumber           : abap.char(40);
  payeebankaccount            : bankn;
  payeebankkey                : bankk;
  status                      : abap.char(20);
  utr                         : abap.char(30);
  _item  : association [1..*] to ZI_PAYADV_ITEM on $projection.accountingdoc = _item.AccountingDocument
                                                             and  $projection.fiscalyear = _item.FiscalYear
                                                             and  $projection.companycode = _item.CompanyCode;
}
