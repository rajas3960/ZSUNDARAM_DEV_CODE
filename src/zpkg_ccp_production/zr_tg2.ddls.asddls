@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Captive power Generated (TG2)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TG2
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d

  as select from I_MfgOrderConfirmation as a
    inner join   I_WorkCenter           as b on  b.WorkCenterInternalID = a.WorkCenterInternalID
                                             and b.Plant                = a.Plant
                                             and b.WorkCenter           = 'TG2'
{
  key a.PostingDate,
  key a.Plant,
  key a.ProductionUnit,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      sum(a.ConfYieldQtyInProductionUnit) as tg2
}
where
      a.ManufacturingOrderType = 'ZPP'
  and a.Plant                  = $parameters.p_plant
  and a.IsReversal             is initial
  and a.PostingDate            >= $parameters.p_from_date
  and a.PostingDate            <= $parameters.p_to_date
group by
  a.PostingDate,
  a.ProductionUnit,
  a.Plant
//  as select from I_MfgOrderConfirmation as a
//    inner join   I_WorkCenter           as b on  b.WorkCenterInternalID = a.WorkCenterInternalID
//                                             and b.Plant                = a.Plant
//                                             and b.WorkCenter           = 'TG2'
//    inner join   I_GoodsMovementCube    as c on c.MaterialDocument      = a.MaterialDocument
//                                            and c.MaterialDocumentYear  = a.MaterialDocumentYear
//{
//  key a.PostingDate,
//  key a.Plant,
//      cast( sum(c.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14) ) as tg2
//}
//where
//       a.ManufacturingOrderType = 'ZPP'
//  and  a.Plant                  = $parameters.p_plant
//  and  a.PostingDate            >= $parameters.p_from_date
//  and  a.PostingDate            <= $parameters.p_to_date
//  and(
//       c.GoodsMovementType      = '101'
//    or c.GoodsMovementType      = '102'
//  )
//group by
//  a.PostingDate,
//  a.Plant
