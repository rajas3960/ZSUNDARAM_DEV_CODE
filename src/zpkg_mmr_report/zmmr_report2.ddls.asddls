@AbapCatalog.sqlViewName: 'ZMMR_REP2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MMR Report 2'
@Metadata.ignorePropagatedAnnotations: true
define view ZMMR_REPORT2 
with parameters
  p_from_date : datum,
 
    p_to_date   : datum,
    p_plant     : werks_d
as select from I_Product as a
inner join  I_MaterialDocumentItem_2 as b on b.Material = a.Product
                                            and b.Plant = $parameters.p_plant
                                           // and b.GoodsMovementType = '101' or b.GoodsMovementType = '531'
                                           // and b.OrderID <> ''
                                            and (b.PostingDate  >= $parameters.p_from_date and b.PostingDate <= $parameters.p_to_date )


{
    key a.Product as material,
  //  key b.PostingDate as p_fromdate,
    sum(b.QuantityInEntryUnit) as PrdQty,
   b.CompanyCodeCurrency,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(b.TotalGoodsMvtAmtInCCCrcy) as Prdvalue
    
}
where 
b.OrderID is not initial
 and b.GoodsMovementType = '101' or b.GoodsMovementType = '531'
group by
a.Product,
b.CompanyCodeCurrency
//b.PostingDate
