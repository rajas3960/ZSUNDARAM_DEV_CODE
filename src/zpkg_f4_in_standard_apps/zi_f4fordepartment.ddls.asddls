@EndUserText.label: 'F4 For Department'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_F4ForDepartment
  as select from ZDT_DEPT_VALUE
  association to parent ZI_F4ForDepartment_S as _F4ForDepartmentAll on $projection.SingletonID = _F4ForDepartmentAll.SingletonID
{
  key DEPT_NAME as DeptName,
  @Consumption.hidden: true
  1 as SingletonID,
  _F4ForDepartmentAll
  
}
