@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'purchase register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZR_PURCHASE_REG_003 
as select from ZR_PURCHASE_REG_001 
{
        @EndUserText.label: 'GR Number'
    key Material_Document,
        @EndUserText.label: 'GR Year'
    key Material_Document_Year,
        @EndUserText.label: 'GR Item'
    key Material_Document_Item,
        @EndUserText.label: 'Purchase Order'
    key Purchase_Order,
        @EndUserText.label: 'MIRO Doc. No'
  key  case when SupplierInvoice is null
   then 'No Invoice Posted'
   else SupplierInvoice end                                                                                                                                                      as SupplierInvoice,
        @EndUserText.label: 'Supplier Invoice Item'
  key  case when SupplierInvoiceItem is null
   then 'No Item' else
   cast(SupplierInvoiceItem as abap.char( 10 ) ) end                                                                                                                             as SupplierInvoiceItem,
        @EndUserText.label: 'Supplier Invoice Year'
  key  case when Material_DocumentYear is null
  then '0000' else
  cast(Material_DocumentYear as abap.char(10) ) end                                                                                                                               as Material_DocumentYear,
    @EndUserText.label: 'Purchase Order Item'
    Purchase_OrderItem,
    @EndUserText.label: 'Purchase Req.'
    Purchasereq,
    @EndUserText.label: 'Purchase Req.Item'
    Purchase_Req_Item,
    @EndUserText.label: 'Purchase Req.Release Date'
    Purchase_Req_Release_Date,
    @EndUserText.label: 'Purchase Req.Date'
    PurchaseReqDate,
    @EndUserText.label: 'PRCreatedBy'
    PRCreatedBy,
    @EndUserText.label: 'Posting Date'
    postingdate,
    @EndUserText.label: 'Company Code'
    CompanyCode,
    @EndUserText.label: 'Supplier'
    supplier,
    @EndUserText.label: 'Supplier GSTIN'
    supgstin,
    @EndUserText.label: 'Receipt UOM'
    Receipt_UOM,
    @EndUserText.label: 'Valuation Type'
    ValuationType1,
    @EndUserText.label: 'Document Type'
    DocumentType,
    @EndUserText.label: 'Asset'
    WBS,
    @EndUserText.label: 'Supplier Name'
    SupplierName,
    @EndUserText.label: 'Supplier Region'
    SupplierRegion,
    @EndUserText.label: 'Supplier Country'
    SupplierCountry,
    @EndUserText.label: 'Supplier Address'
    Streetname,
    @EndUserText.label: 'Supplier City Name'
    Cityname,
    @EndUserText.label: 'Supplier Postal Code'
    PostalCode,
    @EndUserText.label: 'PO Creation Date'
    PO_Creation_Date,
    @EndUserText.label: 'Incoterms'
    Incoterms,
    @EndUserText.label: 'Payment Terms'
    Payment_Terms,
    @EndUserText.label: 'PaymentTerms Desc'
    Payment_Terms_Description,
    @EndUserText.label: 'Created By'
    createdby,
    DocumentCurrency,
    @EndUserText.label: 'PO Gross Amount'
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    grossamount,
    @EndUserText.label: 'Item Code'
    Material,
    @EndUserText.label: 'Material Group'
    MaterialGroup,
    @EndUserText.label: 'Material Type'
    MaterialTyp,
    @EndUserText.label: 'PO Item Text'
    PoItemText,
    @EndUserText.label: 'HSN Code'
    hsn,
    PurchaseOrderQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    @EndUserText.label: 'PO Order Quantity'
    orderquantity,
    @EndUserText.label: 'PO Order UOM'
    POorderUOM,
    @EndUserText.label: 'Per/EOU'
    NetAmount,
    @EndUserText.label: 'Tax Code'
    Taxcode,
    @EndUserText.label: 'Tax Code Text'
    TaxcodeText,
    @EndUserText.label: 'Doc.Currency'
    doc_currency,
    @EndUserText.label: 'Invoice Document Date'
    documentdate,
    @EndUserText.label: 'Invoice posting Date'
    InvoicePostingDate,
    @EndUserText.label: 'Supplier Invoice ID'
    SupplierInvoiceID,
     @EndUserText.label: 'Exchange Rate'
    ExchangeRate,
//    @Semantics.amount.currencyCode: 'DocumentCurrency'
//    TaxBaseAmountInCoCodeCrc,
    @EndUserText.label: 'Compensation Cess'
    CompensationCess,
//    Purchaseorderquanunit,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    @EndUserText.label: 'Invoice Qty'
    invoice_qty,
    @EndUserText.label: 'Completely Delivered'
    Po_status,
     @EndUserText.label: 'PO-Packing Charges'
    Packing_charges,
    @EndUserText.label: 'PO-Freight Charges'
    Freight_charges,
    @EndUserText.label: 'PO-Other Charges'
    Other_charges,
    @EndUserText.label: 'PO-Basic Custom Duty'
    Basic_Custom_duty,
    @EndUserText.label: 'PO-Discount'
    Discount,
    @EndUserText.label: 'PO-Unloading charges'
    UnloadingCharges,
    @EndUserText.label: 'PO-Loading charges'
    LoadingCharges,
    @EndUserText.label: 'PO-Handling Charges'
    HandlingCharges,
    @EndUserText.label: 'PO-Insurance Charges'
    InsuranceCharges,
    @EndUserText.label: 'CGST Rate'
    CGST_Rate,
    @EndUserText.label: 'SGST Rate'
    SGST_Rate,
    @EndUserText.label: 'CGST Value'
    CGST_VAL1,
    @EndUserText.label: 'SGST Value'
    SGST_VAL,
    @EndUserText.label: 'IGST Rate'
    IGST_Rate,
    @EndUserText.label: 'IGST Value'
    IGST_Val,  
    @EndUserText.label: 'Total Tax Value'
    Total_tax_value,
    @EndUserText.label: 'GR Date'
    MaterialDocumentDate,
    @EndUserText.label: 'FI Posting Document'
    FIinv,
    @EndUserText.label: 'FI Posting Doc Date'
    fiinvdate,
    @EndUserText.label: 'GRN Quantity'
    GRNQty,
    @EndUserText.label: 'Credit Memo'
    CreditMemo,
    @EndUserText.label: 'Credit Memo Document Date'
    CreditMemoDocDate,
    @EndUserText.label: 'Credit Memo Posting Date'
    CreditMemoPostDate,
    @EndUserText.label: 'Credit Memo Quantity'
    CreditMemoQty,
    @EndUserText.label: 'Credit Memo Amount'
    CreditMemoAmt,
    @EndUserText.label: 'Subsequent debit'
    SubseqCredit,
    @EndUserText.label: 'Subsequent debit Document Date'
    SubseqCreditDocDate,
    @EndUserText.label: 'Subsequent debit Posting Date'
    SubseqCreditPostDate,
    @EndUserText.label: 'Subsequent debit Quantity'
    SubseqCreditQty,
    @EndUserText.label: 'Subsequent debit Amount'
    SubseqCreditAmt,
    @EndUserText.label: 'Subsequent credit'
    SubseqDebit,
    @EndUserText.label: 'Subsequent credit Document Date'
    SubseqDebitDocDate,
    @EndUserText.label: 'Subsequent credit Posting Date'
    SubseqDebitPostDate,
    @EndUserText.label: 'Subsequent credit Quantity'
    SubseqDebitQty,
    @EndUserText.label: 'Subsequent credit Amount'
    SubseqDebitAmt,
    @EndUserText.label: 'Total Material Cost'
    TotalMaterialCost,
//    @EndUserText.label: 'Total Freight Cost'
//    TotalDeliveryCost,
//    TotalCost,
    @EndUserText.label: 'Total Cost'
//    cast(
//(
//      case
//          when TotalMaterialCost is null
//          then 0
//          else TotalMaterialCost
//      end
//
//    +
//
//      case
//          when TotalDeliveryCost is null
//          then 0
//          else TotalDeliveryCost
//      end
//)
//as abap.dec(15,2)
//) as TotalCost,
//    cast(
//    (
//      case
//          when TotalMaterialCost is null
//          then cast( 0 as abap.dec(15,2) )
//          else cast( TotalMaterialCost as abap.dec(15,2) )
//      end
//
//      +
//
//      case
//          when Frigtamount is null
//          then cast( 0 as abap.dec(15,2) )
//          else cast( Frigtamount as abap.dec(15,2) )
//      end
//    )
//    as abap.dec(15,2)
//) as TotalCost,
//  cast(
//    (
//      case
//          when TotalMaterialCost is null
//          then cast( 0 as abap.dec(15,2) )
//          else cast( TotalMaterialCost as abap.dec(15,2) )
//      end
//
//      +
//
//      case
//          when PostingKey = '21'
//          then
//              case
//                  when Frigtamount is null
//                  then cast( 0 as abap.dec(15,2) )
//                  else cast( Frigtamount * (-1) as abap.dec(15,2) )
//              end
//          else
//              case
//                  when Frigtamount is null
//                  then cast( 0 as abap.dec(15,2) )
//                  else cast( Frigtamount as abap.dec(15,2) )
//              end
//      end
//    )
//    as abap.dec(15,2)
//) as TotalCost,

cast(
      (
        case
          when TotalMaterialCost is null
          then cast( 0 as abap.dec(15,2) )
          else cast( TotalMaterialCost as abap.dec(15,2) )
        end
      )
      +
      (
        case
          when PostingKey = '21'
          then
            (
              coalesce( cast( Frigtamount as abap.dec(15,2) ), 0 ) +
              coalesce( cast( FreightCGST as abap.dec(15,2) ), 0 ) +
              coalesce( cast( FreightSGST as abap.dec(15,2) ), 0 ) +
              coalesce( cast( FreightIGST as abap.dec(15,2) ), 0 )
            ) * -1
          else
            (
              coalesce( cast( Frigtamount as abap.dec(15,2) ), 0 ) +
              coalesce( cast( FreightCGST as abap.dec(15,2) ), 0 ) +
              coalesce( cast( FreightSGST as abap.dec(15,2) ), 0 ) +
              coalesce( cast( FreightIGST as abap.dec(15,2) ), 0 )
            )
        end
      )
      as abap.dec(15,2)
    ) as TotalCost,
//    @EndUserText.label: 'Cost/Qty'
//    CostPerQty,
//    cast(
//  case
//    when GRNQty is null or GRNQty = 0
//      then 0
//
//    else
//      (
//        cast(
//          (
//            case
//              when TotalMaterialCost is null
//                then cast( 0 as abap.dec(15,2) )
//              else cast( TotalMaterialCost as abap.dec(15,2) )
//            end
//            +
//            case
//              when Frigtamount is null
//                then cast( 0 as abap.dec(15,2) )
//              else cast( Frigtamount as abap.dec(15,2) )
//            end
//          )
//          as abap.dec(15,2)
//        )
//        /
//        cast( GRNQty as abap.dec(15,3) )
//      )
//  end
//  as abap.dec(15,2)
//) as CostPerQty,
   
   cast(
  case
    when GRNQty is null or GRNQty = 0
      then 0

    else
      (
        cast(
          (
            case
              when TotalMaterialCost is null
              then cast( 0 as abap.dec(15,2) )
              else cast( TotalMaterialCost as abap.dec(15,2) )
            end

            +
            
            case
              when PostingKey = '21'
              then
                (
                  coalesce( cast( Frigtamount as abap.dec(15,2) ), 0 ) +
                  coalesce( cast( FreightCGST as abap.dec(15,2) ), 0 ) +
                  coalesce( cast( FreightSGST as abap.dec(15,2) ), 0 ) +
                  coalesce( cast( FreightIGST as abap.dec(15,2) ), 0 )
                ) * -1

              else
                (
                  coalesce( cast( Frigtamount as abap.dec(15,2) ), 0 ) +
                  coalesce( cast( FreightCGST as abap.dec(15,2) ), 0 ) +
                  coalesce( cast( FreightSGST as abap.dec(15,2) ), 0 ) +
                  coalesce( cast( FreightIGST as abap.dec(15,2) ), 0 )
                )
            end
          )
          as abap.dec(15,2)
        )
        /
        cast( GRNQty as abap.dec(15,3) )
      )
  end
  as abap.dec(15,2)
) as CostPerQty,

//            case
//              when PostingKey = '21'
//              then
//                case
//                  when Frigtamount is null
//                  then cast( 0 as abap.dec(15,2) )
//                  else cast( Frigtamount * (-1) as abap.dec(15,2) )
//                end
//              else
//                case
//                  when Frigtamount is null
//                  then cast( 0 as abap.dec(15,2) )
//                  else cast( Frigtamount as abap.dec(15,2) )
//                end
//            end
//          )
//          as abap.dec(15,2)
//        )
//        /
//        cast( GRNQty as abap.dec(15,3) )
//      )
//  end
//  as abap.dec(15,2)
//) as CostPerQty,
    
    @EndUserText.label: 'Invoice Value'
    InvoiceValue,
    @EndUserText.label: 'Movement Type'
    Movementtype,
    @EndUserText.label: 'Movementtype_Description'
    Movementtype_Description,
    @Semantics.amount.currencyCode: 'TransactionCurrency' 
    @EndUserText.label: 'Taxable Value'
    JEIamount,
    TransactionCurrency,
    @EndUserText.label: 'Total Freight Cost'
    @Semantics.amount.currencyCode: 'Frigtcury' 
//    case
//    when PostingKey = '21'
//    then cast( Frigtamount as abap.dec(15,2) ) * -1
//
//    else cast( Frigtamount as abap.dec(15,2) )
//    end as Frigtamount,
    case
    when PostingKey = '21'
    then
      (
        coalesce( cast( Frigtamount  as abap.dec(15,2) ), 0 ) +
        coalesce( cast( FreightCGST as abap.dec(15,2) ), 0 ) +
        coalesce( cast( FreightSGST as abap.dec(15,2) ), 0 ) +
        coalesce( cast( FreightIGST as abap.dec(15,2) ), 0 )
      ) * -1

    else
      (
        coalesce( cast( Frigtamount  as abap.dec(15,2) ), 0 ) +
        coalesce( cast( FreightCGST as abap.dec(15,2) ), 0 ) +
        coalesce( cast( FreightSGST as abap.dec(15,2) ), 0 ) +
        coalesce( cast( FreightIGST as abap.dec(15,2) ), 0 )
      )
end as Frigtamount,
    Frigtcury,
     @EndUserText.label: 'PostingKey'
    PostingKey,
    @EndUserText.label: 'FreightCGST'
    @Semantics.amount.currencyCode: 'Ccurry'
      FreightCGST,
      Ccurry,
      @EndUserText.label: 'FreightSGST'
      @Semantics.amount.currencyCode: 'Scurry'
      FreightSGST,
      Scurry,
      @EndUserText.label: 'FreightIGST'
      @Semantics.amount.currencyCode: 'Icurry'
      FreightIGST,
      Icurry
}
