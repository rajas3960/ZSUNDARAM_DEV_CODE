@EndUserText.label: 'CCP Production Report'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_CcpProductionReport
  as select from ZDT_CCP_PRD_REP
  association to parent ZI_CcpProductionReport_S as _CcpProductionRepAll on $projection.SingletonID = _CcpProductionRepAll.SingletonID
{
  key MATERIAL as Material,
  MATERIALDESC as Materialdesc,
  PLANT as Plant,
  @Consumption.hidden: true
  1 as SingletonID,
  _CcpProductionRepAll
}
