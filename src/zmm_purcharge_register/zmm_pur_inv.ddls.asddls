@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice View Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_PUR_INV 
as select from I_JournalEntryItem as JEI
inner join I_OperationalAcctgDocItem as OADI
    on  JEI.AccountingDocument      = OADI.AccountingDocument
    and JEI.AccountingDocumentItem  = OADI.AccountingDocumentItem
    and JEI.FiscalYear              = OADI.FiscalYear
    and JEI.CompanyCode             = OADI.CompanyCode
{
    key JEI.AccountingDocument,
    key JEI.FiscalYear,
    key JEI.CompanyCode,
        max( OADI.FinancialAccountType ) as FinancialAccountType
}
where 
    OADI.FinancialAccountType = 'K'
    and OADI.PurchasingDocument is initial
group by 
    JEI.AccountingDocument,
    JEI.FiscalYear,
    JEI.CompanyCode
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
////as select from I_SuplrInvcItemPurOrdRefAPI01 
////{
////
////    key SupplierInvoice,
////    key FiscalYear,
//////    key SupplierInvoiceItem,
////    PurchaseOrder,
////    PurchaseOrderItem,
//////    Plant,
//////    SupplierInvoiceItemText,
//////    PurchaseOrderItemMaterial,
////
////    PurchaseOrderQuantityUnit,
////    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
////   sum( QuantityInPurchaseOrderUnit ) as QuantityInPurchaseOrderUnit,
//////    PurchaseOrderPriceUnit,
//////    QtyInPurchaseOrderPriceUnit,
//////    StockUnit,
//////    SuplrInvcDeliveryCostCndnType,
//////    SuplrInvcDeliveryCostCndnStep,
//////    SuplrInvcDeliveryCostCndnCount,
//////    DocumentCurrency,
//////    SupplierInvoiceItemAmount,
//////    IsSubsequentDebitCredit,
//////    TaxCode,
//////    TaxJurisdiction,
////   max(ReferenceDocument ) as ReferenceDocument,
////    ReferenceDocumentFiscalYear
//////    ReferenceDocumentItem,
//////    DebitCreditCode,
//////    FreightSupplier,
//////    IsNotCashDiscountLiable,
//////    SuplrInvcItemHasPriceVariance,
//////    SuplrInvcItemHasQtyVariance,
//////    SuplrInvcItemHasDateVariance,
//////    SuplrInvcItemHasOrdPrcQtyVarc,
//////    SuplrInvcItemHasOtherVariance,
//////    SuplrInvcItemHasAmountOutsdTol,
//////    SuplrInvcItmHasQualityVariance,
//////    TaxCountry,
//////    SuplrInvcItmUnplndDelivCost,
//////    IsFinallyInvoiced,
////    /* Associations */
//////    _Currency,
//////    _PurOrdPriceUnitOfMeasure,
//////    _SuplrInvcItmAcctAssgmtAPI01,
//////    _SupplierInvoiceAPI01,
//////    _UnitOfMeasure
////}where ReferenceDocument <> ' '
//// group by
//// SupplierInvoice,
////     FiscalYear,
////     PurchaseOrder,
////    PurchaseOrderItem,
////     PurchaseOrderQuantityUnit,
////     ReferenceDocumentFiscalYear
