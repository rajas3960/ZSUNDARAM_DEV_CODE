@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_PUR_REG_REPORT_PV 
as select from ZMM_PUR_REG_REPORT_RV

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
    TransactionCurrency,
    CGST_Rate,
    SGST_Rate,
    IGST_Rate,
//    cast(gross_amount as abap.dec(15,2)) * cast(CGST_Rate as abap.dec(10,0)) as CGST_VAL,
//    cast(gross_amount as abap.dec(15,2)) * cast(SGST_Rate as abap.dec(10,0)) as SGST_VAL,
//    cast(gross_amount as abap.dec(15,2)) * cast(IGST_Rate as abap.dec(10,0)) as IGST_VAL,
//cast(
//  (
//    cast( gross_amount as abap.dec(15,2) )
//    * cast( CGST_Rate as abap.dec(10,2) ) / 100
//  ) as abap.dec(15,2)
//) as CGST_VAL,

case
    when SupplierInvDrCr = 'H'
    then
        cast(
            (
                cast( gross_amount as abap.dec(15,2) )
                * cast( CGST_Rate as abap.dec(10,2) )
                / 100
                * -1
            ) as abap.dec(15,2)
        )

    when SupplierInvDrCr = 'S'
    then
        cast(
            (
                cast( gross_amount as abap.dec(15,2) )
                * cast( CGST_Rate as abap.dec(10,2) )
                / 100
            ) as abap.dec(15,2)
        )

    else
        cast( 0 as abap.dec(15,2) )
end as CGST_VAL,

//cast(
//  (
//    cast( gross_amount as abap.dec(15,2) )
//    * cast( SGST_Rate as abap.dec(10,2) ) / 100
//  ) as abap.dec(15,2)
//) as SGST_VAL,
case
    when SupplierInvDrCr = 'H'
    then
        cast(
            (
                cast( gross_amount as abap.dec(15,2) )
                * cast( SGST_Rate as abap.dec(10,2) )
                / 100
                * -1
            ) as abap.dec(15,2)
        )

    when SupplierInvDrCr = 'S'
    then
        cast(
            (
                cast( gross_amount as abap.dec(15,2) )
                * cast( SGST_Rate as abap.dec(10,2) )
                / 100
            ) as abap.dec(15,2)
        )

    else
        cast( 0 as abap.dec(15,2) )
end as SGST_VAL,

//cast(
//  (
//    cast( gross_amount as abap.dec(15,2) )
//    * cast( IGST_Rate as abap.dec(10,2) ) / 100
//  ) as abap.dec(15,2)
//) as IGST_VAL,
case
    when SupplierInvDrCr = 'H'
    then
        cast(
            (
                cast( gross_amount as abap.dec(15,2) )
                * cast( IGST_Rate as abap.dec(10,2) )
                / 100
                * -1
            ) as abap.dec(15,2)
        )

    when SupplierInvDrCr = 'S'
    then
        cast(
            (
                cast( gross_amount as abap.dec(15,2) )
                * cast( IGST_Rate as abap.dec(10,2) )
                / 100
            ) as abap.dec(15,2)
        )

    else
        cast( 0 as abap.dec(15,2) )
end as IGST_VAL,
    Tax_Code_Description,
    ExchangeRate,
    WBS,
    @Semantics.quantity.unitOfMeasure: 'Order_Unit'
    invoice_qty_real,
    Order_Unit,
    
    case when CompensationCess is not initial and CompensationCess is not null
           then cast((invoice_qty_real * 400 ) as abap.dec( 31,2 ))
           else cast( 0 as abap.dec( 31,2 ))
    end  as CompensationCess,
    
//    InvoiceValue + CompensationCess as InvoiceValue,
    
//case
//  when SupplierInvDrCr = 'S'
//    then abs(
//           case
//             when MatDocDrCr = 'H'
//               then TotalMaterialCost * -1
//             else TotalMaterialCost
//           end
//         )
//
//  when SupplierInvDrCr = 'H'
//    then abs(
//           case
//             when MatDocDrCr = 'S'
//               then TotalMaterialCost * -1
//             else TotalMaterialCost
//           end
//         )
//
//  else 0
//end as TotalMaterialCost,
Frigtamount,
Posting_Key,
// case
//    when Posting_Key = '21'
//    then cast( Frigtamount as abap.dec(15,2) ) * -1
//
//    else cast( Frigtamount as abap.dec(15,2) )
//    end as Frigtamount,
    
    PostingType,
    IsReversal,
    case
    when IsReversal = 'X' 
    then CancelMiro
    else cast( '' as abap.char(10) )
    end as OriginalMIRODocNo,
    SupplierInvDrCr
    

}
