@EndUserText.label: 'Tmg for converting amount to word'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForConvertingAmo
  as select from ZDT_WORDS
  association to parent ZI_TmgForConvertingAmo_S as _TmgForConvertingAll on $projection.SingletonID = _TmgForConvertingAll.SingletonID
{
  key ID as Id,
  NUM as Num,
  WORD as Word,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForConvertingAll
  
}
