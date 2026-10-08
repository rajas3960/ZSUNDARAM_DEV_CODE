@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Interface 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PURCHASE_REGISTER01
  as select distinct from ZPURCHASE_REGISTER_002  as ps
  //    left outer join ZR_PO_PRICINGELEMENTS as BCD on  BCD.PurchaseOrder     = a.Purchase_Order
  //                                                 and BCD.PurchaseOrderItem = a.Purchase_OrderItem
  //                                                 and BCD.ConditionType     = 'JCDB'
  //
  //    left outer join ZR_PO_PRICINGELEMENTS as HC  on  HC.PurchaseOrder     = a.Purchase_Order
  //                                                 and HC.PurchaseOrderItem = a.Purchase_OrderItem
  //                                                 and HC.ConditionType     = 'ZHAC'
  //
  //    left outer join ZR_PR_DISCOUNTS       as DIS on  DIS.PurchaseOrder     = a.Purchase_Order
  //                                                 and DIS.PurchaseOrderItem = a.Purchase_OrderItem
  ////                                                 and (
  ////                                                    DIS.ConditionType      = 'ZABD'
  ////                                                    or DIS.ConditionType   = 'ZDPQ'
  ////                                                    or DIS.ConditionType   = 'ZADV'
  ////                                                  )
  //
  //    left outer join ZR_PACKING_CHRGS      as PC  on  PC.PurchaseOrder     = a.Purchase_Order
  //                                                 and PC.PurchaseOrderItem = a.Purchase_OrderItem
  ////                                                 and (
  ////                                                    PC.ConditionType      = 'ZPF1'
  ////                                                    or PC.ConditionType   = 'ZPF2'
  ////                                                    or PC.ConditionType   = 'ZPF3'
  ////                                                  )
  ////
  //    left outer join ZR_FREIGHT_CHRGS      as FC  on  FC.PurchaseOrder     = a.Purchase_Order
  //                                                 and FC.PurchaseOrderItem = a.Purchase_OrderItem
  //////                                                 and (
  //////                                                    FC.ConditionType      = 'ZEF1'
  //////                                                    or FC.ConditionType   = 'ZEF2'
  //////                                                    )
  ////
  //    left outer join ZR_OTHER_CHRGS        as OC  on  OC.PurchaseOrder     = a.Purchase_Order
  //                                                 and OC.PurchaseOrderItem = a.Purchase_OrderItem
  //////                                                 and (
  //////                                                    OC.ConditionType      = 'ZOT1'
  //////                                                    or OC.ConditionType   = 'ZOT2'
  //////                                                    or OC.ConditionType   = 'ZOT3'
  //////                                                  )
  ////
  //    left outer join ZR_UNLOADING_CHRGS    as UC  on  UC.PurchaseOrder     = a.Purchase_Order
  //                                                 and UC.PurchaseOrderItem = a.Purchase_OrderItem
  //////                                                  and (
  //////                                                    UC.ConditionType      = 'ZUC1'
  //////                                                    or UC.ConditionType   = 'ZUC2'
  //////                                                    )
  ////
  //    left outer join ZR_LOADING_CHRGS      as LC  on  LC.PurchaseOrder     = a.Purchase_Order
  //                                                 and LC.PurchaseOrderItem = a.Purchase_OrderItem
  //////                                                  and (
  //////                                                    LC.ConditionType      = 'ZLC1'
  //////                                                    or LC.ConditionType   = 'ZLC2'
  //////                                                    )
  ////
  //    left outer join ZR_INSURENCE_CHRGS    as IC  on  IC.PurchaseOrder     = a.Purchase_Order
  //                                                 and IC.PurchaseOrderItem = a.Purchase_OrderItem
  //////                                                 and (
  ////                                                    IC.ConditionType      = 'ZIS1'
  ////                                                    or IC.ConditionType   = 'ZIS2'
  ////                                                    or IC.ConditionType   = 'ZIS3'
  ////                                                  )
  //
//    association       ZPURCHASE_REGISTER_002 as PS on  PS.PurchaseOrder     = a.Purchase_Order
//                                                       and PS.PurchaseOrderItem = a.Purchase_OrderItem
association [0..*] to ZRE_PURCHASE_REGISTER as a
  on  ps.PurchaseOrder     = a.Purchase_Order
  and ps.PurchaseOrderItem = a.Purchase_OrderItem



  //and PS.SupplierInvoiceItem = a.SupplierInvoiceItem
  // and PS.SuplrInvcDeliveryCostCndnCount = '002'

{
  key a.Material_Document,
  key a.Material_Document_Year,
  key a.Material_Document_Item,
  key a.Purchase_Order,
  key a.SupplierInvoice,
  key a.SupplierInvoiceItem,
  key a.Material_DocumentYear,
  key ps.PricingDocument,
  key ps.PricingDocumentItem,
  key ps.PricingProcedureStep,
  key ps.PricingProcedureCounter,
  key ps.Supplier1,
  key a.Purchase_OrderItem,
   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.Quantity,
      a.MaterialBaseUnit,
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
      //      a.grossamount,
      case when a.GRNQty is not initial and a.GRNQty is not null
           then cast((cast(a.grossamount as abap.dec(21,2)) * coalesce(a.orderquantity,0)) / a.GRNQty as abap.dec(21,2))
           else cast( 0 as abap.dec(21,2))
      end                                                                                      as grossamount,
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
      a.invoice_qty,
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

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZPF1'
                  or ps.ConditionType = 'ZPF2'
                  or ps.ConditionType = 'ZPF3'
                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as Packing_Charges,


      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZEF1'
                  or ps.ConditionType = 'ZEF2'

                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              / cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            * cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as Freight_charges,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZOT1'
                  or ps.ConditionType = 'ZOT2'
                  or ps.ConditionType = 'ZOT3'
                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as Other_charges,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'JCDB'


                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as Basic_Custom_duty,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZABD'
                  or ps.ConditionType = 'ZDPQ'
                  or ps.ConditionType = 'ZADV'

                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as Discount,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZUC1'
                  or ps.ConditionType = 'ZUC2'

                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as UnloadingCharges,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZLC1'
                  or ps.ConditionType = 'ZLC2'

                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as LoadingCharges,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZHAC'

                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as HandlingCharges,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case
        when a.GRNQty is not initial
         and a.GRNQty is not null
        then
          cast(
            (
      /* 1) Limit precision of condition amount (CURR → DEC(15,2)) */
              case
                when ps.ConditionType = 'ZIS1'
                  or ps.ConditionType = 'ZIS2'
                  or ps.ConditionType = 'ZIS3'

                then cast( ps.ConditionAmount as abap.dec(15,2) )
                else cast( 0 as abap.dec(15,2) )
              end

      /* 2) Multiply by order quantity with limited precision */
              * cast( coalesce( a.orderquantity, 0 ) as abap.dec(15,3) )

            )
      /* 3) Divide by GRNQty (also limited precision) */
            / cast( a.GRNQty as abap.dec(15,3) )
            as abap.dec(15,2)
          )
        else
          cast( 0 as abap.dec(15,2) )
      end                                                                                      as InsuranceCharges,

      a.CGST_Rate,
      a.SGST_Rate,
      //      //      //  cast(a.grossamount as abap.dec(15,2)) * cast(a.CGST_Rate as abap.dec(10,3)) as CGST_VAL,
      //      //      //  cast(a.grossamount as abap.dec(15,2)) * cast(a.SGST_Rate as abap.dec(10,3)) as SGST_VAL,
      cast(a.TaxBaseAmountInCoCodeCrc as abap.dec(15,2)) * cast(a.CGST_Rate as abap.dec(10,3)) as CGST_VAL,
      cast(a.TaxBaseAmountInCoCodeCrc as abap.dec(15,2)) * cast(a.SGST_Rate as abap.dec(10,3)) as SGST_VAL,
      a.IGST_Rate,
      //      //      //  cast(a.grossamount as abap.dec(15,2)) * cast(a.IGST_Rate as abap.dec(10,2))      as IGST_Val,
      cast(a.TaxBaseAmountInCoCodeCrc as abap.dec(15,2)) * cast(a.IGST_Rate as abap.dec(10,2)) as IGST_Val,
      //      //      //  @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      //      //  cast(a.grossamount as abap.dec(15,2)) *
      //      //      //  (
      //      //      //    cast(a.CGST_Rate as abap.dec(10,4)) +  cast(a.SGST_Rate as abap.dec(10,4)) + cast(a.IGST_Rate as abap.dec(10,2))
      //      //      //  )                                                                                as Total_tax_value,

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
      //
      //            //       case when suppinvoice.DebitCreditCode = 'S'
      //            //       then case when matdocitem.DebitCreditCode = 'H' then matdocitem.QuantityInBaseUnit * -1 else matdocitem.QuantityInBaseUnit end
      //            //
      //            //       when suppinvoice.DebitCreditCode = 'H'
      //            //       then case when matdocitem.DebitCreditCode = 'S' and SUBSEQDR.SupplierInvoice is not initial or SUBSEQCR.SupplierInvoice is not initial then matdocitem.QuantityInBaseUnit  end
      //            //
      //            //       else 0 end


      case when a.SupplierInvDrCr = 'S'
      then case when a.MatDocDrCr = 'H' then a.TotalMaterialCost * -1 else a.TotalMaterialCost end

      when a.SupplierInvDrCr = 'H'
      then case when a.MatDocDrCr = 'S' and a.SubseqCredit is not initial or a.SubseqDebit is not initial then a.TotalMaterialCost  end

      else 0 end                                                                               as TotalMaterialCost,

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
      ps.Supplierinvoice1,
      ps.FreightSupplier,
      case
      when  ps.Supplierinvoice1 is not initial
         or ps.Supplierinvoice1 is not null
      then ps.SupplierName1
      else null
      end
      as SupplierName1,
      case
      when ps.Supplierinvoice1 is not initial
         or ps.Supplierinvoice1 is not null
      then  ps.InvoicingParty
      else null 
      end
      as InvoicingParty,
      ps.FreightSupplierName,
      ps.InvoiceID,
      ps.ConditionType,
      ps.ConditionTypeName,
      ps.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
      case
      when ps.Supplierinvoice1 is initial
         or ps.Supplierinvoice1 is null
      then -1 * cast( ps.ConditionAmount as abap.dec(15,2) )
      else cast( ps.ConditionAmount as abap.dec(15,2) )
      end
      as abap.dec(15,2)
      )                                                                                        as balance_amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
cast(
  case 
    when ps.Supplierinvoice1 is not initial
             or ps.Supplierinvoice1 is not null 
      then cast( ps.SupplierInvoiceItemAmount as abap.dec(15,2) )
    else cast( 0 as abap.dec(15,2) )
  end
as abap.dec(15,2)
) as Invoice_recipt,

      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      -1 * cast(
      //         ( cast(PS.ConditionAmount as abap.dec(15,3))
      //           - cast(PS.SupplierInvoiceItemAmount as abap.dec(15,3)) )
      //         as abap.dec(15,2)
      //      )                                                                                        as Pending_Amount,
      cast(
      case
        when ps.Supplierinvoice1 is not  initial
             or ps.Supplierinvoice1 is not null
        then 'No'
        else 'Yes'
      end
      as abap.char(3)
      )                                                                                        as Invoice_post,
      a.AccountingDocument,
      a.GLAccount,
      a.GLAccountName,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
  case 
    when ps.Supplierinvoice1 is not initial or ps.Supplierinvoice1 is not null
      then cast( ps.UnplannedDeliveryCost as abap.dec(15,2) )
    else cast( 0 as abap.dec(15,2) )
  end
as abap.dec(15,2)
) as UnplannedDeliveryCost

}
