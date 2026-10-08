@EndUserText.label: 'Approval Matrix For Payments'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ApprovalMatrixForPa
  as select from ZTMG_APPR_MATRIX
  association to parent ZI_ApprovalMatrixForPa_S as _ApprovalMatrixFoAll on $projection.SingletonID = _ApprovalMatrixFoAll.SingletonID
{
  key COMPANYCODE as Companycode,
  key USERID as Userid,
  key APPRLEVEL as Apprlevel,
  key FINAL as Final,
  @Consumption.hidden: true
  1 as SingletonID,
  _ApprovalMatrixFoAll
}
