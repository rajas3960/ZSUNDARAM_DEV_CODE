@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KILN1 Production'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PROD_KILN3  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
    as select from I_WorkCenter as a 
    inner join zdt_dri_prd_01  as c on a.Plant = c.plant
    inner join I_MfgOrderConfirmation as b on a.Plant = b.Plant
    and a.WorkCenterInternalID = b.WorkCenterInternalID
    and b.ManufacturingOrderType = 'ZDRI'
   // and b.IsReversal is initial
     inner join   I_GoodsMovementCube    as e on  (
        e.PostingDate                                       >= $parameters.p_from_date
        and e.PostingDate                                   <= $parameters.p_to_date
      )
                                             and e.Plant    = $parameters.p_plant
                                             and e.Material = c.material
                                            and e.MaterialDocument = b.MaterialDocument
                                            and e.MaterialDocumentYear = b.MaterialDocumentYear
                                            and ( e.GoodsMovementType = '101' or e.GoodsMovementType = '531' or e.GoodsMovementType = '102' or e.GoodsMovementType = '532' )
{
    key b.PostingDate,
    key e.Material,
    e.MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(e.TotalGdsMvtQtyInBaseUnit) as qty
}
where a.Plant = $parameters.p_plant
and a.WorkCenter = 'KILN3'
and ( b.PostingDate >= $parameters.p_from_date and b.PostingDate <= $parameters.p_to_date )
group by b.PostingDate,
e.MaterialBaseUnit,
e.Material

