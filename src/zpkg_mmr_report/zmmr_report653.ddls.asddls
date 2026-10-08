@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Sales Return'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMMR_REPORT653 
  with parameters
    p_from_date : datum,

    p_to_date   : datum,
    p_plant     : werks_d
  as select from I_Product                as a
    inner join   I_MaterialDocumentItem_2 as b on  b.Material       = a.Product
                                               and b.Plant          = $parameters.p_plant
                                               and (
                                                  b.PostingDate     >= $parameters.p_from_date
                                                  and b.PostingDate <= $parameters.p_to_date
                                                )


{
  key a.Product                                               as material,
      cast(sum(b.QuantityInEntryUnit) as abap.dec(15,3) )     as GRReturnQty,
      cast(sum(b.TotalGoodsMvtAmtInCCCrcy) as abap.dec(15,3)) as GRReturnValue

}
where
  b.GoodsMovementType = '653'
group by
  a.Product
