@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MMR Report3 102'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMMR_REPORT3_NEG
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

      sum(cast(b.QuantityInEntryUnit as abap.dec( 15, 3 ) ) ) as PurchaseQty,
      b.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(b.TotalGoodsMvtAmtInCCCrcy)                         as Purchasevalue
}
where
      b.PurchaseOrder     is not initial
  and b.GoodsMovementType = '102'
group by
  a.Product,
  b.CompanyCodeCurrency
