@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Table Function For Item Characterstics'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_ITEM
  with parameters
    @Environment.systemField: #CLIENT
    client : abap.clnt
returns
{
  key client           : abap.clnt;
  key id               : sysuuid_x16;
  key item             : sysuuid_x16;
      billingdoc       : abap.char(10);
      billingitem      : abap.char(4);
      batch            : abap.char(20);
      quantity         : abap.dec(21,2);
      charname         : abap.char(30);
      chardesc         : abap.char(50);
      maxlimit         : abap.dec(15,2);
      minlimit         : abap.dec(15,2);
      results          : abap.char(18);
      remarks          : abap.char(40);
      uom              : abap.char(4);
      uomname          : abap.char(10);
      test_method_text : abap.char(30);
      test_range       : abap.char(30);
}

implemented by method
  zcl_qlty_item_print=>sort_data;