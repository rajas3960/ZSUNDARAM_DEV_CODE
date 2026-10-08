@EndUserText.label: 'TABLE FOR PO PRINT Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TableForPoPrintAll'
  }
}
define root view entity ZI_TableForPoPrint_S
  as select from I_Language
    left outer join zdt_poprint on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TableForPoPrint as _TableForPoPrint
{
  @UI.facet: [ {
    id: 'ZI_TableForPoPrint', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TABLE FOR PO PRINT', 
    position: 1 , 
    targetElement: '_TableForPoPrint'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TableForPoPrint,
  @UI.hidden: true
  max( zdt_poprint.last_changed_at ) as LastChangedAtMax,
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
