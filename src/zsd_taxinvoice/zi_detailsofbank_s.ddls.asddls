@EndUserText.label: 'Details of Bank Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DetailsOfBankAll'
  }
}
define root view entity ZI_DetailsOfBank_S
  as select from I_Language
    left outer join zdt_bankdetails on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DetailsOfBank as _DetailsOfBank
{
  @UI.facet: [ {
    id: 'ZI_DetailsOfBank', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Details of Bank', 
    position: 1 , 
    targetElement: '_DetailsOfBank'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DetailsOfBank,
  @UI.hidden: true
  max( zdt_bankdetails.last_changed_at ) as LastChangedAtMax,
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
