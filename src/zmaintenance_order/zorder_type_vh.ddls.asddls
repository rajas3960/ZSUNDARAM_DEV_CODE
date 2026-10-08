@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Maintenance Order Type Value'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZORDER_TYPE_VH 
as select from I_OrderType
{
      @Search: { defaultSearchElement: true, ranking: #HIGH }
     // @ObjectModel.text.element:  [ 'MaintenanceOrderTypeName' ]
//  key I_OrderType.OrderType                                                  as MaintenanceOrderType,
////      @Search: { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8}
////      @EndUserText.label: 'Order Type Text'
////      @Semantics.text
//      I_OrderType._Text[1:Language = $session.system_language].OrderTypeName as MaintenanceOrderTypeName
//      
      key concat(
      concat(OrderType, ' - '),
      _Text[1:Language = $session.system_language].OrderTypeName
    ) as MaintenanceOrderType

}
//where  I_OrderType.OrderCategory = '30' //Maintenance Order 
