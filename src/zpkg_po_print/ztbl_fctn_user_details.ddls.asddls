@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table Fn for User details'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_USER_DETAILS
//    with parameters                                    // --
//      @Environment.systemField: #CLIENT
//      mandt : abap.clnt
returns
{
  key mandt                   : abap.clnt;
  key businesspartner         : abap.char( 10 );
      emailaddress            : abap.char( 255 );
      completetelephonenumber : abap.char( 30 );
}
implemented by method
  zcl_po_det=>get_data;