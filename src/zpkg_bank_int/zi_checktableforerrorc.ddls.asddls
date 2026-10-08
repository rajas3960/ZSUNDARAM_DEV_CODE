@EndUserText.label: 'Check Table For Error Count'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_CheckTableForErrorC
  as select from ZDT_ERROR_COUNT
  association to parent ZI_CheckTableForErrorC_S as _CheckTableForErrAll on $projection.SingletonID = _CheckTableForErrAll.SingletonID
{
  key ERROR_COUNT as ErrorCount,
  @Consumption.hidden: true
  1 as SingletonID,
  _CheckTableForErrAll
  
}
