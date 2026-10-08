@AbapCatalog.sqlViewName: 'ZDR_REP8'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DRI REPORT 8'
@Metadata.ignorePropagatedAnnotations: true
define view ZDR_REPORT8

  with parameters
    p_from_date : datum,

    p_to_date   : datum,
    p_plant     : werks_d
  as select from    zdt_dri_prd_01      as A
    inner join      I_ProductText       as b on b.Product = A.material
    left outer join I_GoodsMovementCube as c on  (
        c.PostingDate                                       >= $parameters.p_from_date
        and c.PostingDate                                   <= $parameters.p_to_date
      )
                                             and c.Plant    = $parameters.p_plant
                                             and c.Material = A.material
                                             and c.Plant    = A.plant


{
  key A.material,
  key c.PostingDate                   as POSTINGDATE,
      c.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(c.TotalGdsMvtQtyInBaseUnit) as SALES
}
where
  (
       c.GoodsMovementType = '602'
    or c.GoodsMovementType = '601'
  )
  and  A.plant             = $parameters.p_plant
group by
  A.material,
  c.PostingDate,
  c.MaterialBaseUnit
