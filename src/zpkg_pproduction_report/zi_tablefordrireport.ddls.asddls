@EndUserText.label: 'Table for DRI report'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TableForDriReport
  as select from ZDT_DRI_PRD_REP
  association to parent ZI_TableForDriReport_S as _TableForDriReporAll on $projection.SingletonID = _TableForDriReporAll.SingletonID
{
  key MATERIAL as Material,
  MATERIALDESC as Materialdesc,
  PLANT as Plant,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForDriReporAll
}
