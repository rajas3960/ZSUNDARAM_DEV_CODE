@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZR_PURCHASE_REG_001
  as select distinct from ZR_PURCHASE_REGISTER1 as a
{
       @EndUserText.label: 'GR Number'
  key  a.Material_Document,
       @EndUserText.label: 'GR Year'
  key  a.Material_Document_Year,
       @EndUserText.label: 'GR Item'
  key  a.Material_Document_Item,
       @EndUserText.label: 'Purchase Order'
  key  a.Purchase_Order,
       //     @EndUserText.label: 'Supplier Invoice'
       @EndUserText.label: 'MIRO Doc. No'
  key  case when a.SupplierInvoice is null
   then 'No Invoice Posted'
   else a.SupplierInvoice end                                                                                                                                                      as SupplierInvoice,
       @EndUserText.label: 'Supplier Invoice Item'
  key  case when a.SupplierInvoiceItem is null
   then 'No Item' else
   cast(a.SupplierInvoiceItem as abap.char( 10 ) ) end                                                                                                                             as SupplierInvoiceItem,
       @EndUserText.label: 'Supplier Invoice Year'
  key  case when a.Material_DocumentYear is null
  then '0000' else
  cast(a.Material_DocumentYear as abap.char(10) ) end                                                                                                                              as Material_DocumentYear,
       @EndUserText.label: 'Purchase Order Item'
       a.Purchase_OrderItem,
       @EndUserText.label: 'Purchase Req.'
       a.Purchasereq,
       @EndUserText.label: 'Purchase Req.Item'
       a.Purchase_Req_Item,
       @EndUserText.label: 'Purchase Req.Release Date'
       a.Purchase_Req_Release_Date,
       @EndUserText.label: 'Purchase Req.Date'
       a.PurchaseReqDate,
       @EndUserText.label: 'PRCreatedBy'
       a.PRCreatedBy,
       @EndUserText.label: 'Posting Date'
       a.postingdate,
       @EndUserText.label: 'Company Code'
       a.CompanyCode,
       @EndUserText.label: 'Supplier'
       a.supplier,
       @EndUserText.label: 'Supplier GSTIN'
       a.supgstin,
       @EndUserText.label: 'Receipt UOM'
       a.Receipt_UOM,
       @EndUserText.label: 'Valuation Type'
       a.ValuationType1,
       @EndUserText.label: 'Document Type'
       a.DocumentType,
       @EndUserText.label: 'Asset'
       a.WBS,
       @EndUserText.label: 'Supplier Name'
       a.SupplierName,
       @EndUserText.label: 'Supplier Region'
       a.SupplierRegion,
       @EndUserText.label: 'Supplier Country'
       a.SupplierCountry,
       @EndUserText.label: 'Supplier Address'
       a.Streetname,
       @EndUserText.label: 'Supplier City Name'
       a.Cityname,
       @EndUserText.label: 'Supplier Postal Code'
       a.PostalCode,
       @EndUserText.label: 'PO Creation Date'
       a.PO_Creation_Date,
       @EndUserText.label: 'Incoterms'
       a.Incoterms,
       @EndUserText.label: 'Payment Terms'
       a.Payment_Terms,
       @EndUserText.label: 'PaymentTerms Desc'
       a.Payment_Terms_Description,
       @EndUserText.label: 'Created By'
       a.createdby,
       a.DocumentCurrency,
       //   @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO Gross Amount'
       cast( ( coalesce(cast(a.grossamount as abap.dec( 15, 2 )) ,0) +  coalesce(cast(a.CGST_VAL as abap.dec(15, 2)),0) 
        + coalesce(cast(a.SGST_VAL as abap.dec (15, 2)),0 ) + coalesce(cast(a.IGST_Val as abap.dec(15, 2)),0 ) ) as abap.dec( 15, 2 ) )        as grossamount,
       @EndUserText.label: 'Item Code'
       a.Material,
       @EndUserText.label: 'Material Group'
       a.MaterialGroup,
       @EndUserText.label: 'Material Type'
       a.MaterialTyp,
       @EndUserText.label: 'PO Item Text'
       a.PoItemText,
       @EndUserText.label: 'HSN Code'
       a.hsn,
       @EndUserText.label: 'PO Order Quantity'
       //  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       //  a.Purchaseorderquanunit,
       cast(a.orderquantity as abap.dec( 15, 3 ) )                                                                                                                                 as orderquantity,
       @EndUserText.label: 'PO Order UOM'
       a.POorderUOM,
         @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'Per/EOU'
       cast(a.NetAmount as abap.dec( 15, 2 ) )                                                                                                                                     as NetAmount,
       @EndUserText.label: 'Tax Code'
       a.Taxcode,
       @EndUserText.label: 'Tax Code Text'
       a.TaxcodeText,
       @EndUserText.label: 'Doc.Currency'
       a.doc_currency,
       @EndUserText.label: 'Invoice Document Date'
       a.documentdate,
       @EndUserText.label: 'Invoice posting Date'
       a.InvoicePostingDate,
       @EndUserText.label: 'Supplier Invoice ID'
       a.SupplierInvoiceID,
       @EndUserText.label: 'Exchange Rate'
       a.ExchangeRate,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
//       @EndUserText.label: 'Taxable Value'
//       cast(a.TaxBaseAmountInCoCodeCrc as abap.dec( 15, 2 ))                                                                                                                       as TaxBaseAmountInCoCodeCrc,
//       cast(
//    coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//    as abap.dec(15,2)
//) as Taxable_Value,
       @EndUserText.label: 'Compensation Cess'
       a.CompensationCess,
       a.PurchaseOrderQuantityUnit,
       //  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       @EndUserText.label: 'Invoice Qty'
       cast(a.invoice_qty as abap.dec( 15, 3 ))                                                                                                                               as invoice_qty,
       @EndUserText.label: 'Completely Delivered'
       a.Po_status,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Packing Charges'
       cast(a.Packing_charges as abap.dec( 15, 2 ) )                                                                                                                               as Packing_charges,
         @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Freight Charges'
       cast( a.Freight_charges as abap.dec( 15, 2 ))                                                                                                                               as Freight_charges,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Other Charges'
       cast(a.Other_charges as abap.dec( 15, 2 ) )                                                                                                                                 as Other_charges,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Basic Custom Duty'
       cast(a.Basic_Custom_duty as abap.dec( 15, 2 ))                                                                                                                              as Basic_Custom_duty,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Discount'
       cast(a.Discount as abap.dec( 15, 2 ))                                                                                                                                       as Discount,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Unloading charges'
       cast(a.UnloadingCharges as abap.dec( 15, 2 ))                                                                                                                               as UnloadingCharges,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Loading charges'
       cast(a.LoadingCharges as abap.dec( 15, 2 ))                                                                                                                                 as LoadingCharges,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Handling Charges'
       cast(a.HandlingCharges as abap.dec( 15, 2 ))                                                                                                                                as HandlingCharges,
       //  @Semantics.amount.currencyCode: 'DocumentCurrency'
       @EndUserText.label: 'PO-Insurance Charges'
       cast(a.InsuranceCharges as abap.dec( 15, 2 ) )                                                                                                                              as InsuranceCharges,
       @EndUserText.label: 'CGST Rate'
      cast(a.CGST_Rate as abap.dec(10, 2)) * 100                                                                                                                                                           as CGST_Rate,
//       cast( coalesce(a.CGST_Rate,0) as abap.dec(10,2) ) * 100 as CGST_Rate,
       @EndUserText.label: 'CGST Value'
       cast(a.CGST_VAL as abap.dec( 15, 2 ))                                                                                                                                       as CGST_VAL1,
       @EndUserText.label: 'SGST Rate'
       cast(a.SGST_Rate as abap.dec(10, 2)) * 100                                                                                                                                                           as SGST_Rate,
//       cast( coalesce(a.SGST_Rate,0) as abap.dec(10,2) ) * 100 as SGST_Rate,
       @EndUserText.label: 'SGST Value'
       cast(a.SGST_VAL as abap.dec( 15, 2 ))                                                                                                                                       as SGST_VAL,
       @EndUserText.label: 'IGST Rate'
       cast(a.IGST_Rate as abap.dec(10, 2)) * 100                                                                                                                                                       as   IGST_Rate,
//       cast( coalesce(a.IGST_Rate,0) as abap.dec(10,2) ) * 100 as IGST_Rate,
       @EndUserText.label: 'IGST Value'
       cast(a.IGST_Val as abap.dec( 15, 2 ))                                                                                                                                       as IGST_Val,
       @EndUserText.label: 'Total Tax Value'
       //  a.Total_tax_value,
       cast(
    coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
    coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
    coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
    as abap.dec(15,2)
) as Total_tax_value,
       @EndUserText.label: 'GR Date'
       a.MaterialDocumentDate,
       @EndUserText.label: 'FI Posting Document'
       FIinv,
       @EndUserText.label: 'FI Posting Doc Date'
       fiinvdate,

       @EndUserText.label: 'GRN Quantity'
       a.GRNQty,
       @EndUserText.label: 'Credit Memo'
       a.CreditMemo,
       @EndUserText.label: 'Credit Memo Document Date'
       a.CreditMemoDocDate,
       @EndUserText.label: 'Credit Memo Posting Date'
       a.CreditMemoPostDate,
       @EndUserText.label: 'Credit Memo Quantity'
       a.CreditMemoQty,
       @EndUserText.label: 'Credit Memo Amount'
       a.CreditMemoAmt,

       @EndUserText.label: 'Subsequent debit'
       a.SubseqCredit,
       @EndUserText.label: 'Subsequent debit Document Date'
       a.SubseqCreditDocDate,
       @EndUserText.label: 'Subsequent debit Posting Date'
       a.SubseqCreditPostDate,
       @EndUserText.label: 'Subsequent debit Quantity'
       a.SubseqCreditQty,
       @EndUserText.label: 'Subsequent debit Amount'
       a.SubseqCreditAmt,
       @EndUserText.label: 'Subsequent credit'
       a.SubseqDebit,
       @EndUserText.label: 'Subsequent credit Document Date'
       a.SubseqDebitDocDate,
       @EndUserText.label: 'Subsequent credit Posting Date'
       a.SubseqDebitPostDate,
       @EndUserText.label: 'Subsequent credit Quantity'
       a.SubseqDebitQty,
       @EndUserText.label: 'Subsequent credit Amount'
       a.SubseqDebitAmt,

       @EndUserText.label: 'Total Material Cost'
//       ( -1 * a.TotalMaterialCost )                                                                                                                                                as TotalMaterialCost,
//       cast(
//    ( -1 * a.TotalMaterialCost ) +
//    coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//    as abap.dec(15,2)
//) as TotalMaterialCost,
      
//cast(
//  case
//    when (
//          a.SubseqCreditQty is not null
//      and a.SubseqCreditAmt is not null
//         )
//      or (
//          a.SubseqDebitQty is not null
//      and a.SubseqDebitAmt is not null
//         )
//    then 0
//
//    else
//      (
//        ( -1 * a.TotalMaterialCost ) +
//        coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//      )
//  end
//as abap.dec(15,2)
//) as TotalMaterialCost,
cast(
  case
    when a.PostingKey = '21'
    then
      -1 * (
             cast( a.TotalMaterialCost as abap.dec(15,2) ) +
             coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
             coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
             coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
           )

    else
      (
        cast( a.TotalMaterialCost as abap.dec(15,2) ) +
        coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
      )
  end
as abap.dec(15,2)
) as TotalMaterialCost,
//       ( -1 * coalesce(a.TotalMaterialCost,0) ) as TotalMaterialCost,
//       @EndUserText.label: 'Total Freight Cost'
       //       ( -1 * a.TotalDeliveryCost ) as TotalDeliveryCost,
//       a.Packing_charges + cast( a.Freight_d as abap.dec( 21, 2 ))  + a.Other_charges + a.Basic_Custom_duty - a.Discount + a.UnloadingCharges + a.LoadingCharges + a.HandlingCharges + a.InsuranceCharges as TotalDeliveryCost,
//       cast(
//    coalesce( cast( a.Packing_charges     as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.Freight_charges          as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.Other_charges       as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.Basic_Custom_duty   as abap.dec(15,2) ), 0 ) -
//    coalesce( cast( a.Discount            as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.UnloadingCharges    as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.LoadingCharges      as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.HandlingCharges     as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.InsuranceCharges    as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 ) 
//as abap.dec(15,2)
//) as TotalDeliveryCost,
   
cast(
  case
    when (
          a.SubseqCreditQty is not null
      and a.SubseqCreditAmt is not null
         )
      or (
          a.SubseqDebitQty is not null
      and a.SubseqDebitAmt is not null
         )
    then 0

    else
      (
        coalesce( cast( a.Packing_charges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.Freight_charges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.Other_charges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.Basic_Custom_duty as abap.dec(15,2) ), 0 ) -
        coalesce( cast( a.Discount as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.UnloadingCharges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.LoadingCharges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.HandlingCharges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.InsuranceCharges as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
        coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
      )
  end
as abap.dec(15,2)
) as TotalDeliveryCost,
       @EndUserText.label: 'Total Cost'
       ( -1 * a.TotalCost )                                                                                                                                                        as TotalCost,
//cast(
//(
//      (
//            abs(
//                coalesce(
//                    cast( a.TotalMaterialCost as abap.dec(15,2) ),
//                    0
//                )
//            )
//
//          + coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//      )
//
//      +
//
//      (
//            coalesce( cast( a.Packing_charges    as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.Freight_charges    as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.Other_charges      as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.Basic_Custom_duty  as abap.dec(15,2) ), 0 )
//          - coalesce( cast( a.Discount           as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.UnloadingCharges   as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.LoadingCharges     as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.HandlingCharges    as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.InsuranceCharges   as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 )
//          + coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) 
//          + coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//          
//          
//      )
//
//)
//as abap.dec(15,2)
//) as TotalCost,
      
//    cast(
//  case
//    when (
//          a.SubseqCreditQty is not null
//      and a.SubseqCreditAmt is not null
//         )
//      or (
//          a.SubseqDebitQty is not null
//      and a.SubseqDebitAmt is not null
//         )
//    then 0
//
//    else
//      (
//        coalesce( cast( a.Packing_charges   as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.Freight_charges   as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.Other_charges     as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.Basic_Custom_duty as abap.dec(15,2) ), 0 ) -
//        coalesce( cast( a.Discount          as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.UnloadingCharges  as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.LoadingCharges    as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.HandlingCharges   as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.InsuranceCharges  as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//      )
//  end
//as abap.dec(15,2)
//) as TotalCost,
//    cast(
//(
//  cast(
//    case
//      when (
//            a.SubseqCreditQty is not null
//        and a.SubseqCreditAmt is not null
//           )
//        or (
//            a.SubseqDebitQty is not null
//        and a.SubseqDebitAmt is not null
//           )
//      then 0
//
//      else
//        (
//          ( -1 * a.TotalMaterialCost ) +
//          coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//        )
//    end
//  as abap.dec(15,2) )
//
//  +
//
//  cast(
//    case
//      when (
//            a.SubseqCreditQty is not null
//        and a.SubseqCreditAmt is not null
//           )
//        or (
//            a.SubseqDebitQty is not null
//        and a.SubseqDebitAmt is not null
//           )
//      then 0
//
//      else
//        (
//          coalesce( cast( a.Packing_charges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.Freight_charges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.Other_charges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.Basic_Custom_duty as abap.dec(15,2) ), 0 ) -
//          coalesce( cast( a.Discount as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.UnloadingCharges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.LoadingCharges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.HandlingCharges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.InsuranceCharges as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//        )
//    end
//  as abap.dec(15,2) )
//
//)
//as abap.dec(15,2)
//) as TotalCost,
//      cast(
//(
//    /* Material Cost Part */
//    cast(
//        case
//            when (
//                    a.SubseqCreditQty is not null
//                and a.SubseqCreditAmt is not null
//                 )
//              or (
//                    a.SubseqDebitQty is not null
//                and a.SubseqDebitAmt is not null
//                 )
//            then 0
//
//            else
//                (
//                    ( -1 * coalesce( a.TotalMaterialCost, 0 ) ) +
//                    coalesce( cast( a.CGST_VAL  as abap.dec(15,2) ), 0 ) +
//                    coalesce( cast( a.SGST_VAL  as abap.dec(15,2) ), 0 ) +
//                    coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//                )
//        end
//    as abap.dec(15,2) )
//
//    +
//
//    /* Freight Cost Part */
//    cast(
//        (
//            coalesce( cast( a.Packing_charges    as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.Freight_charges   as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.Other_charges     as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.Basic_Custom_duty as abap.dec(15,2) ), 0 ) -
//            coalesce( cast( a.Discount          as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.UnloadingCharges  as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.LoadingCharges    as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.HandlingCharges   as abap.dec(15,2) ), 0 ) +
//            coalesce( cast( a.InsuranceCharges  as abap.dec(15,2) ), 0 )
//        )
//    as abap.dec(15,2) )
//
//)
//as abap.dec(15,2)
//) as TotalCost,
       @EndUserText.label: 'Cost/Qty'
//       ( -1 * a.CostPerQty )                                                                                                                                                       as CostPerQty,
//    cast(
//  case 
//    when a.GRNQty = 0 then 0    
//    else
//      (
//        (
//          ( -1 * a.TotalMaterialCost ) +
//          coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//        )
//        +
//        (
//          coalesce( cast( a.Packing_charges   as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.Freight_charges   as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.Other_charges     as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.Basic_Custom_duty as abap.dec(15,2) ), 0 ) -
//          coalesce( cast( a.Discount          as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.UnloadingCharges  as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.LoadingCharges    as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.HandlingCharges   as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.InsuranceCharges  as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
//          coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
//        )
//      )
//      /
//      cast( a.GRNQty as abap.dec(15,3) )
//  end
//  as abap.dec(15,2)
//) as CostPerQty,
       
     cast(
  case
    when (
          a.SubseqCreditQty is not null
      and a.SubseqCreditAmt is not null
         )
      or (
          a.SubseqDebitQty is not null
      and a.SubseqDebitAmt is not null
         )
    then 0

    when a.GRNQty = 0
    then 0

    else
      (
        (
          coalesce( cast( a.Packing_charges   as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.Freight_charges   as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.Other_charges     as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.Basic_Custom_duty as abap.dec(15,2) ), 0 ) -
          coalesce( cast( a.Discount          as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.UnloadingCharges  as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.LoadingCharges    as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.HandlingCharges   as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.InsuranceCharges  as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.CGST_VAL as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.SGST_VAL as abap.dec(15,2) ), 0 ) +
          coalesce( cast( a.IGST_Val as abap.dec(15,2) ), 0 )
        )
        / cast( a.GRNQty as abap.dec(15,3) )
      )
  end
as abap.dec(15,2)
) as CostPerQty,
       @EndUserText.label: 'Invoice Value'
       a.InvoiceValue,
       @EndUserText.label: 'Movement Type'
       a.Movement_type as Movementtype,
       @EndUserText.label: 'Movementtype_Description'
       a.Movement_Type_Description as Movementtype_Description,
       @EndUserText.label: 'Taxable Value'
       @Semantics.amount.currencyCode: 'TransactionCurrency'  
       a.JEIamount,
//       @EndUserText.label: 'Currency'
       a.TransactionCurrency,
       @Semantics.amount.currencyCode: 'Frigtcury' 
//       a.Frigtamount,
       case
         when a.PostingKey = '21'
         then cast( a.Frigtamount as abap.dec(15,2) ) * -1

         else cast( a.Frigtamount as abap.dec(15,2) )
       end as Frigtamount,
       a.Frigtcury,
       a.PostingKey,
       @Semantics.amount.currencyCode: 'Ccurry'
       a.FreightCGST,
       a.Ccurry,
       @Semantics.amount.currencyCode: 'Scurry'
       a.FreightSGST,
       a.Scurry,
       @Semantics.amount.currencyCode: 'Icurry'
       a.FreightIGST,
       a.Icurry


}
