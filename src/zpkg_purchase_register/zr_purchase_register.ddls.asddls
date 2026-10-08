@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PURCHASE_REGISTER
  as select distinct from I_MaterialDocumentItem_2       as matdocitem
    inner join            zdt_user_auth                  as user           on  user.cbuser      = $session.user
                                                                           and user.companycode = matdocitem.CompanyCode
    left outer join       I_SuplrInvcItemPurOrdRefAPI01  as suppinvoice    on  suppinvoice.PurchaseOrder               = matdocitem.PurchaseOrder
                                                                           and suppinvoice.PurchaseOrderItem           = matdocitem.PurchaseOrderItem
//                                                                           and suppinvoice.ReferenceDocument           = matdocitem.MaterialDocument
//                                                                           and suppinvoice.ReferenceDocumentItem       = matdocitem.MaterialDocumentItem
//                                                                           and suppinvoice.ReferenceDocumentFiscalYear = matdocitem.MaterialDocumentYear
                                                                            and suppinvoice.ReferenceDocument           = matdocitem.InvtryMgmtReferenceDocument
                                                                            and suppinvoice.ReferenceDocumentItem       = matdocitem.MaterialDocumentItem
                                                                            and suppinvoice.ReferenceDocumentFiscalYear = matdocitem.ReferenceDocumentFiscalYear 
 


    left outer join       I_PurchaseOrderItemAPI01       as purchaseorder  on  purchaseorder.PurchaseOrder     = matdocitem.PurchaseOrder
                                                                           and purchaseorder.PurchaseOrderItem = matdocitem.PurchaseOrderItem

    left outer join       ZR_PURCHASE_REGISTER_2         as purchaseorder1 on  purchaseorder1.PurchaseOrder     = matdocitem.PurchaseOrder
                                                                           and purchaseorder1.PurchaseOrderItem = matdocitem.PurchaseOrderItem

    left outer join       I_PurchaseRequisitionItemAPI01 as purreq         on  purreq.PurchaseRequisition     = purchaseorder.PurchaseRequisition
                                                                           and purreq.PurchaseRequisitionItem = purchaseorder.PurchaseRequisitionItem
    left outer join       I_PurchaseOrderAPI01           as porder         on porder.PurchaseOrder = matdocitem.PurchaseOrder
//    left outer join       I_Supplier                     as supp           on supp.Supplier = matdocitem.Supplier
    left outer join       I_PaymentTermsText             as paytermstext   on paytermstext.PaymentTerms = porder.PaymentTerms
    left outer join       I_SupplierInvoiceAPI01         as suppinv        on  suppinv.SupplierInvoice = suppinvoice.SupplierInvoice
                                                                           and suppinv.FiscalYear      = suppinvoice.FiscalYear
    left outer join       I_Supplier                     as supp           on supp.Supplier = suppinv.InvoicingParty                                                                          
    left outer join       I_ProductPlantBasic            as hsn            on  hsn.Product = purchaseorder.Material
                                                                           and hsn.Plant   = purchaseorder.Plant

    left outer join       ZR_ACCONTINGDOC                as fi             on  fi.suppplierinv  = suppinvoice.SupplierInvoice
                                                                           and fi.supfiscalyear = suppinvoice.FiscalYear
                                                                           and fi.CompanyCode   = matdocitem.CompanyCode

    left outer join       ZR_ACCONTINGDOC1               as fi2            on  fi2.suppplierinv  = suppinvoice.SupplierInvoice
                                                                           and fi2.supfiscalyear = suppinvoice.FiscalYear
                                                                           and fi2.CompanyCode   = matdocitem.CompanyCode

    left outer join       I_TaxCodeText                  as txtext         on  txtext.Language = $session.system_language
                                                                           and txtext.TaxCode  = suppinvoice.TaxCode

  //    left outer join     I_MaterialDocumentItemTP         as matdocitem1   on matdocitem1.MaterialDocument = matdocitem.MaterialDocument
  //                                                                            and matdocitem1.MaterialDocumentYear = matdocitem.MaterialDocumentYear
  //                                                                            and matdocitem1.MaterialDocumentItem = matdocitem.MaterialDocumentItem
  //
  // New fields
    left outer join       ZR_CREDITMEMO                  as CRMEMO         on  CRMEMO.ReferenceDocument           = matdocitem.MaterialDocument
                                                                           and CRMEMO.ReferenceDocumentItem       = matdocitem.MaterialDocumentItem
                                                                           and CRMEMO.ReferenceDocumentFiscalYear = matdocitem.MaterialDocumentYear
                                                                           and CRMEMO.PurchaseOrder               = matdocitem.PurchaseOrder
                                                                           and CRMEMO.PurchaseOrderItem           = matdocitem.PurchaseOrderItem
                                                                           and CRMEMO.SupplierInvoice             = suppinvoice.SupplierInvoice
                                                                           and CRMEMO.SupplierInvoiceItem         = suppinvoice.SupplierInvoiceItem
                                                                           and CRMEMO.FiscalYear                  = suppinvoice.FiscalYear

    left outer join       ZR_SUBSEQUENT                  as SUBSEQCR       on  SUBSEQCR.ReferenceDocument           = matdocitem.MaterialDocument
                                                                          and SUBSEQCR.ReferenceDocumentItem       = matdocitem.MaterialDocumentItem
                                                                           and SUBSEQCR.ReferenceDocumentFiscalYear = matdocitem.MaterialDocumentYear
                                                                          and  SUBSEQCR.PurchaseOrder               = matdocitem.PurchaseOrder
                                                                           and SUBSEQCR.PurchaseOrderItem           = matdocitem.PurchaseOrderItem
                                                                           and SUBSEQCR.SupplierInvoice             = suppinvoice.SupplierInvoice
                                                                           and SUBSEQCR.SupplierInvoiceItem         = suppinvoice.SupplierInvoiceItem
                                                                           and SUBSEQCR.FiscalYear                  = suppinvoice.FiscalYear
                                                                           and SUBSEQCR.DebitCreditCode             = 'S'

    left outer join       ZR_SUBSEQUENT                  as SUBSEQDR       on  SUBSEQDR.ReferenceDocument           = matdocitem.MaterialDocument
                                                                           and SUBSEQDR.ReferenceDocumentItem       = matdocitem.MaterialDocumentItem
                                                                           and SUBSEQDR.ReferenceDocumentFiscalYear = matdocitem.MaterialDocumentYear
                                                                           and SUBSEQDR.PurchaseOrder               = matdocitem.PurchaseOrder
                                                                           and SUBSEQDR.PurchaseOrderItem           = matdocitem.PurchaseOrderItem
                                                                           and SUBSEQDR.SupplierInvoice             = suppinvoice.SupplierInvoice
                                                                           and SUBSEQDR.SupplierInvoiceItem         = suppinvoice.SupplierInvoiceItem
                                                                           and SUBSEQDR.FiscalYear                  = suppinvoice.FiscalYear
                                                                           and SUBSEQDR.DebitCreditCode             = 'H'

    left outer join       ZR_COSTS                       as MATCOST        on  MATCOST.PurchasingDocument           = matdocitem.PurchaseOrder
                                                                           and MATCOST.PurchasingDocumentItem       = matdocitem.PurchaseOrderItem
                                                                           and MATCOST.TransactionTypeDetermination = 'WRX'
                                                                           and MATCOST.ReferenceDocument            = matdocitem.MaterialDocument
                                                                           and MATCOST.ReferenceDocumentItem        = matdocitem.MaterialDocumentItem
                                                                           and MATCOST.matfiscalyear                = matdocitem.MaterialDocumentYear


    left outer join       ZR_COSTS                       as DELCOST        on  DELCOST.PurchasingDocument           = matdocitem.PurchaseOrder
                                                                           and DELCOST.PurchasingDocumentItem       = matdocitem.PurchaseOrderItem
                                                                           and DELCOST.TransactionTypeDetermination = 'FR1'
                                                                           and DELCOST.ReferenceDocument            = matdocitem.MaterialDocument
                                                                           and DELCOST.ReferenceDocumentItem        = matdocitem.MaterialDocumentItem
                                                                           and DELCOST.matfiscalyear                = matdocitem.MaterialDocumentYear

    left outer join       I_EnterpriseProject            as EP             on EP.WBSElementInternalID = matdocitem.WBSElementInternalID

    left outer join       I_PurOrdAccountAssignmentAPI01 as asset          on  asset.PurchaseOrder     = purchaseorder.PurchaseOrder
                                                                           and asset.PurchaseOrderItem = purchaseorder.PurchaseOrderItem
                                                                           
    left outer join I_GoodsMovementTypeT              as goodmovetype       on goodmovetype.GoodsMovementType = matdocitem.GoodsMovementType
                                                                           and goodmovetype.Language = $session.system_language 
                                                                            
    left outer join I_SupplierInvoiceTaxAPI01 as suppinvtax           on  suppinvtax.SupplierInvoice = suppinvoice.SupplierInvoice
                                                                           and suppinvtax.FiscalYear      = suppinvoice.FiscalYear
                                                                           
    left outer join I_PurOrdItmPricingElementAPI01 as pricingelement        on pricingelement.PurchaseOrder      = suppinvoice.PurchaseOrder
                                                                            and pricingelement.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
//                                                                            and  pricingelement.FreightSupplier     = supp.Supplier
                                                                            and ( pricingelement.ConditionType     = 'ZEF1' or pricingelement.ConditionType     = 'ZEF2' )
                                                                            and pricingelement.ConditionAmount <> 0
                                                                            
    left outer join I_JournalEntry     as JOI         on   suppinvoice.SupplierInvoice =    substring( JOI.OriginalReferenceDocument, 1, 10 )  
                                                       and suppinvoice.FiscalYear =  JOI.FiscalYear           
   
//    left outer join I_OperationalAcctgDocItem             as JEI1                  on  matdocitem.PurchaseOrder = JEI1.PurchasingDocument
//                                                                                    and matdocitem.PurchaseOrderItem =JEI1.PurchasingDocumentItem
//                                                                                    and JEI1.Supplier <> ''
//                                                                                    and JEI1.TaxCode <> ''
//                                                                                    and JEI1.DebitCreditCode = 'H'
//                                                                      //      and matdocitem.MaterialDocumentItem = substring(JEI1.ReferenceDocumentItem, 3,6)
                                                                        //    and JEI1.Ledger = '0L'
                                                                         //   and JEI1.TransactionTypeDetermination = 'KBS'
    
    
                                                         
    left outer join I_JournalEntryItem             as    JEI                on JEI.PurchasingDocument = suppinvoice.PurchaseOrder
                                                                            and JEI.PurchasingDocumentItem = suppinvoice.PurchaseOrderItem
                                                                            and JEI.ReferenceDocument = suppinvoice.ReferenceDocument
                                                                            and JEI.Ledger = '0L'
                                                                            and JEI.TransactionTypeDetermination = 'EIN'


//left outer join I_JournalEntryItem             as    JEI                //on JEI.PurchasingDocument = matdocitem.PurchaseOrder
//                                                                          //  and JEI.PurchasingDocumentItem = matdocitem.PurchaseOrderItem
//                                                                            on JEI.ReferenceDocument = matdocitem.MaterialDocument
//                                                                            and JEI.Ledger = '0L'
//                                                                            and JEI.TransactionTypeDetermination = 'EIN'
    
    left outer join ZR_PURCHASE_REG_002            as     FA                on  FA.PurchasingDocument = suppinvoice.PurchaseOrder
                                                                            and FA.PurchasingDocumentItem = suppinvoice.PurchaseOrderItem
                                                                            and FA.ReferenceDocument = suppinvoice.ReferenceDocument 
                                                                            
//    left outer join ZR_PURCHASE_TAX                 as    PT                on PT.AccountingDocument = JOI.AccountingDocument
//                                                                           and PT.FiscalYear = JOI.FiscalYear                                                                           
                                                                                                                                   
    
   
    left outer join  ZTest                          as     ZT              // on ZT.PurchasingDocument = purchaseorder.PurchaseOrder
                                                                          // and ZT.PurchasingDocumentItem = purchaseorder.PurchaseOrderItem                                                                                                            
                                                                            on ZT.AccountingDocument = JOI.AccountingDocument                                                                 
                                                                        //   and ZT.AccountingDocumentItem = JEI1.AccountingDocumentItem 
                                                                           and ZT.FiscalYear = JOI.FiscalYear
                                                                           //and ZT.ReferenceDocument =  suppinvoice.ReferenceDocument 
                                                                           //and ZT.LedgerGLLineItem = suppinvoice.ReferenceDocumentItem  
//   left outer join  ZR_PURCHASE_TAX                 as CGST                 on CGST.PurchaseOrder =  suppinvoice.PurchaseOrder
//                                                                            and CGST.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
//                                                                            and CGST.TransactionTypeDetermination = 'JIC'                                                                   
//  
//   left outer join  ZR_PURCHASE_TAX                 as SGST                 on SGST.PurchaseOrder =  suppinvoice.PurchaseOrder
//                                                                            and SGST.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
//                                                                            and SGST.TransactionTypeDetermination = 'JIS'
//                                                                            
//  left outer join  ZR_PURCHASE_TAX                 as IGST                  on IGST.PurchaseOrder =  suppinvoice.PurchaseOrder
//                                                                            and IGST.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
//                                                                            and IGST.TransactionTypeDetermination = 'JII'
//  

left outer join  ZR_PURCHASE_TAX                 as CGST                 on    CGST.PurchaseOrder =  suppinvoice.PurchaseOrder
                                                                          and CGST.PurchaseOrderItem = suppinvoice.PurchaseOrderItem
                                                                          //and CGST.SupplierInvoice = suppinvoice.SupplierInvoice     // added 06-07-26
                                                                          //and CGST.SupplierInvoiceItem = suppinvoice.SupplierInvoiceItem
                                                                        
{
  key  matdocitem.MaterialDocument                                                                                                                                                                            as Material_Document,
  key  matdocitem.MaterialDocumentYear                                                                                                                                                                        as Material_Document_Year,
  key  matdocitem.MaterialDocumentItem                                                                                                                                                                        as Material_Document_Item,
  key  matdocitem.PurchaseOrder                                                                                                                                                                               as Purchase_Order,
  key  suppinvoice.SupplierInvoice                                                                                                                                                                            as SupplierInvoice,
  key  suppinvoice.SupplierInvoiceItem                                                                                                                                                                        as SupplierInvoiceItem,
  key  suppinvoice.FiscalYear                                                                                                                                                                                 as Material_DocumentYear,
   key  matdocitem.PurchaseOrderItem                                                                                                                                                                           as Purchase_OrderItem,
   key     JOI.AccountingDocument,
    substring( JOI.OriginalReferenceDocument, 1, 10 )  as ACC,
       //  suppinvoice.SupplierInvoice                    as SupplierInvoice,

       purchaseorder.PurchaseRequisition                                                                                                                                                                      as Purchasereq,
       purchaseorder.PurchaseRequisitionItem                                                                                                                                                                  as Purchase_Req_Item,
       purreq.PurchaseRequisitionReleaseDate                                                                                                                                                                  as Purchase_Req_Release_Date,
       purreq.PurchaseReqnCreationDate                                                                                                                                                                        as PurchaseReqDate,
       purreq.CreatedByUser                                                                                                                                                                                   as PRCreatedBy,
       matdocitem.PostingDate                                                                                                                                                                                 as postingdate,
       matdocitem.CompanyCode                                                                                                                                                                                 as CompanyCode,
       suppinv.InvoicingParty                                                                                                                                                                                    as supplier,
       supp.TaxNumber3                                                                                                                                                                                        as supgstin,


       //      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
       //      @DefaultAggregation: #SUM
       //      matdocitem.QuantityInEntryUnit                           as Receipt_Quantity ,
       matdocitem.EntryUnit                                                                                                                                                                                   as Receipt_UOM,
       matdocitem.InventoryValuationType                                                                                                                                                                    as ValuationType1,
//       matdocitem.GoodsMovementType                                                                                                                                                                          as MovementType,
       porder.PurchaseOrderType                                                                                                                                                                               as DocumentType,
       //       matdocitem.WBSElementInternalID
       //       EP.Project                                                                                                                                                                                             as WBS,
       case when purchaseorder.AccountAssignmentCategory = 'A' then asset.MasterFixedAsset else  '' end                                                                                                       as WBS,
       supp.SupplierName                                                                                                                                                                                      as SupplierName,
       supp.Region                                                                                                                                                                                            as SupplierRegion,
       supp.Country                                                                                                                                                                                           as SupplierCountry,
       supp.StreetName                                                                                                                                                                                        as Streetname,
       supp.CityName                                                                                                                                                                                          as Cityname,
       supp.PostalCode                                                                                                                                                                                        as PostalCode,
       porder.CreationDate                                                                                                                                                                                    as PO_Creation_Date,
       porder.IncotermsClassification                                                                                                                                                                         as Incoterms,
       porder.PaymentTerms                                                                                                                                                                                    as Payment_Terms,
       paytermstext.PaymentTermsName                                                                                                                                                                          as Payment_Terms_Description,
       porder.CreatedByUser                                                                                                                                                                                   as createdby,
       purchaseorder.DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //purchaseorder.GrossAmount                                                                                                                                                                              as grossamount,
       suppinvoice.SupplierInvoiceItemAmount                                                                                                                                                                    as grossamount,
       purchaseorder.Material,
       purchaseorder.MaterialGroup                                                                                                                                                                            as MaterialGroup,
       purchaseorder.MaterialType                                                                                                                                                                             as MaterialTyp,
       purchaseorder.PurchaseOrderItemText                                                                                                                                                                    as PoItemText,
       hsn.ConsumptionTaxCtrlCode                                                                                                                                                                             as hsn,
       purchaseorder.PurchaseOrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       purchaseorder.OrderQuantity                                                                                                                                                                            as orderquantity,
       purchaseorder.PurchaseOrderQuantityUnit                                                                                                                                                                as POorderUOM,
       //  purchaseorder.DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       purchaseorder.NetPriceAmount                                                                                                                                                                           as NetAmount,
       purchaseorder1.BasePrice                                                                                                                                                                               as NetAmount,
       suppinvoice.TaxCode                                                                                                                                                                                    as Taxcode,
       txtext.TaxCodeName                                                                                                                                                                                     as TaxcodeText,
       suppinvoice.DocumentCurrency                                                                                                                                                                           as doc_currency,
       suppinv.DocumentDate                                                                                                                                                                                   as documentdate,
       suppinv.PostingDate                                                                                                                                                                                    as InvoicePostingDate,
       suppinv.SupplierInvoiceIDByInvcgParty                                                                                                                                                                  as SupplierInvoiceID,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
//         ( FA.Frigtamount * -1 ) as Frigtamount,
//       FA.Frigtamount,
  case
  when FA.Frigtamount is null
    then cast( 0 as abap.dec(15,2) )

when ZT.PostingKey = '' or ZT.PostingKey is null
    then cast( FA.Frigtamount as abap.dec(15,2) ) * -1

  else
    cast( FA.Frigtamount as abap.dec(15,2) )
end as Frigtamount,
//         FA.Frigtcury,
//       case
//        when ZT.PostingKey = '21'
//       then -1 * abs( FA.Frigtamount )
//        else abs( FA.Frigtamount )
//        end as Frigtamount,
       FA.Frigtcury,
       cast(suppinv.ExchangeRate   as abap.dec( 15,2) )                                                                                                                                                       as ExchangeRate,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
//       case when suppinvoice.DebitCreditCode = 'S'
//            then abs(suppinvoice.SupplierInvoiceItemAmount)
//            when suppinvoice.DebitCreditCode = 'H'
//            then (-1*abs(suppinvoice.SupplierInvoiceItemAmount))
//            else suppinvoice.SupplierInvoiceItemAmount
//        end                                                                                                                                                                                                   as TaxBaseAmountInCoCodeCrc,
        suppinvtax.TaxAmount                                                                                                                                                                                   as TaxBaseAmountInCoCodeCrc,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
//       cast( JEI.AmountInCompanyCodeCurrency as abap.dec(15,2) ) as JEIamount,
         JEI.AmountInCompanyCodeCurrency as JEIamount,
         JEI.TransactionCurrency,
        ZT.PostingKey,
//        @Semantics.amount.currencyCode: 'Ccurry'
//        CGST.AmountInCompanyCodeCurrency as FreightCGST,
//        CGST.CompanyCodeCurrency as Ccurry,
//        @Semantics.amount.currencyCode: 'Scurry'
//        SGST.AmountInCompanyCodeCurrency as FreightSGST,
//        SGST.CompanyCodeCurrency as Scurry,
//        @Semantics.amount.currencyCode: 'Icurry'
//        IGST.AmountInCompanyCodeCurrency as FreightIGST,
//        IGST.CompanyCodeCurrency as Icurry,

          @Semantics.amount.currencyCode: 'Ccurry'
      case
          when CGST.TransactionTypeDetermination = 'JIC'
          then CGST.AmountInCompanyCodeCurrency
          else null
          end as FreightCGST,
        
        CGST.CompanyCodeCurrency as Ccurry,
        
        @Semantics.amount.currencyCode: 'Scurry'
        
         case
             when CGST.TransactionTypeDetermination = 'JIC'
             then CGST.AmountInCompanyCodeCurrency
             else null
             end as FreightSGST,
        
        CGST.CompanyCodeCurrency as Scurry,
        @Semantics.amount.currencyCode: 'Icurry'
        
        case
             when CGST.TransactionTypeDetermination = 'JII'
             then CGST.AmountInCompanyCodeCurrency
             else null
             end as FreightIGST,
        
        CGST.CompanyCodeCurrency as Icurry,
         
         
        

       case when suppinvoice.TaxCode = 'G9' or suppinvoice.TaxCode = 'GA' or suppinvoice.TaxCode = 'GI'
       then
       ( case when suppinvoice.DebitCreditCode = 'S'
            then abs(fi2.CompensationCess)
            when suppinvoice.DebitCreditCode = 'H'
            then (-1*abs(fi2.CompensationCess))
            else fi2.CompensationCess
        end )
        else 0  end                                                                                                                                                                                           as CompensationCess,


       suppinvoice.PurchaseOrderQuantityUnit                                                                                                                                                                  as Purchaseorderquanunit,
       @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       case when suppinvoice.TaxCode = 'G9' or suppinvoice.TaxCode = 'GA' or suppinvoice.TaxCode = 'GI'
       then
       ( case when suppinvoice.DebitCreditCode = 'S'
           then abs(suppinvoice.QuantityInPurchaseOrderUnit)
           when suppinvoice.DebitCreditCode = 'H'
           then (-1*abs(suppinvoice.QuantityInPurchaseOrderUnit))
           else suppinvoice.QuantityInPurchaseOrderUnit
       end )
       else cast(0 as abap.quan( 13 )) end                                                                                                                                                                    as invoice_qty,
       @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       ( case when suppinvoice.DebitCreditCode = 'S'
           then abs(suppinvoice.QuantityInPurchaseOrderUnit)
           when suppinvoice.DebitCreditCode = 'H'
           then (-1*abs(suppinvoice.QuantityInPurchaseOrderUnit))
           else suppinvoice.QuantityInPurchaseOrderUnit
       end )                                                                                                                                                                                                  as invoice_qty_real,
       purchaseorder.IsCompletelyDelivered                                                                                                                                                                    as Po_status,
       

       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZPF1' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZPF2' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZPF3'
       //       then suppinvoice.SupplierInvoiceItemAmount
       //
       //       end                                                                                                                                                                                                    as Packing_charges,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZEF1' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZEF2' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZIF1' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZIF2'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as Freight_charges,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZOT1' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZOT2' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZOT3'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as Other_charges,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'JCDB'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as Basic_Custom_duty,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZABD' or  suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZDPQ' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZADV'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as Discount,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZUC1' or  suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZUC2'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as UnloadingCharges,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZLC1' or  suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZLC2'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as LoadingCharges,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZHAC'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as HandlingCharges,
       //       @Semantics.amount.currencyCode: 'DocumentCurrency'
       //       case
       //       when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZIS1' or  suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZIS2' or suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZIS3'
       //       then suppinvoice.SupplierInvoiceItemAmount end                                                                                                                                                         as InsuranceCharges,

           matdocitem.GoodsMovementType as Movement_type,
           goodmovetype.GoodsMovementTypeName as Movement_Type_Description,
       case
       when suppinvoice.TaxCode = 'I1' then cast('0.09' as abap.dec( 10, 3 ))
       when suppinvoice.TaxCode = 'I2' then cast('0.025' as abap.dec( 10, 3 ) )
       when suppinvoice.TaxCode = 'I3' then cast('0.07' as abap.dec( 10, 3 ))
       when suppinvoice.TaxCode = 'I4' then cast('0.06' as abap.dec( 10, 3 ))
       when suppinvoice.TaxCode = 'I9' then cast('0.015' as abap.dec( 10, 3 ))
       when suppinvoice.TaxCode = 'G9' then cast('0.025' as abap.dec( 10, 3 ))
       when suppinvoice.TaxCode = 'GA' then cast('0.025' as abap.dec( 10, 3 ))
       end                                                                                                                                                                                                    as CGST_Rate,

       case
           when suppinvoice.TaxCode = 'I1' then cast('0.09' as abap.dec( 10, 3 ))
           when suppinvoice.TaxCode = 'I2' then cast('0.025' as abap.dec( 10, 3 ) )
           when suppinvoice.TaxCode = 'I3' then cast('0.07' as abap.dec( 10, 3 ))
           when suppinvoice.TaxCode = 'I4' then cast('0.06' as abap.dec( 10, 3 ))
           when suppinvoice.TaxCode = 'I9' then cast('0.015' as abap.dec( 10, 3 ))
           when suppinvoice.TaxCode = 'G9' then cast('0.025' as abap.dec( 10, 3 ))
           when suppinvoice.TaxCode = 'GA' then cast('0.025' as abap.dec( 10, 3 ))
           end                                                                                                                                                                                                as SGST_Rate,


       case
       when suppinvoice.TaxCode = 'G0' then cast('0.00' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'G3' then cast('0.18' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'GI' then cast('0.05' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'H1' then cast('0.18' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'H2' then cast('0.18' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'I5' then cast('0.18' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'I6' then cast('0.05' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'I7' then cast('0.28' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'I8' then cast('0.12' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'IA' then cast('0.03' as abap.dec( 10, 2 ))
       when suppinvoice.TaxCode = 'K1' then cast('0.18' as abap.dec( 10, 2 ))
       end                                                                                                                                                                                                    as IGST_Rate,
       matdocitem.DocumentDate                                                                                                                                                                                as MaterialDocumentDate,

       fi.AccountingDocument                                                                                                                                                                                  as FIinv,
       fi.PostingDate                                                                                                                                                                                         as fiinvdate,

//       cast(
//
//       case when suppinvoice.DebitCreditCode = 'S'
//       then case when matdocitem.DebitCreditCode = 'H' then matdocitem.QuantityInBaseUnit * -1 else matdocitem.QuantityInBaseUnit end
//
//       when suppinvoice.DebitCreditCode = 'H'
//       then case when matdocitem.DebitCreditCode = 'S' and SUBSEQDR.SupplierInvoice is not initial or SUBSEQCR.SupplierInvoice is not initial then matdocitem.QuantityInBaseUnit  end
//
//       else 0 end
//
//       as abap.dec(13,3) )  
//                                                                                                                                                                                         as GRNQty,
        cast(
  case
    when suppinvoice.DebitCreditCode = 'S'
      then case
             when matdocitem.DebitCreditCode = 'H'
               then matdocitem.QuantityInBaseUnit * -1
             else matdocitem.QuantityInBaseUnit
           end

    when suppinvoice.DebitCreditCode = 'H'
      then case
             when matdocitem.DebitCreditCode = 'S'
               then matdocitem.QuantityInBaseUnit
             else matdocitem.QuantityInBaseUnit
           end

    else 0
  end
  as abap.dec(13,3)
) as GRNQty,
        @Semantics.amount.currencyCode: 'FreightCurrency'
        pricingelement.ConditionAmount as Freight,
     // case when suppinvoice.SuplrInvcDeliveryCostCndnType = 'ZEF2' and suppinvoice.FreightSupplier is not initial then 
//       sum(cast(coalesce( cast(pricingelement.ConditionAmount as abap.dec( 21, 2 )), 0 )as abap.dec(23,2))) as Freight_d,
//        suppinvoice.FreightSupplier as FreightSupplier,
        pricingelement.TransactionCurrency as FreightCurrency,
//        PT.CGSTAmt,
//        PT.SGSTAmt,                                                                                                                                                                     
       suppinvoice.DebitCreditCode                                                                                                                                                                            as SupplierInvDrCr,
       matdocitem.DebitCreditCode                                                                                                                                                                             as MatDocDrCr,

       CRMEMO.SupplierInvoice                                                                                                                                                                                 as CreditMemo,
       CRMEMO.DocumentDate                                                                                                                                                                                    as CreditMemoDocDate,
       CRMEMO.PostingDate                                                                                                                                                                                     as CreditMemoPostDate,
       CRMEMO.QuantityInPurchaseOrderUnit                                                                                                                                                                     as CreditMemoQty,
       CRMEMO.SupplierInvoiceItemAmount                                                                                                                                                                       as CreditMemoAmt,

       SUBSEQCR.SupplierInvoice                                                                                                                                                                               as SubseqCredit,
       SUBSEQCR.DocumentDate                                                                                                                                                                                  as SubseqCreditDocDate,
       SUBSEQCR.PostingDate                                                                                                                                                                                   as SubseqCreditPostDate,
       SUBSEQCR.QuantityInPurchaseOrderUnit                                                                                                                                                                   as SubseqCreditQty,
       SUBSEQCR.SupplierInvoiceItemAmount                                                                                                                                                                     as SubseqCreditAmt,

       SUBSEQDR.SupplierInvoice                                                                                                                                                                               as SubseqDebit,
       SUBSEQDR.DocumentDate                                                                                                                                                                                  as SubseqDebitDocDate,
       SUBSEQDR.PostingDate                                                                                                                                                                                   as SubseqDebitPostDate,
       SUBSEQDR.QuantityInPurchaseOrderUnit                                                                                                                                                                   as SubseqDebitQty,
       SUBSEQDR.SupplierInvoiceItemAmount                                                                                                                                                                     as SubseqDebitAmt,

       coalesce(MATCOST.Amt,0)                                                                                                                                                                                as TotalMaterialCost,
       coalesce(DELCOST.Amt,0)                                                                                                                                                                                as TotalDeliveryCost,
       coalesce(MATCOST.Amt,0) + coalesce(DELCOST.Amt,0)                                                                                                                                                      as TotalCost,

       case when ( matdocitem.QuantityInBaseUnit is null or matdocitem.QuantityInBaseUnit is initial )
            then cast( 0 as abap.dec(13,3))
            else cast(( $projection.TotalCost / cast( matdocitem.QuantityInBaseUnit as abap.dec(13,3))) as abap.dec(13,3))
       end                                                                                                                                                                                                    as CostPerQty,

       cast(cast(suppinvoice.SupplierInvoiceItemAmount as abap.dec(13,3))*( 1 + coalesce($projection.CGST_Rate,0) + coalesce($projection.SGST_Rate,0) + coalesce($projection.IGST_Rate,0)) as abap.dec(13,3)) as TempInvVal,

       case when suppinvoice.DebitCreditCode = 'S'
             then abs( $projection.TempInvVal )
             when suppinvoice.DebitCreditCode = 'H'
             then (-1*abs($projection.TempInvVal))
             else $projection.TempInvVal
         end                                                                                                                                                                                                  as InvoiceValue


}
where
       matdocitem.PurchaseOrder     is not initial
  and(
       matdocitem.GoodsMovementType = '101'
    or matdocitem.GoodsMovementType = '102'
    or matdocitem.GoodsMovementType = '103'
    or matdocitem.GoodsMovementType = '104'
    or matdocitem.GoodsMovementType = '105'
    or matdocitem.GoodsMovementType = '106'
    or matdocitem.GoodsMovementType = '121'
    or matdocitem.GoodsMovementType = '122'
    or matdocitem.GoodsMovementType = '161'
    or matdocitem.GoodsMovementType = '162'
    //        matdocitem.GoodsMovementType <> '351'
    //    and matdocitem.GoodsMovementType <> '352'
    //    and matdocitem.GoodsMovementType <> '541'
    //    and matdocitem.GoodsMovementType <> '542'
    //    and matdocitem.GoodsMovementType <> '641'
    //    and matdocitem.GoodsMovementType <> '642'
  )
  //and suppinv.SupplierInvoice is not initial
group by
    matdocitem.MaterialDocument,
    matdocitem.MaterialDocumentYear,
    matdocitem.MaterialDocumentItem,
    matdocitem.PurchaseOrder,
    suppinvoice.SupplierInvoice,
    suppinvoice.SupplierInvoiceItem,
    suppinvoice.FiscalYear,
    matdocitem.PurchaseOrderItem,
    purchaseorder.PurchaseRequisition,
    purchaseorder.PurchaseRequisitionItem,
    purreq.PurchaseRequisitionReleaseDate,
    purreq.PurchaseReqnCreationDate,
    purreq.CreatedByUser,
    matdocitem.PostingDate,
    matdocitem.CompanyCode,
    suppinv.InvoicingParty,
    supp.TaxNumber3,
    matdocitem.EntryUnit,
    matdocitem.InventoryValuationType,
    porder.PurchaseOrderType,
    purchaseorder.AccountAssignmentCategory,
    asset.MasterFixedAsset,
    supp.SupplierName,
    supp.Region,
    supp.Country,
    supp.StreetName,
    supp.CityName,
    supp.PostalCode,
    porder.CreationDate,
    porder.IncotermsClassification,
    porder.PaymentTerms,
    paytermstext.PaymentTermsName,
    porder.CreatedByUser,
    purchaseorder.DocumentCurrency,
    purchaseorder.GrossAmount,
    purchaseorder.Material,
    purchaseorder.MaterialGroup,
    purchaseorder.MaterialType,
    purchaseorder.PurchaseOrderItemText,
    hsn.ConsumptionTaxCtrlCode,
    purchaseorder.PurchaseOrderQuantityUnit,
    purchaseorder.OrderQuantity,
    purchaseorder1.BasePrice,
    suppinvoice.TaxCode,
    txtext.TaxCodeName,
    suppinvoice.DocumentCurrency,
    suppinv.DocumentDate,
    suppinv.PostingDate,
    suppinv.SupplierInvoiceIDByInvcgParty,
    suppinv.ExchangeRate,
    suppinvtax.TaxAmount,
    fi2.CompensationCess,
    suppinvoice.DebitCreditCode,
    suppinvoice.PurchaseOrderQuantityUnit,
    suppinvoice.QuantityInPurchaseOrderUnit,
    purchaseorder.IsCompletelyDelivered,
    matdocitem.GoodsMovementType,
    goodmovetype.GoodsMovementTypeName,
    matdocitem.DocumentDate,
    fi.AccountingDocument,
    fi.PostingDate,
    matdocitem.QuantityInBaseUnit,
    matdocitem.DebitCreditCode,
    SUBSEQDR.SupplierInvoice,
    SUBSEQCR.SupplierInvoice,
    pricingelement.TransactionCurrency,
    CRMEMO.SupplierInvoice,
    CRMEMO.DocumentDate,
    CRMEMO.PostingDate,
    CRMEMO.QuantityInPurchaseOrderUnit,
    CRMEMO.SupplierInvoiceItemAmount,
    SUBSEQCR.DocumentDate,
    SUBSEQCR.PostingDate,
    SUBSEQCR.QuantityInPurchaseOrderUnit,
    SUBSEQCR.SupplierInvoiceItemAmount,
    SUBSEQDR.DocumentDate,
    SUBSEQDR.PostingDate,
    SUBSEQDR.QuantityInPurchaseOrderUnit,
    SUBSEQDR.SupplierInvoiceItemAmount,
    MATCOST.Amt,
    DELCOST.Amt,
    suppinvoice.SupplierInvoiceItemAmount,
    suppinvoice.SuplrInvcDeliveryCostCndnType,
    pricingelement.ConditionType,
    suppinvoice.FreightSupplier,
    pricingelement.ConditionAmount,
    JEI.AmountInCompanyCodeCurrency,
    JEI.TransactionCurrency,
    FA.Frigtamount,
    FA.Frigtcury,
    ZT.PostingKey,
    JOI.AccountingDocument,
    JOI.OriginalReferenceDocument,
    CGST.AmountInCompanyCodeCurrency,
    CGST.CompanyCodeCurrency,
    CGST.TransactionTypeDetermination
//    CGST.AmountInCompanyCodeCurrency,
//    CGST.CompanyCodeCurrency,
//    SGST.AmountInCompanyCodeCurrency,
//    SGST.CompanyCodeCurrency,
//    IGST.AmountInCompanyCodeCurrency,
//    IGST.CompanyCodeCurrency
//    PT.CGSTAmt,
//    PT.SGSTAmt
//    ZT.PostingKey,
//    ZT.AccountingDocument
    
    

