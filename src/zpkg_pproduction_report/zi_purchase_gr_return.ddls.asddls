@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase GR Return for the sms report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PURCHASE_GR_RETURN 
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
     sum(c.TotalGdsMvtQtyInBaseUnit)   as PURCHASE_GR_RETURN
}

where 
(c.GoodsMovementType = '122' or c.GoodsMovementType = '123')
and A.plant = $parameters.p_plant
group by
A.material,
c.PostingDate,
c.MaterialBaseUnit

