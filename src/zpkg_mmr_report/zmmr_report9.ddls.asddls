@AbapCatalog.sqlViewName: 'ZMMR_REP9'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MMR REPORT9'
@Metadata.ignorePropagatedAnnotations: true
define view ZMMR_REPORT9 
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
    sum(b.QuantityInEntryUnit) as PhysicalAdjustmentQty,
    sum(b.TotalGoodsMvtAmtInCCCrcy) as PhysicalDifferencevalue
}
where 
b.SalesOrder is not initial
 and b.GoodsMovementType = '701'
group by
a.Product
