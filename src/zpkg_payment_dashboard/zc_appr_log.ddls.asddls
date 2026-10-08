@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection ~ Approver Log'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass:#MIXED
@Analytics.dataCategory: #CUBE
define view entity ZC_APPR_LOG
  as projection on ZI_APPR_LOG
{
      @EndUserText.label: 'Accounting Doc'
  key accountingdoc,
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
      _Head : redirected to parent ZC_PAY_HEADER
}
