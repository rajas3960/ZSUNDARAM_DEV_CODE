@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Appr Log'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_APPR_LOG
  as select from zdt_appr_log as a
  left outer join I_BusinessUserBasic as b
  on ( b.UserID = a.actionedby )
  association to parent ZI_PAYMENT_HEAD as _Head on  $projection.Companycode   = _Head.Companycode
                                                 and $projection.accountingdoc = _Head.Accountingdoc
                                                 and $projection.Fiscalyear    = _Head.Fiscalyear
{
  key a.accountingdoc as accountingdoc,
  key a.fiscalyear    as Fiscalyear,
  key a.companycode   as Companycode,
  key a.apprlevel     as Apprlevel,
      a.actionedby    as Actionedby,
      b.PersonFullName as Name,
      a.actionedon    as Actionedon,
      a.actionedat    as Actionedat,
      a.action        as Action,
      a.apprcomment   as Apprcomment,
      _Head // Make association public
}
