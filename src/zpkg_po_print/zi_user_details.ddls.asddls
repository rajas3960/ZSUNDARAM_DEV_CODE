@AbapCatalog.sqlViewName: 'ZVUSERDET'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for User details'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_USER_DETAILS
  as select from ZTBL_FCTN_USER_DETAILS
//                 (
//                 mandt : $session.client
//                 )
{
  key businesspartner,
      completetelephonenumber,
      emailaddress
}
