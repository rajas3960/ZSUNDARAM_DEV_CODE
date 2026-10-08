@EndUserText.label: 'Details for State Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DetailsForStateCAll'
  }
}
define root view entity ZI_DetailsForStateCode_S
  as select from    I_Language
    left outer join zdt_statecode on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_DetailsForStateCode     as _DetailsForStateCode
{
      @UI.facet: [ {
        id: 'ZI_DetailsForStateCode',
        purpose: #STANDARD,
        type: #LINEITEM_REFERENCE,
        label: 'Details for State Code',
        position: 1 ,
        targetElement: '_DetailsForStateCode'
      } ]
      @UI.lineItem: [ {
        position: 1
      } ]
  key 1                                    as SingletonID,
      _DetailsForStateCode,
      @UI.hidden: true
      max( zdt_statecode.last_changed_at ) as LastChangedAtMax,
      @ObjectModel.text.association: '_ABAPTransportRequestText'
      @UI.identification: [ {
        position: 2 ,
        type: #WITH_INTENT_BASED_NAVIGATION,
        semanticObjectAction: 'manage'
      } ]
      @Consumption.semanticObject: 'CustomizingTransport'
      cast( '' as sxco_transport)          as TransportRequestID,
      _ABAPTransportRequestText

}
where
  I_Language.Language = $session.system_language
