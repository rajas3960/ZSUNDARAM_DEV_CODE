@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPKG_PUR_HDR
  as select from I_MaterialDocumentItem_2      as matdocitem
    left outer join       I_SuplrInvcItemPurOrdRefAPI01 as suppinvoice   on  suppinvoice.PurchaseOrder         = matdocitem.PurchaseOrder
                                                                         and suppinvoice.PurchaseOrderItem     = matdocitem.PurchaseOrderItem
                                                                         and suppinvoice.ReferenceDocument     = matdocitem.InvtryMgmtReferenceDocument
                                                                         and suppinvoice.ReferenceDocumentItem = matdocitem.MaterialDocumentItem
    left outer join       I_SupplierInvoiceAPI01        as suppinv       on  suppinv.SupplierInvoice = suppinvoice.SupplierInvoice
                                                                         and suppinv.FiscalYear      = suppinvoice.FiscalYear

    left outer join       ZR_ACCONTINGDOC               as fi            on  fi.suppplierinv  = suppinvoice.SupplierInvoice
                                                                         and fi.supfiscalyear = suppinvoice.FiscalYear
                                                                         and fi.CompanyCode   = matdocitem.CompanyCode

    left outer join       I_PurchaseOrderAPI01          as porder        on porder.PurchaseOrder = matdocitem.PurchaseOrder

    left outer join       I_PurchaseOrderItemAPI01      as purchaseorder on  purchaseorder.PurchaseOrder     = matdocitem.PurchaseOrder
                                                                         and purchaseorder.PurchaseOrderItem = matdocitem.PurchaseOrderItem
    left outer join       I_Supplier                    as supp          on supp.Supplier = matdocitem.Supplier

    left outer join       I_JournalEntryItem            as JEI           on  JEI.ReferenceDocument            = matdocitem.InvtryMgmtReferenceDocument
                                                                         and JEI.Ledger                       = '0L'
                                                                         and JEI.TransactionTypeDetermination = 'FR1'

    left outer join       I_GLAccountTextRawData        as GLDSC         on GLDSC.GLAccount = JEI.GLAccount

    left outer join       I_GoodsMovementTypeT          as goodmovetype  on  goodmovetype.GoodsMovementType = matdocitem.GoodsMovementType
                                                                         and goodmovetype.Language          = $session.system_language

    left outer join       I_MaterialDocumentHeader_2    as matdocheader  on  matdocheader.MaterialDocument     = matdocitem.MaterialDocument
                                                                         and matdocheader.MaterialDocumentYear = matdocitem.MaterialDocumentYear
    
    composition [0..*] of ZPKG_PUR_ITM as _Item
                                                                         
{

//  key  matdocitem.MaterialDocument         as Material_Document,
//  key  matdocitem.MaterialDocumentYear     as Material_Document_Year,
//  key  matdocitem.MaterialDocumentItem     as Material_Document_Item,
  key  matdocitem.PurchaseOrder            as Purchase_Order,
  key  suppinvoice.SupplierInvoice         as SupplierInvoice,
  key  suppinvoice.SupplierInvoiceItem     as SupplierInvoiceItem,
//  key  suppinvoice.FiscalYear              as Material_DocumentYear,
  key  matdocitem.PurchaseOrderItem        as Purchase_Order_Item,
         matdocitem.MaterialDocument         as Material_Document,
         matdocitem.MaterialDocumentYear     as Material_Document_Year,
         matdocitem.MaterialDocumentItem     as Material_Document_Item,
         
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       matdocitem.QuantityInBaseUnit       as Quantity,
       matdocitem.MaterialBaseUnit,
       matdocitem.CompanyCode              as CompanyCode,
       matdocitem.Supplier                 as Supplier,
       matdocitem.GoodsMovementType,
       suppinv.DocumentDate                as DocumentDate,
       fi.AccountingDocument               as AccountingDocument,
       porder.CreationDate                 as poCreationDate,
       purchaseorder.Material,
       purchaseorder.PurchaseOrderItemText as POitemtext,
       supp.SupplierName                   as SupplierName,
       JEI.GLAccount,
       GLDSC.GLAccountName,
       goodmovetype.GoodsMovementTypeName,
       matdocheader.MaterialDocumentHeaderText,
       case
       when JEI.AccountingDocumentType = 'WE'
       then abs(
           cast(JEI.AmountInTransactionCurrency as abap.dec(23,2))
       )
       else 0
       end  as GRNValue,
       _Item


}
