@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KILN1 Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CONS_KILN1
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
  as select from I_WorkCenter           as a
    
    inner join   I_MfgOrderConfirmation as b on  a.Plant                  = b.Plant
                                             and a.WorkCenterInternalID   = b.WorkCenterInternalID
                                             and b.ManufacturingOrderType = 'ZDRI'
  and(
        b.PostingDate >= $parameters.p_from_date
    and b.PostingDate <= $parameters.p_to_date
  )
                                         //   and b.IsReversal             is initial
    inner join   I_GoodsMovementCube    as d on  (
        d.PostingDate                                       >= $parameters.p_from_date
        and d.PostingDate                                   <= $parameters.p_to_date
      )
                                             and d.Plant    = $parameters.p_plant
//                                             and d.Material = c.material
                                            and d.MaterialDocument = b.MaterialDocument
                                            and d.MaterialDocumentYear = b.MaterialDocumentYear
                                            and ( d.GoodsMovementType = '261' or d.GoodsMovementType = '262' )
  inner join   zdt_dri_prd_01         as c on a.Plant = c.plant
  and c.material = d.Material

{
  key b.PostingDate,
  key d.Material,
      d.MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(d.TotalGdsMvtQtyInBaseUnit) as qty
}
where
        a.Plant       = $parameters.p_plant
  and   a.WorkCenter  = 'KILN1'

group by
  b.PostingDate,
  d.MaterialBaseUnit,
  d.Material
