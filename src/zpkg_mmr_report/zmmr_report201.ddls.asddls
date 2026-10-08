@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for General Consumption Qty & Value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMMR_REPORT201
  with parameters
    p_from_date : datum,

    p_to_date   : datum,
    p_plant     : werks_d
  as select from I_Product                as a
    inner join   I_MaterialDocumentItem_2 as b on  b.Material       = a.Product
                                               and b.Plant          = $parameters.p_plant
                                               and (
                                                  b.PostingDate     >= dats_add_days($parameters.p_from_date, 1, 'INITIAL')
                                                  and b.PostingDate <= dats_add_days($parameters.p_to_date, 1, 'INITIAL')
                                                )


{
  key a.Product                                               as material,
      cast(sum(b.QuantityInEntryUnit) as abap.dec(15,3) )     as GenConsumpQty,
      cast(sum(b.TotalGoodsMvtAmtInCCCrcy) as abap.dec(15,2)) as GenConsumpValue

}
where
  b.GoodsMovementType = '201'
group by
  a.Product
