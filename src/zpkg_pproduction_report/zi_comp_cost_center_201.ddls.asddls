@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quantity of Movement Type 201'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_COMP_COST_CENTER_201
with parameters
 p_from_date : datum,
 
    p_to_date   : datum,
    p_plant     : werks_d
as select  from zdt_dri_prd_01  as A
inner join  I_ProductText                        as b on b.Product = A.material
left outer join I_GoodsMovementCube              as c on   ( c.PostingDate   >= $parameters.p_from_date and c.PostingDate <= $parameters.p_to_date )
                                                                                                                                                       and c.Plant              = $parameters.p_plant
                                                                                                                                                       and c.Material           =  A.material
                                                                                                                                                       and c.Plant = A.plant
                                                                                                                                                       and c.ManufacturingOrder = ''
{
     key A.material,
   
    key c.PostingDate as POSTINGDATE ,
    c.MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
     sum(c.TotalGdsMvtQtyInBaseUnit)   as COMP_COST_CENTER_201
}

where 
(c.GoodsMovementType = '201')
and A.plant = $parameters.p_plant
and ( c.CompanyCode = '2000' or  c.CompanyCode = '3000' or  c.CompanyCode = '4000')
group by
A.material,
c.PostingDate,
c.MaterialBaseUnit

