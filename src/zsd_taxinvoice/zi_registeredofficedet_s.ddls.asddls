@EndUserText.label: 'Registered Office Details Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'RegisteredOfficeAll'
  }
}
define root view entity ZI_RegisteredOfficeDet_S
  as select from I_Language
    left outer join zdt_regoffice on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_RegisteredOfficeDet as _RegisteredOfficeDet
{
  @UI.facet: [ {
    id: 'ZI_RegisteredOfficeDet', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Registered Office Details', 
    position: 1 , 
    targetElement: '_RegisteredOfficeDet'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _RegisteredOfficeDet,
  @UI.hidden: true
  max( zdt_regoffice.last_changed_at ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as sxco_transport) as TransportRequestID,
  _ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
