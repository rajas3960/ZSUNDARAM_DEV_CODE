@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_DT_NUMWORD
  provider contract transactional_query
  as projection on ZR_DT_NUMWORD
{
  key Num,
  Word,
  LocalLastChanges,
  LastChanged,
  CreationUser,
  ChangeUser
  
}
