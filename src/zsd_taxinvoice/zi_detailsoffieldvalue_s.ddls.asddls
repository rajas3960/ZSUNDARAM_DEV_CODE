@EndUserText.label: 'Details of Field value Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DetailsOfFieldVaAll'
  }
}
define root view entity ZI_DetailsOfFieldValue_S
  as select from I_Language
    left outer join zdt_fieldvalue on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DetailsOfFieldValue as _DetailsOfFieldValue
{
  @UI.facet: [ {
    id: 'ZI_DetailsOfFieldValue', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Details of Field value', 
    position: 1 , 
    targetElement: '_DetailsOfFieldValue'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DetailsOfFieldValue,
  @UI.hidden: true
  max( zdt_fieldvalue.last_changed_at ) as LastChangedAtMax,
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
