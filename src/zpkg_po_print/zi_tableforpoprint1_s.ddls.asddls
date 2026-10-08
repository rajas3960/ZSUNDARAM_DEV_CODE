@EndUserText.label: 'TABLE FOR PO PRINT1 Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TableForPoPrint1All'
  }
}
define root view entity ZI_TableForPoPrint1_S
  as select from I_Language
    left outer join ZDT_POPRINT1 on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_TableForPoPrint1 as _TableForPoPrint1
{
  @UI.facet: [ {
    id: 'ZI_TableForPoPrint1', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TABLE FOR PO PRINT1', 
    position: 1 , 
    targetElement: '_TableForPoPrint1'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TableForPoPrint1,
  @UI.hidden: true
  max( ZDT_POPRINT1.LAST_CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
