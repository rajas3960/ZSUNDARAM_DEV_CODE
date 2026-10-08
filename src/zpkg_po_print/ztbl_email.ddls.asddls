@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table Fn for EMail'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_EMAIL 
//with parameters
//    @Environment.systemField: #CLIENT
//    mandt : abap.clnt                              //--19.08.25 by sp
returns
{
  key mandt                   : abap.clnt;
  key businesspartner         : abap.char( 10 );
      emailaddress            : abap.char( 50 );

}
implemented by method
  zcl_po_email=>get_data;