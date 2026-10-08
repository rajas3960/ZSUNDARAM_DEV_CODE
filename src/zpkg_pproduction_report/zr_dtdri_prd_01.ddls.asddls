@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZDTDRI_PRD_01'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DTDRI_PRD_01
  as select from zdt_dri_prd_01
{
  key material as Material,
  key plant as Plant,
  materialdesc as Materialdesc,
  percentrecovery as percentrecovery,
  @Semantics.user.lastChangedBy: true
  changedby as Changedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchangetstmpl as Lastchangetstmpl,
  @Semantics.systemDateTime.lastChangedAt: true
  changetstmpl as Changetstmpl,
  @Semantics.user.createdBy: true
  createdby as Createdby
}
