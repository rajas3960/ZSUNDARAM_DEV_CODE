@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View:ZingHR Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ZINGHR_HDR
  as select from zdt_zinghr_hdr
  composition [0..*] of ZI_ZINGHR_ITM as _Item
{
  key    companycode       as Companycode,
  key    payrollrunid      as Payrollrunid,
  key    payrollrundate    as Payrollrundate,
         payrollrunremarks as Payrollrunremarks,
         last_changed_at   as LastChangedAt,

         _Item
}
