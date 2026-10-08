@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_HARD_COKE_RPT
  as select from    I_MaterialDocumentItem_2 as a
    inner join      I_Product                as b on  b.Product      = a.Material
                                                  and b.ProductGroup = 'Z018'
    left outer join I_Supplier               as c on c.Supplier = a.Supplier
    left outer join I_ProductText            as d on  d.Product  = a.Material
                                                  and d.Language = 'E'
    left outer join I_PurchaseOrderItemAPI01 as f on  f.PurchaseOrder     = a.PurchaseOrder
                                                  and f.PurchaseOrderItem = a.PurchaseOrderItem
    left outer join ZCDS_INSPECTION_DET as g on g.MaterialDocument = a.MaterialDocument and g.MaterialDocumentItem = a.MaterialDocumentItem
                                            and g.MaterialDocumentYear = a.MaterialDocumentYear and  g.InspectionSpecification = 'ITEMASH%'
    left outer join ZCDS_INSPECTION_DET as h on h.MaterialDocument = a.MaterialDocument and h.MaterialDocumentItem = a.MaterialDocumentItem
                                            and h.MaterialDocumentYear = a.MaterialDocumentYear and  h.InspectionSpecification = 'MOISTURE'                                        
{
  key $session.client                 as mandt_1,
  key a.MaterialDocument              as MaterialDocument,
  key a.MaterialDocumentItem          as MaterialDocumentItem,
  key a.MaterialDocumentYear          as MaterialDocumentYear,
      a.PostingDate                   as PostingDate,
      a.Supplier                      as Supplier,
      c.SupplierName                  as SupplierName,
      cast( '' as abap.char(30) )     as ChallanNo,
      a.Material                      as Material,
      d.ProductName                   as ProductName,
      a.Plant                         as Plant,
      a.StorageLocation               as StorageLocation,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.QuantityInEntryUnit           as QuantityInEntryUnit,
      a.MaterialBaseUnit              as MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( 0 as abap.quan( 13, 3 ) ) as plantqty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( 0 as abap.quan( 13, 3 ) ) as wtdiff,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      f.NetPriceAmount                as NetPriceAmount,
      f.DocumentCurrency              as DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast( 0 as abap.curr( 23, 2 ) ) as totbill,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast( 0 as abap.curr( 23, 2 ) ) as totpay,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast( 0 as abap.curr( 23, 2 ) ) as pricediff,
      g.InspectionResultOriginalValue as uash,
      h.InspectionResultOriginalValue as umois
      
}
where
      a.GoodsMovementType        =  '101'
  and a.PurchaseOrder            is not initial
  and a.GoodsMovementIsCancelled <> 'X'
