@EndUserText.label: 'Maintainance For Journal Entry Posting'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_MaintainanceForJour
  as select from ZDT_POSTING_MAIN
  association to parent ZI_MaintainanceForJour_S as _MaintainanceForJAll on $projection.SingletonID = _MaintainanceForJAll.SingletonID
{
  key PREFIX as Prefix,
  key I_PARAMETER as IParameter,
  E_VALUE as EValue,
  @Consumption.hidden: true
  1 as SingletonID,
  _MaintainanceForJAll
  
}
