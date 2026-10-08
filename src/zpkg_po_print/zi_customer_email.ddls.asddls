//@AbapCatalog.sqlViewName: 'ZVEMAILTB'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer email'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CUSTOMER_EMAIL
  as select from zdt_buspartemail
//                   (
//                   input_mandt : $session.client
//                   )
{
  key businesspartner,
      emailaddress
}
