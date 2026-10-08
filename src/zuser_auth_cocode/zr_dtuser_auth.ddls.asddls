@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZDTUSER_AUTH'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DTUSER_AUTH
  as select from ZDT_USER_AUTH
{
  key id as ID,
  cbuser as Cbuser,
  companycode as Companycode,
  @Semantics.user.lastChangedBy: true
  changedby as Changedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchangetstmpl as Lastchangetstmpl,
  @Semantics.systemDateTime.lastChangedAt: true
  changetstmpl as Changetstmpl,
  @Semantics.user.createdBy: true
  createdby as Createdby
}
