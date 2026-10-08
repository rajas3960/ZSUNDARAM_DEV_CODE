@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Issue Transfer 302 IN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMMR_REPORT302_IN 
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
      cast(sum(b.QuantityInEntryUnit) as abap.dec(15,3) )     as GITransferQty,
      cast(sum(b.TotalGoodsMvtAmtInCCCrcy) as abap.dec(15,3)) as GITransferValue

}
where
      b.DebitCreditCode   = 'H'
  and b.GoodsMovementType = '302'
group by
  a.Product
