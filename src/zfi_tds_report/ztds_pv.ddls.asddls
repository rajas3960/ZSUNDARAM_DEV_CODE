@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZTDS_PV as select from ZTDS_RV
{

    key SourceLedger,
    key CompanyCode,
    key FiscalYear, 
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    TransactionCurrency,
    PostingDate,
    ReferenceDocument,
    Supplier,
    TaxNumber3,
//    CustomerFullName,
    SupplierFullName,
    BusinessPartnerPanNumber,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    WhldgTaxBaseAmtInTransacCrcy,
//     @Semantics.amount.currencyCode: 'TransactionCurrency'
//    CGSTAMOUNT,
//     @Semantics.amount.currencyCode: 'TransactionCurrency'
//    SGSTAMOUNT,
//     @Semantics.amount.currencyCode: 'TransactionCurrency'
//    IGSTAMOUNT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    CGSTTDSAMOUNT,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    SGSTTDSAMOUNT,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    IGSTTDSAMOUNT,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    TDSAmount,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    TotalValue,
    WithholdingTaxPercent
}
