@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Interface 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PURCHASE_REGISTER1
  as select from    ZR_PURCHASE_REGISTER as a
    left outer join ZR_PO_PRICINGELEMENT as BCD on  BCD.PurchaseOrder     = a.Purchase_Order
                                                and BCD.PurchaseOrderItem = a.Purchase_OrderItem
                                                and BCD.ConditionType     = 'JCDB'

    left outer join ZR_PO_PRICINGELEMENT as HC  on  HC.PurchaseOrder     = a.Purchase_Order
                                                and HC.PurchaseOrderItem = a.Purchase_OrderItem
                                                and HC.ConditionType     = 'ZHAC'

    left outer join ZR_PR_DISCOUNT       as DIS on  DIS.PurchaseOrder     = a.Purchase_Order
                                                and DIS.PurchaseOrderItem = a.Purchase_OrderItem

    left outer join ZR_PACKING_CHRG      as PC  on  PC.PurchaseOrder     = a.Purchase_Order
                                                and PC.PurchaseOrderItem = a.Purchase_OrderItem

    left outer join ZR_FREIGHT_CHRG      as FC  on  FC.PurchaseOrder     = a.Purchase_Order
                                                and FC.PurchaseOrderItem = a.Purchase_OrderItem


    left outer join ZR_OTHER_CHRG        as OC  on  OC.PurchaseOrder     = a.Purchase_Order
                                                and OC.PurchaseOrderItem = a.Purchase_OrderItem

    left outer join ZR_UNLOADING_CHRG    as UC  on  UC.PurchaseOrder     = a.Purchase_Order
                                                and UC.PurchaseOrderItem = a.Purchase_OrderItem


    left outer join ZR_LOADING_CHRG      as LC  on  LC.PurchaseOrder     = a.Purchase_Order
                                                and LC.PurchaseOrderItem = a.Purchase_OrderItem

    left outer join ZR_INSURANCE_CHRG    as IC  on  IC.PurchaseOrder     = a.Purchase_Order
                                                and IC.PurchaseOrderItem = a.Purchase_OrderItem
{
  key a.Material_Document,
  key a.Material_Document_Year,
  key a.Material_Document_Item,
  key a.Purchase_Order,
  key a.SupplierInvoice,
  key a.SupplierInvoiceItem,
  key a.Material_DocumentYear,
      a.Purchase_OrderItem,
      a.Purchasereq,
      a.Purchase_Req_Item,
      a.Purchase_Req_Release_Date,
      a.PurchaseReqDate,
      a.PRCreatedBy,
      a.postingdate,
      a.CompanyCode,
      a.supplier,
      a.supgstin,
      a.Receipt_UOM,
      a.ValuationType1,
      a.DocumentType,
      a.WBS,
      a.SupplierName,
      a.SupplierRegion,
      a.SupplierCountry,
      a.Streetname,
      a.Cityname,
      a.PostalCode,
      a.PO_Creation_Date,
      a.Incoterms,
      a.Payment_Terms,
      a.Payment_Terms_Description,
      a.createdby,
      a.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.grossamount,
//      case when a.GRNQty is not initial and a.GRNQty is not null
//           then cast((cast(a.grossamount as abap.dec(21,2))  / ( coalesce(a.orderquantity,0)) * a.GRNQty ) as abap.dec(21,2))
//           else cast( 0 as abap.dec(21,2))
//      end                                                                                      as grossamount,
      a.Material,
      a.MaterialGroup,
      a.MaterialTyp,
      a.PoItemText,
      a.hsn,
      a.PurchaseOrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      a.orderquantity,
      a.POorderUOM,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.NetAmount,
      a.Taxcode,
      a.TaxcodeText,
      a.doc_currency,
      a.documentdate,
      a.InvoicePostingDate,
      a.SupplierInvoiceID,
      a.ExchangeRate,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.TaxBaseAmountInCoCodeCrc,
      //      CompensationCess,
      case when a.CompensationCess is not initial and a.CompensationCess is not null
           then cast((a.invoice_qty * 400 ) as abap.dec( 31,2 ))
           else cast( 0 as abap.dec( 31,2 ))
      end                                                                                      as CompensationCess,
      a.Purchaseorderquanunit,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      a.invoice_qty_real                                                                       as invoice_qty,
      a.Po_status,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.Packing_charges,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.Freight_charges,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.Other_charges,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.Basic_Custom_duty,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.Discount,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.UnloadingCharges,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.LoadingCharges,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.HandlingCharges,
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      a.InsuranceCharges,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(PC.Amt,0) * coalesce(a.orderquantity,0)  ) / ( a.GRNQty ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as Packing_charges,


      //      case when a.GRNQty is not initial and a.GRNQty is not null
      //           then cast((coalesce(FC.Amt,0) * coalesce(a.orderquantity,0)  ) / ( a.GRNQty ) as abap.dec(21,2))
      //           else cast( 0 as abap.dec(21,2))
      //      end
      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(FC.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
                else cast( 0 as abap.dec(21,2))
           end                                                                                 as Freight_charges,
      

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(OC.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as Other_charges,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(BCD.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as Basic_Custom_duty,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(DIS.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as Discount,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(UC.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as UnloadingCharges,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(LC.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as LoadingCharges,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(HC.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as HandlingCharges,

      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((coalesce(IC.Amt,0) *  coalesce(a.GRNQty ,0) ) / ( a.orderquantity ) as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as InsuranceCharges,

      a.CGST_Rate,
      a.SGST_Rate,
        cast(a.grossamount as abap.dec(15,2)) * cast(a.CGST_Rate as abap.dec(10,3)) as CGST_VAL,

        cast(a.grossamount as abap.dec(15,2)) * cast(a.SGST_Rate as abap.dec(10,3)) as SGST_VAL,
//      cast(a.TaxBaseAmountInCoCodeCrc as abap.dec(15,2)) * cast(a.CGST_Rate as abap.dec(10,3)) as CGST_VAL,
//      cast(a.TaxBaseAmountInCoCodeCrc as abap.dec(15,2)) * cast(a.SGST_Rate as abap.dec(10,3)) as SGST_VAL,
      a.IGST_Rate,
        cast(a.grossamount as abap.dec(15,2)) * cast(a.IGST_Rate as abap.dec(10,3))      as IGST_Val,
//      cast(a.TaxBaseAmountInCoCodeCrc as abap.dec(15,2)) * cast(a.IGST_Rate as abap.dec(10,2)) as IGST_Val,
      //  @Semantics.amount.currencyCode: 'DocumentCurrency'
      //  cast(a.grossamount as abap.dec(15,2)) *
      //  (
      //    cast(a.CGST_Rate as abap.dec(10,4)) +  cast(a.SGST_Rate as abap.dec(10,4)) + cast(a.IGST_Rate as abap.dec(10,2))
      //  )                                                                                as Total_tax_value,

      a.MaterialDocumentDate                                                                   as MaterialDocumentDate,
      a.FIinv,
      a.fiinvdate,

      a.GRNQty,
      a.CreditMemo,
      a.CreditMemoDocDate,
      a.CreditMemoPostDate,
      a.CreditMemoQty,
      a.CreditMemoAmt,

      a.SubseqCredit,
      a.SubseqCreditDocDate,
      a.SubseqCreditPostDate,
      case when a.GRNQty = abs(a.SubseqCreditQty)
           then cast(0 as abap.dec(13,3))
           else a.SubseqCreditQty
      end                                                                                      as SubseqCreditQty,
      a.SubseqCreditAmt,
      a.SubseqDebit,
      a.SubseqDebitDocDate,
      a.SubseqDebitPostDate,
      case when a.GRNQty = a.SubseqDebitQty
           then cast(0 as abap.dec(13,3))
           else a.SubseqDebitQty
      end                                                                                      as SubseqDebitQty,
      a.SubseqDebitAmt,

      //       case when suppinvoice.DebitCreditCode = 'S'
      //       then case when matdocitem.DebitCreditCode = 'H' then matdocitem.QuantityInBaseUnit * -1 else matdocitem.QuantityInBaseUnit end
      //
      //       when suppinvoice.DebitCreditCode = 'H'
      //       then case when matdocitem.DebitCreditCode = 'S' and SUBSEQDR.SupplierInvoice is not initial or SUBSEQCR.SupplierInvoice is not initial then matdocitem.QuantityInBaseUnit  end
      //
      //       else 0 end


//      case when a.SupplierInvDrCr = 'S'
//      then case when a.MatDocDrCr = 'H' then a.TotalMaterialCost * -1 else a.TotalMaterialCost end
//
//      when a.SupplierInvDrCr = 'H'
//      then case when a.MatDocDrCr = 'S' and a.SubseqCredit is not initial or a.SubseqDebit is not initial then a.TotalMaterialCost  end
//
//      else 0 end                                                                               as TotalMaterialCost,
//      case
//  when a.SupplierInvDrCr = 'S'
//    then case
//           when a.MatDocDrCr = 'H'
//             then a.TotalMaterialCost * -1
//           else a.TotalMaterialCost
//         end
//
//  when a.SupplierInvDrCr = 'H'
//    then case
//           when a.MatDocDrCr = 'S'
//             then a.TotalMaterialCost * -1
//           else a.TotalMaterialCost
//         end
//
//  else 0
//end as TotalMaterialCost,
      case
  when a.SupplierInvDrCr = 'S'
    then abs(
           case
             when a.MatDocDrCr = 'H'
               then a.TotalMaterialCost * -1
             else a.TotalMaterialCost
           end
         )

  when a.SupplierInvDrCr = 'H'
    then abs(
           case
             when a.MatDocDrCr = 'S'
               then a.TotalMaterialCost * -1
             else a.TotalMaterialCost
           end
         )

  else 0
end as TotalMaterialCost,

      case when a.SupplierInvDrCr = 'S'
      then case when a.MatDocDrCr = 'H' then a.TotalDeliveryCost * -1 else a.TotalDeliveryCost end

      when a.SupplierInvDrCr = 'H'
      then case when a.MatDocDrCr = 'S' and a.SubseqCredit is not initial or a.SubseqDebit is not initial then a.TotalDeliveryCost  end

      else 0 end                                                                               as TotalDeliveryCost,

      case when a.SupplierInvDrCr = 'S'
      then case when a.MatDocDrCr = 'H' then a.TotalCost * -1 else a.TotalCost end

      when a.SupplierInvDrCr = 'H'
      then case when a.MatDocDrCr = 'S' and a.SubseqCredit is not initial or a.SubseqDebit is not initial then a.TotalCost  end

      else 0 end                                                                               as TotalCost,

      case when a.SupplierInvDrCr = 'S'
      then case when a.MatDocDrCr = 'H' then a.CostPerQty * -1 else a.CostPerQty end

      when a.SupplierInvDrCr = 'H'
      then case when a.MatDocDrCr = 'S' and a.SubseqCredit is not initial or a.SubseqDebit is not initial then a.CostPerQty  end

      else 0 end                                                                               as CostPerQty,
      a.InvoiceValue + a.CompensationCess                                                      as InvoiceValue,
      a.Movement_type,
      a.Movement_Type_Description,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.JEIamount,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'Frigtcury'
      a.Frigtamount,
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
      a.Icurry,
      a.SupplierInvDrCr
      
//      @Semantics.amount.currencyCode: 'DocumentCurrency'
//      cast(a.Freight_d as abap.dec( 21, 2 ))  as Freight_d
     

}
