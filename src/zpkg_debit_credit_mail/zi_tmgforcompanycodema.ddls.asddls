@EndUserText.label: 'TMG for company code mail IDs'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForCompanyCodeMa
  as select from ZDT_COMP_MAILID
  association to parent ZI_TmgForCompanyCodeMa_S as _TmgForCompanyCodAll on $projection.SingletonID = _TmgForCompanyCodAll.SingletonID
{
  key COMPANYCODE as Companycode,
  PURCHASE as Purchase,
  ACCOUNTS as Accounts,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForCompanyCodAll
}
