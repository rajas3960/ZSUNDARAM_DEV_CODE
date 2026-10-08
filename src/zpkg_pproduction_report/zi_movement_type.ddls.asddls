@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Movement Types'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MOVEMENT_TYPE
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d

as select from zdt_dri_prd_01 as A

    inner join I_GoodsMovementCube as C
        on  C.Material = A.material
        and C.Plant    = A.plant

{
    key A.material,

    key C.PostingDate as PostingDate,
    key  C.GoodsMovementType,
        C.MaterialBaseUnit
       

}

where
        A.plant = $parameters.p_plant

    and C.Plant = $parameters.p_plant

    and C.PostingDate between
        $parameters.p_from_date and
        $parameters.p_to_date

  and (C.GoodsMovementType = '641' or C.GoodsMovementType = '201' or C.GoodsMovementType = '309' )

    and ( C.CompanyCode = '2000' or  C.CompanyCode = '3000' or  C.CompanyCode = '4000')
