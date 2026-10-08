@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DT_NUMWORD
  as select from zdt_numword
{
  key num as Num,
  word as Word,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changes as LocalLastChanges,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed as LastChanged,
  @Semantics.user.createdBy: true
  creation_user as CreationUser,
  @Semantics.user.lastChangedBy: true
  change_user as ChangeUser
  
}
