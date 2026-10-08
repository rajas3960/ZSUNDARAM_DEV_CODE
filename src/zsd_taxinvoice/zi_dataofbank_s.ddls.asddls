@EndUserText.label: 'Data of Bank Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DataOfBankAll'
  }
}
define root view entity ZI_DataOfBank_S
  as select from I_Language
    left outer join zdt_bankdata on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DataOfBank as _DataOfBank
{
  @UI.facet: [ {
    id: 'ZI_DataOfBank', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Data of Bank', 
    position: 1 , 
    targetElement: '_DataOfBank'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DataOfBank,
  @UI.hidden: true
  max( zdt_bankdata.last_changed_at ) as LastChangedAtMax,
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
