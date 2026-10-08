@EndUserText.label: 'TMG for company code mail IDs Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgForCompanyCodAll'
  }
}
define root view entity ZI_TmgForCompanyCodeMa_S
  as select from I_Language
    left outer join ZDT_COMP_MAILID on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TmgForCompanyCodeMa as _TmgForCompanyCodeMa
{
  @UI.facet: [ {
    id: 'ZI_TmgForCompanyCodeMa', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG for company code mail IDs', 
    position: 1 , 
    targetElement: '_TmgForCompanyCodeMa'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgForCompanyCodeMa,
  @UI.hidden: true
  max( ZDT_COMP_MAILID.LAST_CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 1 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
