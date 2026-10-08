@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Steam Fields Logic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_STEAM_WHRB
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
  as select from I_WorkCenter           as WC
    inner join   I_MfgOrderConfirmation as M on M.WorkCenterInternalID = WC.WorkCenterInternalID
    inner join I_GoodsMovementCube as GM on GM.MaterialDocument = M.MaterialDocument
                                        and GM.MaterialDocumentYear = M.MaterialDocumentYear
{
  key WC.WorkCenter,
  key M.PostingDate,
  cast( sum(GM.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14) ) as Qty
//      cast( M.ConfYieldQtyInProductionUnit as abap.dec(13,3) ) as ConfYieldQtyInProductionUnit
}
where
       WC.Plant                 = $parameters.p_plant
  and(
       WC.WorkCenter            = 'WHRB1'
    or WC.WorkCenter            = 'WHRB2'
    or WC.WorkCenter            = 'WHRB3'
    or WC.WorkCenter            = 'WHRB4'
    or WC.WorkCenter            = 'AFBC'
  )
  and  M.PostingDate            >= $parameters.p_from_date
  and  M.PostingDate            <= $parameters.p_to_date
  and  M.Plant                  = $parameters.p_plant
//  and  M.IsReversal             is initial
  and  M.ManufacturingOrderType = 'ZSTM'
  and ( GM.GoodsMovementType = '101' or GM.GoodsMovementType = '102' )
  
  group by WC.WorkCenter, M.PostingDate
