@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_PUR_REG_REPORT_CV 
as select from ZMM_PUR_REG_REPORT_PV1
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
    key Purchase_Order_Type,
    key Frigtamount,
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
    Created_By,
    Goods_Movement_TypeDescription,
    HSN_Code,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Taxable_Amount,
    TransactionCurrency,
    CGST_Rate,
    SGST_Rate,
    IGST_Rate,
    CGST_VAL,
    SGST_VAL,
    IGST_VAL,
    Tax_Code_Description,
    ExchangeRate,
    WBS,
    @Semantics.quantity.unitOfMeasure: 'Order_Unit'
    invoice_qty_real,
    Order_Unit,
    CompensationCess,
    Total_tax_value,
//    InvoiceValue,
    cast(
    coalesce(
        cast( Taxable_Amount as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )
    +
    coalesce(
        cast( Total_tax_value as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )
    as abap.dec(15,2)
) as InvoiceValue,

//  cast(
//  case
//    when Posting_Key = '21'
//    then
//      (
//        coalesce(
//          cast( Taxable_Amount as abap.dec(15,2) ),
//          cast( 0 as abap.dec(15,2) )
//        )
//        +
//        coalesce(
//          cast( Total_tax_value as abap.dec(15,2) ),
//          cast( 0 as abap.dec(15,2) )
//        )
//      ) * -1
//    else
//      (
//        coalesce(
//          cast( Taxable_Amount as abap.dec(15,2) ),
//          cast( 0 as abap.dec(15,2) )
//        )
//        +
//        coalesce(
//          cast( Total_tax_value as abap.dec(15,2) ),
//          cast( 0 as abap.dec(15,2) )
//        )
//      )
//  end
//  as abap.dec(15,2)
//) as InvoiceValue,
//     
//    
    
    Posting_Key,
    cast(
    coalesce(
        cast( Taxable_Amount as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )
    +
    coalesce(
        cast( Frigtamount as abap.dec(15,2) ),
        cast( 0 as abap.dec(15,2) )
    )
    as abap.dec(15,2)
) as TotalMaterialCost,

@Semantics.amount.currencyCode: 'Document_Currency'
//cast(
//    case
//        when invoice_qty_real = 0
//        then cast( 0 as abap.dec(15,2) )
//        else
//            (
//                coalesce(
//                    cast( Taxable_Amount as abap.dec(15,2) ),
//                    cast( 0 as abap.dec(15,2) )
//                )
//                +
//                coalesce(
//                    cast( Frigtamount as abap.dec(15,2) ),
//                    cast( 0 as abap.dec(15,2) )
//                )
//            ) / invoice_qty_real
//    end
//    as abap.dec(15,2)
//) as CostperQty,
cast(
    case
        when SupplierInvDrCr = 'H'
        //when Posting_Key = '21'
        then
            (
                case
                    when invoice_qty_real = 0
                    then cast( 0 as abap.dec(15,2) )
                    else
                        (
                            coalesce(
                                cast( Taxable_Amount as abap.dec(15,2) ),
                                cast( 0 as abap.dec(15,2) )
                            )
                            +
                            coalesce(
                                cast( Frigtamount as abap.dec(15,2) ),
                                cast( 0 as abap.dec(15,2) )
                            )
                        ) / invoice_qty_real
                end
            ) * -1
        else
            case
                when invoice_qty_real = 0
                then cast( 0 as abap.dec(15,2) )
                else
                    (
                        coalesce(
                            cast( Taxable_Amount as abap.dec(15,2) ),
                            cast( 0 as abap.dec(15,2) )
                        )
                        +
                        coalesce(
                            cast( Frigtamount as abap.dec(15,2) ),
                            cast( 0 as abap.dec(15,2) )
                        )
                    ) / invoice_qty_real
            end
    end
    as abap.dec(15,2)
) as CostperQty,
PostingType,
OriginalMIRODocNo



}
