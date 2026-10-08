@EndUserText.label: 'Details for State Code'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DetailsForStateCode
  as select from zdt_statecode
  association        to parent ZI_DetailsForStateCode_S as _DetailsForStateCAll        on $projection.SingletonID = _DetailsForStateCAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText    as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key id                                                                                              as Id,
      state_code                                                                                      as StateCode,
      state_name                                                                                      as StateName,
      @ObjectModel.text.association: '_ConfignDeprecationCodeText'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_ConfignDeprecationCode',
          element: 'ConfigurationDeprecationCode'
        }
      } ]
      configdeprecationcode                                                                           as ConfigDeprecationCode,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                                                                 as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Consumption.hidden: true
      local_last_changed_at                                                                           as LocalLastChangedAt,
      @Consumption.hidden: true
      1                                                                                               as SingletonID,
      _DetailsForStateCAll,
      case when configdeprecationcode = 'W' then 2 when configdeprecationcode = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
      _ConfignDeprecationCodeText

}
