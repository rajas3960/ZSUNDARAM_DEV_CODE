@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPURCHASE_REGISTER
  as select from ZRE_PURCHASE_REGISTER as matdocitem 
// left outer join ZPURCHASE_REGISTER_002 as matdoc on matdocitem.Purchase_Order = matdoc.PurchaseOrder
                                                 
{
  key  matdocitem.Material_Document,
  key  matdocitem.Material_Document_Year,
  key  matdocitem.Material_Document_Item,
  key  matdocitem.Purchase_Order,
  key  matdocitem.SupplierInvoice,
  key  matdocitem.SupplierInvoiceItem,
  key  matdocitem.Material_DocumentYear,
  key  matdocitem.Purchase_OrderItem,
       matdocitem.MaterialBaseUnit,
      
      cast( matdocitem.Quantity as abap.dec(13,3) ) as quantity,
       matdocitem.documentdate,
       cast( '' as abap.char(20) ) as FreightSupplier,
//       matdoc.FreightSupplier as FreightSupplier,
       cast( '' as abap.char(100) ) as Supplier_name,
       cast( '' as abap.char(100) ) as FreightSupplierName,
//        matdoc.FreightSupplierName as FreightSupplierName,
       cast( '' as abap.char(20) ) as SuplrInvcDeliveryCostCndnCount,
       cast( '' as abap.char(20) ) as Supplierinvoice1,
       cast( 0 as abap.dec(23,2) ) as SUPPLIERINVOICEITEMAMOUNT,
       cast( '' as abap.cuky ) as STransactionCurrency, 
       cast( '' as abap.char(20) ) as INVOICINGPARTY,
       cast( 0 as abap.dec(23,2) ) as UnplannedDeliveryCost,
       cast( '' as abap.cuky ) as UTransactionCurrency,
       matdocitem.CompanyCode,
       matdocitem.AccountingDocument as AccountingDocument,
       matdocitem.PO_Creation_Date as PO_Creation_Date,
       matdocitem.Material as Material,
       matdocitem.PoItemText as PoItemText,
       matdocitem.supplier as Supplier,
       matdocitem.SupplierName as SupplierName,
       matdocitem.GLAccount as GLAccount,
       matdocitem.GLAccountName as GLAccountName,
       matdocitem.GoodsMovementType as Movement_type,
       matdocitem.GoodsMovementTypeName as MovementTypeName,
       matdocitem.MaterialDocumentHeaderText as MaterialDocumentHeaderText,
       cast (''as abap.char(20)) as  ConditionTypeName,
       cast ('' as abap.char(3)) as FreightMiroStatus,
//       cast(
//    case 
//        when matdocitem.PoItemText = 'Freight/Qty'
//        or SupplierInvoice is not initial
//        then 'YES'
//        else 'NO'
//    end 
//as abap.char(3)) as FreightMiroStatus,
       
       matdocitem.GRNValue as Freightamount,
       cast ( '' as abap.char( 10 )) as FrghtGLAccount,
       cast ( 0 as abap.dec(23,2)) as AmountInCompanyCodeCurrency,
       cast (0 as abap.dec(13,3)  ) as TotalQuantity,
        matdocitem.PODate,
         case 
        when matdocitem.Material_Document is initial then 2   -- Freight row
        else 1                                     -- GRN row
    end as sort_flag
       
}
////where matdocitem.Material_Document is not initial
//
union all
select from ZPURCHASE_REGISTER_002 as matdoc
{
key '' as Material_Document  ,
key cast('' as abap.numc(4)) as Material_Document_Year,
key cast('' as abap.numc(4)) as Material_Document_Item,
key  PurchaseOrder as Purchase_Order,
key SupplierInvoice,
key SupplierInvoiceItem,
key cast('' as abap.numc(4)) as Material_DocumentYear,
key PurchaseOrderItem as Purchase_OrderItem,
cast( '' as abap.unit( 3 ) ) as MaterialBaseUnit,
cast( matdoc.QuantityInPurchaseOrderUnit as abap.quan(13,3) ) as quantity,
' ' as DocumentDate,
cast( matdoc.FreightSupplier as abap.char(20) ) as FreightSupplier,
cast(matdoc.SupplierName1 as abap.char( 100 )) as Supplier_name,
cast( matdoc.FreightSupplierName as abap.char(100) ) as FreightSupplierName,
cast( matdoc.SuplrInvcDeliveryCostCndnCount as abap.char( 4 ) ) as SUPLRINVCDELIVERYCOSTCNDNCOUNT,
cast( matdoc.Supplierinvoice1 as abap.char(20) ) as Supplierinvoice1,
cast( matdoc.TotalAmount as abap.dec(23,2) ) as SUPPLIERINVOICEITEMAMOUNT,
matdoc.TransactionCurrency as STransactionCurrency,
cast( matdoc.InvoicingParty as abap.char(20) ) as INVOICINGPARTY ,
cast( matdoc.UnplannedDeliveryCost as abap.dec(23,2) ) as UnplannedDeliveryCost,
matdoc.TransactionCurrency as UTransactionCurrency,
matdoc.CompanyCode,
'' as AccountingDocument,
'' as PO_Creation_Date,
'' as Material,
'' as PoItemText,
'' as Supplier,
'' as SupplierName,
'' as GLAccount,
'' as GLAccountName,
'' as Movement_type,
'' as MovementTypeName,
'' as MaterialDocumentHeaderText,
cast( matdoc.ConditionTypeName as abap.char(20) ) as  ConditionTypeName,
//cast( matdoc.FreightMiroStatus as abap.char(3) ) as FreightMiroStatus,
//cast(
//    case 
//        when matdoc.ConditionTypeName = 'Freight/Qty'
//        and SupplierInvoice is not initial
//        then 'YES'
//        else 'NO'
//    end 
//as abap.char(3)) as FreightMiroStatus,
cast(
    case 
        when matdoc.SuplrInvcDeliveryCostCndnType = 'ZEF2'
//        and SupplierInvoice is not initial
        then 'YES'
        else 'NO'
    end 
as abap.char(3)) as FreightMiroStatus,
cast( 0 as abap.dec(23,2) ) as Freightamount,
cast( matdoc.FrghtGLAccount as abap.char(10) ) as FrghtGLAccount,
cast( matdoc.AmountInCompanyCodeCurrency as abap.dec(23,2) ) as AmountInCompanyCodeCurrency,
cast( matdoc.TotalQuantity as abap.dec(13,3) ) as TotalQuantity,
matdoc.PurchaseOrderDate as PODate,
case 
    when matdoc.TotalQuantity is not null then 2   -- Freight row
    else 1                                        -- GRN row
end as sort_flag


}
////where matdoc.PurchaseOrder is not initial;

////where matdocitem.Material_Document is not initial

