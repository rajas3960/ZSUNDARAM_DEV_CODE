@AbapCatalog.sqlViewName: 'ZMMR_REP8'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MMR REPORT8'
@Metadata.ignorePropagatedAnnotations: true
define view ZMMR_REPORT8 
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
    sum(b.QuantityInEntryUnit) as ScrapQty,
    sum(b.TotalGoodsMvtAmtInCCCrcy) as Scrapvalue
}
where 
//b.SalesOrder is not initial and
  b.GoodsMovementType = '551' 
group by
a.Product
