@EndUserText.label: 'Plant Details Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'PlantDetailsAll'
  }
}
define root view entity ZI_PlantDetails_S
  as select from I_Language
    left outer join zdt_plantdetails on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_PlantDetails as _PlantDetails
{
  @UI.facet: [ {
    id: 'ZI_PlantDetails', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Plant Details', 
    position: 1 , 
    targetElement: '_PlantDetails'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _PlantDetails,
  @UI.hidden: true
  max( zdt_plantdetails.last_changed_at ) as LastChangedAtMax,
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
