@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Batch'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_stock_batch_value 
with parameters

    @Consumption.hidden: true
    @Environment.systemField: #SYSTEM_DATE
    P_KeyDate : sydate

  as select from I_ClfnObjectCharcValForKeyDate( P_KeyDate : $parameters.P_KeyDate )
{

  key left( I_ClfnObjectCharcValForKeyDate.ClfnObjectID, 40 )  as ValMat,
  key right( I_ClfnObjectCharcValForKeyDate.ClfnObjectID, 10 ) as ValBatch,
      ClfnObjectTable                                          as ClObTab,
      ClassType                                                as ClType,
      CharcInternalID                                          as CInId,
      CharcFromNumericValue                                    as CFrVal,
      CharcFromDecimalValue                                    as CFDVal,
      CharcValue                                               as CVal,
      CharcValuePositionNumber                                 as CVPosNo
}
group by
  I_ClfnObjectCharcValForKeyDate.ClfnObjectID,
  ClfnObjectTable,
  ClassType,
  CharcInternalID,
  CharcFromNumericValue,
  CharcFromDecimalValue,
  CharcValue,
  CharcValuePositionNumber
