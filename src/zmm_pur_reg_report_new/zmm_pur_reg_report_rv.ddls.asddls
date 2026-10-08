@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View of Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_PUR_REG_REPORT_RV 
as select distinct from I_MaterialDocumentItem_2 as MDI
left outer join       I_SuplrInvcItemPurOrdRefAPI01  as suppinvoice         on  suppinvoice.PurchaseOrder               = MDI.PurchaseOrder
                                                                            and suppinvoice.PurchaseOrderItem           = MDI.PurchaseOrderItem
                                                                            and suppinvoice.ReferenceDocument           = MDI.InvtryMgmtReferenceDocument
                                                                            and suppinvoice.ReferenceDocumentItem       = MDI.MaterialDocumentItem
                                                                            and suppinvoice.ReferenceDocumentFiscalYear = MDI.ReferenceDocumentFiscalYear 

left outer join       I_PurchaseOrderItemAPI01       as POI                 on  POI.PurchaseOrder     = MDI.PurchaseOrder
                                                                            and POI.PurchaseOrderItem = MDI.PurchaseOrderItem
                                                                            
left outer join       I_PurchaseOrderAPI01           as PO                  on  PO.PurchaseOrder = MDI.PurchaseOrder                                                                             


left outer join       I_PaymentTermsText             as PTT                 on PTT.PaymentTerms = PO.PaymentTerms

left outer join       I_SupplierInvoiceAPI01         as suppinv             on  suppinv.SupplierInvoice = suppinvoice.SupplierInvoice
                                                                            and suppinv.FiscalYear      = suppinvoice.FiscalYear 
                                                                            
left outer join       I_Supplier                     as supp                on supp.Supplier = suppinv.InvoicingParty                                                                            


                                                                            
left outer join       I_ProductPlantBasic            as PPB                 on PPB.Product = POI.Material
                                                                            and PPB.Plant   = POI.Plant


left outer join       ZMM_ACCONTINGDOC                as fi                 on  fi.suppplierinv  = suppinvoice.SupplierInvoice
                                                                            and fi.supfiscalyear = suppinvoice.FiscalYear
                                                                            and fi.CompanyCode   = MDI.CompanyCode

left outer join       ZMM_ACCONTINGDOC1               as fi2                on  fi2.suppplierinv  = suppinvoice.SupplierInvoice
                                                                            and fi2.supfiscalyear = suppinvoice.FiscalYear
                                                                            and fi2.CompanyCode   = MDI.CompanyCode
                                                                            
left outer join       I_TaxCodeText                  as TCT                 on  TCT.Language = $session.system_language
                                                                            and TCT.TaxCode  = suppinvoice.TaxCode                                                                                       
                                                                            
//left outer join       ZR_COSTS                       as MATCOST            on  MATCOST.PurchasingDocument           = MDI.PurchaseOrder
//                                                                           and MATCOST.PurchasingDocumentItem       = MDI.PurchaseOrderItem
//                                                                           and MATCOST.TransactionTypeDetermination = 'WRX'
//                                                                           and MATCOST.ReferenceDocument            = MDI.MaterialDocument
////                                                                         and MATCOST.ReferenceDocument             = suppinvoice.SupplierInvoice                                                                          
////                                                                         and MATCOST.ReferenceDocumentItem          = cast( suppinvoice.SupplierInvoiceItem as abap.char( 6 ) )                                                                                                               
//                                                                           and MATCOST.ReferenceDocumentItem        = MDI.MaterialDocumentItem
//                                                                           and MATCOST.matfiscalyear                = MDI.MaterialDocumentYear
//                                                                           and MATCOST.matfiscalyear                  = suppinvoice.FiscalYear
//
//left outer join       ZR_COSTS                       as DELCOST            on  DELCOST.PurchasingDocument           = MDI.PurchaseOrder
//                                                                           and DELCOST.PurchasingDocumentItem       = MDI.PurchaseOrderItem
//                                                                           and DELCOST.TransactionTypeDetermination = 'FR1'
//                                                                           and DELCOST.ReferenceDocument            = MDI.MaterialDocument
//                                                                           and DELCOST.ReferenceDocumentItem        = MDI.MaterialDocumentItem
//                                                                           and DELCOST.matfiscalyear                = MDI.MaterialDocumentYear                                                                            
                                                                                
                                                                                                                                                    
left outer join       I_PurOrdAccountAssignmentAPI01 as asset               on  asset.PurchaseOrder     = POI.PurchaseOrder
                                                                            and asset.PurchaseOrderItem = POI.PurchaseOrderItem
                                                                           

left outer join       I_GoodsMovementTypeT           as GMT                 on GMT.GoodsMovementType = MDI.GoodsMovementType
                                                                            and GMT.Language = $session.system_language 
                                                                                                                                                       
                                                                            
left outer join       I_JournalEntryItem             as  JEI                on JEI.PurchasingDocument = suppinvoice.PurchaseOrder
                                                                            and JEI.PurchasingDocumentItem = suppinvoice.PurchaseOrderItem
                                                                            and JEI.ReferenceDocument = suppinvoice.SupplierInvoice
                                                                            and JEI.ReferenceDocumentItem = suppinvoice.SupplierInvoiceItem
                                                                            and JEI.Ledger = '0L'
                                                                            and JEI.TransactionTypeDetermination = 'WRX'
                                                                            and JEI.AccountingDocumentType = 'RE' 
                                                                            //and JEI.OffsettingChartOfAccounts is not initial
                                                                            
                                                                            
left outer join       I_JournalEntry                 as JOI                 on  suppinvoice.SupplierInvoice = substring( JOI.OriginalReferenceDocument, 1, 10 )  
                                                                            and suppinvoice.FiscalYear =  JOI.FiscalYear                                                                              
                                                                            
left outer join       ZMM_PUR_REG_001                 as     FA             on  FA.PurchasingDocument = suppinvoice.PurchaseOrder
                                                                            and FA.PurchasingDocumentItem = suppinvoice.PurchaseOrderItem
                                                                            and FA.ReferenceDocument = suppinvoice.ReferenceDocument
                                                                            and FA.FiscalYear             = suppinvoice.FiscalYear
                                                                            and FA.CompanyCode            = MDI.CompanyCode                                                                             
                                                                            
                                                                            
left outer join       ZMM_PUR_REG_002                 as     RA               on RA.AccountingDocument = JOI.AccountingDocument
                                                                             and RA.FiscalYear = JOI.FiscalYear                                                                            
                                                                            
                                                                            
left outer join      ZMM_PUR_REG_003                  as     IC               on IC.PurchasingDocument = suppinvoice.PurchaseOrder
                                                                             and IC.PurchasingDocumentItem = suppinvoice.PurchaseOrderItem 
                                                                             and IC.ReferenceDocument = suppinvoice.SupplierInvoice
                                                                             and IC.ReferenceDocumentItem = suppinvoice.SupplierInvoiceItem
                                                                             and IC.FiscalYear      = suppinvoice.FiscalYear  
                                                                                   
//left outer join       ZMM_SUBSEQUENT                   as      SUBSEQDR      on SUBSEQDR.PurchaseOrder     = suppinvoice.PurchaseOrder
//                                                                             and SUBSEQDR.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
//                                                                             and SUBSEQDR.SupplierInvoice   = suppinvoice.SupplierInvoice
//                                                                             and SUBSEQDR.SupplierInvoiceItem = suppinvoice.SupplierInvoiceItem
//                                                                             and SUBSEQDR.DebitCreditCode = 'S'
//                                                                             
//left outer join       ZMM_SUBSEQUENT                   as      SUBSEQCR       on SUBSEQCR.PurchaseOrder     = suppinvoice.PurchaseOrder
//                                                                             and SUBSEQCR.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
//                                                                             and SUBSEQCR.SupplierInvoice   = suppinvoice.SupplierInvoice
//                                                                             and SUBSEQCR.SupplierInvoiceItem = suppinvoice.SupplierInvoiceItem
//                                                                             and SUBSEQCR.DebitCreditCode = 'H'                                                                                                    
                                                                                                                                          
                                                                            
{
     key  MDI.MaterialDocument        as Material_Document,
     key  MDI.MaterialDocumentYear    as Material_Document_Year,                                                                                                                                                                     
     key  MDI.MaterialDocumentItem    as Material_Document_Item,                                                                                                                                                                   
     key  MDI.PurchaseOrder           as Purchase_Order,
     key  MDI.PurchaseOrderItem       as Purchase_Order_Item,
     key  suppinvoice.SupplierInvoice as Supplier_Invoice,
     key  suppinvoice.SupplierInvoiceItem as SupplierInvoice_Item,
     key  suppinvoice.FiscalYear      as SupplierInvoice_Year,
     key  MDI.CompanyCode             as Company_Code,
     key  JOI.AccountingDocument      as Accounting_Document,
     key  MDI.DocumentDate            as Material_Document_Date,
     key  MDI.GoodsMovementType       as Goods_Movement_Type,
     key  suppinv.SupplierInvoiceIDByInvcgParty as Supplier_Invoice_ID,
     key  suppinv.DocumentDate        as Supplier_Invoice_Date,
     key  suppinv.InvoicingParty      as Supplier,
     key  suppinv.PostingDate         as Supplier_Invoice_Posting_Date, 
     key   POI.PurchaseRequisition     as Purchase_Requisition,
     key   POI.Material                as Material,
     key   POI.PurchaseOrderItemText   as Purchase_Order_Item_Text,
     key   POI.MaterialGroup           as Material_Group,
     key   POI.MaterialType            as Material_Type,          
          substring( JOI.OriginalReferenceDocument, 1, 10 )  as ACC,
          @Semantics.amount.currencyCode: 'Document_Currency'
          suppinvoice.SupplierInvoiceItemAmount as gross_amount,
          suppinvoice.DocumentCurrency as Document_Currency,
          suppinvoice.TaxCode         as Tax_Code,
          suppinvoice.DebitCreditCode as SupplierInvDrCr,
          MDI.DebitCreditCode         as MatDocDrCr,        
          supp.SupplierName           as Supplier_Name,
          supp.TaxNumber3             as Supplier_GSTIN,
          supp.Region                 as Supplier_Region,
          supp.Country                as Supplier_Country,
          supp.StreetName             as Supplier_Street,
          supp.CityName               as Supplier_CityName,
          supp.PostalCode 			  as Supplier_PostalCode,
          PO.CreationDate             as Purchase_Order_Creation_Date,
          PO.IncotermsClassification  as Purchase_Order_Incoterms,
          PO.PaymentTerms             as Purchase_Order_Payment_Terms,
          PTT.PaymentTermsName as Purchase_Order_PaymTerms_Des,
          PO.PurchaseOrderType        as Purchase_Order_Type,
          PO.CreatedByUser            as Created_By,
          GMT.GoodsMovementTypeName   as Goods_Movement_TypeDescription,
          PPB.ConsumptionTaxCtrlCode  as HSN_Code,
          //@Semantics.amount.currencyCode: 'TransactionCurrency'
          //JEI.AmountInCompanyCodeCurrency as Taxable_Amount,
          JEI.TransactionCurrency ,
//       case
//           when suppinvoice.TaxCode = 'I1' then cast('0.09' as abap.dec( 10, 0 ))
//           when suppinvoice.TaxCode = 'I2' then cast('0.025' as abap.dec( 10, 1 ))
//           when suppinvoice.TaxCode = 'I3' then cast('0.07' as abap.dec( 10, 0 ))
//           when suppinvoice.TaxCode = 'I4' then cast('0.06' as abap.dec( 10, 0 ))
//           when suppinvoice.TaxCode = 'I9' then cast('0.015' as abap.dec( 10, 0 ))
//           when suppinvoice.TaxCode = 'G9' then cast('0.025' as abap.dec( 10, 1 ))
//           when suppinvoice.TaxCode = 'GA' then cast('0.025' as abap.dec( 10, 1 ))
//           else null
//       end as CGST_Rate,
       case
    when suppinvoice.TaxCode = 'I1'
        then cast( 9 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I2'
        then cast( 2.5 as abap.dec( 10, 1 ) )

    when suppinvoice.TaxCode = 'I3'
        then cast( 7 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I4'
        then cast( 6 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I9'
        then cast( 1.5 as abap.dec( 10, 1 ) )

    when suppinvoice.TaxCode = 'G9'
        then cast( 2.5 as abap.dec( 10, 1 ) )

    when suppinvoice.TaxCode = 'GA'
        then cast( 2.5 as abap.dec( 10, 1 ) )

    else null
end as CGST_Rate,

//       case
//           when suppinvoice.TaxCode = 'I1' then cast('0.09' as abap.dec( 10, 3 ))
//           when suppinvoice.TaxCode = 'I2' then cast('0.025' as abap.dec( 10, 3 ) )
//           when suppinvoice.TaxCode = 'I3' then cast('0.07' as abap.dec( 10, 3 ))
//           when suppinvoice.TaxCode = 'I4' then cast('0.06' as abap.dec( 10, 3 ))
//           when suppinvoice.TaxCode = 'I9' then cast('0.015' as abap.dec( 10, 3 ))
//           when suppinvoice.TaxCode = 'G9' then cast('0.025' as abap.dec( 10, 3 ))
//           when suppinvoice.TaxCode = 'GA' then cast('0.025' as abap.dec( 10, 3 ))
//           else null
//       end  as SGST_Rate,
    
      case
    when suppinvoice.TaxCode = 'I1'
        then cast( 9 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I2'
        then cast( 2.5 as abap.dec( 10, 1 ) )

    when suppinvoice.TaxCode = 'I3'
        then cast( 7 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I4'
        then cast( 6 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I9'
        then cast( 1.5 as abap.dec( 10, 1 ) )

    when suppinvoice.TaxCode = 'G9'
        then cast( 2.5 as abap.dec( 10, 1 ) )

    when suppinvoice.TaxCode = 'GA'
        then cast( 2.5 as abap.dec( 10, 1 ) )

    else null

end as SGST_Rate,

//       case
//           when suppinvoice.TaxCode = 'G0' then cast('0.00' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'G3' then cast('0.18' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'GI' then cast('0.05' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'H1' then cast('0.18' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'H2' then cast('0.18' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'I5' then cast('0.18' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'I6' then cast('0.05' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'I7' then cast('0.28' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'I8' then cast('0.12' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'IA' then cast('0.03' as abap.dec( 10, 2 ))
//           when suppinvoice.TaxCode = 'K1' then cast('0.18' as abap.dec( 10, 2 ))
//           else null
//       end as IGST_Rate,

       case
    when suppinvoice.TaxCode = 'G0'
        then cast( 0 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'G3'
        then cast( 18 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'GI'
        then cast( 5 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'H1'
        then cast( 18 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'H2'
        then cast( 18 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I5'
        then cast( 18 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I6'
        then cast( 5 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I7'
        then cast( 28 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'I8'
        then cast( 12 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'IA'
        then cast( 3 as abap.dec( 10, 0 ) )

    when suppinvoice.TaxCode = 'K1'
        then cast( 18 as abap.dec( 10, 0 ) )

    else null

end as IGST_Rate,
       
           TCT.TaxCodeName as Tax_Code_Description,
           
           cast(suppinv.ExchangeRate   as abap.dec( 15,2) ) as ExchangeRate,
           
      case 
          when POI.AccountAssignmentCategory = 'A' then asset.MasterFixedAsset 
          else  '' 
          end  as WBS,
          
         @Semantics.quantity.unitOfMeasure: 'Order_Unit'
       ( case when suppinvoice.DebitCreditCode = 'S'
           then abs(suppinvoice.QuantityInPurchaseOrderUnit)
           when suppinvoice.DebitCreditCode = 'H'
           then (-1*abs(suppinvoice.QuantityInPurchaseOrderUnit))
           else suppinvoice.QuantityInPurchaseOrderUnit
       end )  as invoice_qty_real ,
         
           suppinvoice.PurchaseOrderQuantityUnit as Order_Unit,
           
           
           
           
           
     case when suppinvoice.TaxCode = 'G9' or suppinvoice.TaxCode = 'GA' or suppinvoice.TaxCode = 'GI'
       then
       ( case when suppinvoice.DebitCreditCode = 'S'
            then abs(fi2.CompensationCess)
            when suppinvoice.DebitCreditCode = 'H'
            then (-1*abs(fi2.CompensationCess))
            else fi2.CompensationCess
        end )
        else 0  end   as CompensationCess,   
        
        
        cast(cast(suppinvoice.SupplierInvoiceItemAmount as abap.dec(13,3))*( 1 + coalesce($projection.CGST_Rate,0) + coalesce($projection.SGST_Rate,0) + coalesce($projection.IGST_Rate,0)) as abap.dec(13,3)) as TempInvVal,

//       case when suppinvoice.DebitCreditCode = 'S'
//             then abs( $projection.TempInvVal )
//             when suppinvoice.DebitCreditCode = 'H'
//             then (-1*abs($projection.TempInvVal))
//             else $projection.TempInvVal
//         end   as InvoiceValue,
         
//       coalesce(MATCOST.Amt,0)   as TotalMaterialCost,
//       coalesce(DELCOST.Amt,0)   as TotalDeliveryCost,
//       coalesce(MATCOST.Amt,0) + coalesce(DELCOST.Amt,0)  as TotalCost,
       
       
   case
     when FA.Frigtamount is null
     then cast( 0 as abap.dec(15,2) )

    when RA.PostingKey = '' or RA.PostingKey is null
    then cast( FA.Frigtamount as abap.dec(15,2) ) * -1

    else
    cast( FA.Frigtamount as abap.dec(15,2) )
   end as Frigtamount,
   RA.PostingKey as Posting_Key,
   
   case
    when suppinvoice.DebitCreditCode = 'S'
        then 'Invoice'
    when suppinvoice.DebitCreditCode = 'H'
        then 'Credit Memo / Cancelled'
    else ''
   end as PostingType,
   
   IC.ReversalReferenceDocument as CancelMiro,
   IC.IsReversal,
   @Semantics.amount.currencyCode: 'suppcur'
//   suppinvoice.SupplierInvoiceItemAmount as Taxable_Amount,
   case
    when suppinvoice.DebitCreditCode = 'H'
    //RA.PostingKey = '21'
        then suppinvoice.SupplierInvoiceItemAmount * -1
    else suppinvoice.SupplierInvoiceItemAmount
end as Taxable_Amount,
   suppinvoice.DocumentCurrency as suppcur
   
//   SUBSEQCR.SupplierInvoiceItemAmount as SubseqCreditAmt,
//   SUBSEQDR.SupplierInvoiceItemAmount as SubseqDebitAmt

    
} 
where
       MDI.PurchaseOrder     is not initial
  and(
       MDI.GoodsMovementType = '101'
    //or MDI.GoodsMovementType = '102'
    or MDI.GoodsMovementType = '103'
    or MDI.GoodsMovementType = '104'
    or MDI.GoodsMovementType = '105'
    or MDI.GoodsMovementType = '106'
    or MDI.GoodsMovementType = '121'
    //or MDI.GoodsMovementType = '122'
    or MDI.GoodsMovementType = '161'
    or MDI.GoodsMovementType = '162'
)
and suppinvoice.SupplierInvoice is not initial



