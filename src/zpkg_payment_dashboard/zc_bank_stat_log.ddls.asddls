@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status log Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_bank_stat_log as projection on ZI_bank_stat_log
{
    @EndUserText.label: 'Accounting Doc'
  key Accountingdoc,
      @EndUserText.label: 'Fiscal Year'
  key Fiscalyear,
      @EndUserText.label: 'Company Code'
  key Companycode,
      @EndUserText.label: 'Approval Level'
  key Apprlevel,
      @EndUserText.label: 'Actioned By'
      Actionedby,
      @EndUserText.label: 'Actioned By Name'
      Name,
      @EndUserText.label: 'Actioned On'
      Actionedon,
      @EndUserText.label: 'Actioned At'
      Actionedat,
      @EndUserText.label: 'Action'
      Action,
      @EndUserText.label: 'Approver Comment'
      Apprcomment,
    /* Associations */
   _Head : redirected to parent ZC_bank_stat_head
}
