@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final Consumption View of Purchase'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_PUR_REG_REPORT_PV1 
as select from ZMM_PUR_REG_REPORT_PV
{
    key Material_Document,
    key Material_Document_Year,
    key Material_Document_Item,
    key Purchase_Order,
    key Purchase_Order_Item,
    key Supplier_Invoice,
    key SupplierInvoice_Item,
    key SupplierInvoice_Year,
    key Company_Code,
    key Accounting_Document,
    key Material_Document_Date,
    key Goods_Movement_Type,
    key Supplier_Invoice_ID,
    key Supplier_Invoice_Date,
    key Supplier,
    key Supplier_Invoice_Posting_Date,
    key Purchase_Requisition,
    key Material,
    key Purchase_Order_Item_Text,
    key Material_Group,
    key Material_Type,
    @Semantics.amount.currencyCode: 'Document_Currency'
    gross_amount,
    Document_Currency,
    Tax_Code,
//    Company_Code,
//    Material_Document_Date,
//    Goods_Movement_Type,
//    Supplier,
//    Supplier_Invoice_Posting_Date,
//    Supplier_Invoice_ID,
//    Supplier_Invoice_Date,
    Supplier_Name,
    Supplier_GSTIN,
    Supplier_Region,
    Supplier_Country,
    Supplier_Street,
    Supplier_CityName,
    Supplier_PostalCode,
   
    Purchase_Order_Creation_Date,
    Purchase_Order_Incoterms,
    Purchase_Order_Payment_Terms,
    Purchase_Order_PaymTerms_Des,
    Purchase_Order_Type,
    Created_By,
    Goods_Movement_TypeDescription,
    HSN_Code,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Taxable_Amount,
//    case
//
//    when Posting_Key = '21'
//
//    then coalesce( cast( Taxable_Amount as abap.dec( 15, 2 ) ), 0 ) * -1
//
//    else coalesce( cast( Taxable_Amount as abap.dec( 15, 2 ) ), 0 )
//
//    end as Taxable_Amount,
    TransactionCurrency,
    CGST_Rate,
    SGST_Rate,
    IGST_Rate,
    //CGST_VAL,
    cast(CGST_VAL as abap.dec( 15, 2 ))  as CGST_VAL,
    cast(SGST_VAL as abap.dec( 15, 2 ))  as SGST_VAL,
    cast(IGST_VAL as abap.dec( 15, 2 ))  as IGST_VAL,
//    SGST_VAL,
//    IGST_VAL,
    Tax_Code_Description,
    ExchangeRate,
    WBS,
    @Semantics.quantity.unitOfMeasure: 'Order_Unit'
    invoice_qty_real,
    Order_Unit,
    CompensationCess,
//    cast(
//    coalesce( cast( CGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( SGST_VAL as abap.dec(15,2) ), 0 ) +
//    coalesce( cast( IGST_VAL as abap.dec(15,2) ), 0 )
//    as abap.dec(15,2)
//    ) as Total_tax_value, 
///DP

cast(

    coalesce(
        cast( CGST_VAL as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )

    +

    coalesce(
        cast( SGST_VAL as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )

    +

    coalesce(
        cast( IGST_VAL as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )

    as abap.dec(15,2)

) as Total_tax_value,

//    cast(
//  case
//    when Posting_Key = '21'
//    then
//      (
//        coalesce( cast( CGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( SGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( IGST_VAL as abap.dec(15,2) ), 0 )
//      ) * -1
//    else
//      (
//        coalesce( cast( CGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( SGST_VAL as abap.dec(15,2) ), 0 ) +
//        coalesce( cast( IGST_VAL as abap.dec(15,2) ), 0 )
//      )
//  end
//  as abap.dec(15,2)
//) as Total_tax_value,
//DP 
     
//      InvoiceValue,
//    TotalMaterialCost,
//    case
//       when Posting_Key = '21'
//    then coalesce( cast( Frigtamount as abap.dec(15,2) ), 0 ) * -1
//       else coalesce( cast( Frigtamount as abap.dec(15,2) ), 0 )
//    end as Frigtamount,
    Frigtamount,
    Posting_Key,
    PostingType,
    OriginalMIRODocNo,
    SupplierInvDrCr
    
    
  
    
    
}
