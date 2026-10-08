@AbapCatalog.sqlViewName: 'ZIMAILPO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Email Id'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PO_MAIL
  as select from ZTBL_EMAIL
//                 (
//        //         input_mandt : $session.client   // -- 19.08.25
//        //           mandt : $session.client 
//                 )
{
  key businesspartner,
      emailaddress
}
