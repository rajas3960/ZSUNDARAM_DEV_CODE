@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status log'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_bank_stat_log as select from zdt_appr_log as a
  left outer join I_BusinessUserBasic as b
  on ( b.UserID = a.actionedby )
  association to parent ZI_bank_stat_head as _Head on  $projection.Companycode   = _Head.Companycode
                                                  and $projection.Accountingdoc = _Head.Accountingdoc
                                                  and $projection.Fiscalyear    = _Head.Fiscalyear
{
    key a.accountingdoc as Accountingdoc,
    key a.fiscalyear as Fiscalyear,
    key a.companycode as Companycode,
    key a.apprlevel as Apprlevel,
    a.supplier as Supplier,
    a.actionedby as Actionedby,
    b.PersonFullName as Name,
    a.actionedon as Actionedon,
    a.actionedat as Actionedat,
    a.action as Action,
    a.apprcomment as Apprcomment,
     _Head // Make association public
}
