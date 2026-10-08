@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Hard Coke Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_HARD_COKE_RPT 
as select from ZI_HARD_COKE_RPT_1
{
    @EndUserText.label: 'Material Document'
    key MaterialDocument,
    @EndUserText.label: 'material Document item'
    key MaterialDocumentItem,
    @UI.hidden: true
    key MaterialDocumentYear,
    @EndUserText.label: 'Posting Date'
    PostingDate,
    @EndUserText.label: 'Customer/Vendor Code'
    Supplier,
    @EndUserText.label: 'Customer/Vendor Name'
    SupplierName,
    @EndUserText.label: 'BP Reference No.'
    ChallanNo,
    @EndUserText.label: 'Itemcode'
    Material,
    @EndUserText.label: 'Dscription'
    ProductName,
    @EndUserText.label: 'Location'
    Plant,
    @EndUserText.label: 'Storage Location'
    StorageLocation,
    @EndUserText.label: 'GRN Qty'
    QuantityInEntryUnit,
    @UI.hidden: true
    @EndUserText.label: 'Unit'
    MaterialBaseUnit,
    @EndUserText.label: 'Plant Wt'
    plantqty,
    @EndUserText.label: 'Wt Diff'
    wtdiff,
    @EndUserText.label: 'Unit rate'
    NetPriceAmount,
    @EndUserText.label: 'Currency'
    @UI.hidden: true
    DocumentCurrency,
    @EndUserText.label: 'Total Bill Amount'
    totbill,
    @EndUserText.label: 'Total Pay'
    totpay,
    @EndUserText.label: 'Price Difference'
    pricediff,
    @EndUserText.label: 'U_ASH'
    uash,
    @EndUserText.label: 'U_MOISTURE'
    umois,
    @EndUserText.label: 'U_ASH Qlty  Max from IP'
    uashup,
    @EndUserText.label: 'U_MOISTURE Qlty  Max from IP'
    umoisup,
    @EndUserText.label: 'Ash Weight'
    ashwt,
    @EndUserText.label: 'Ash Amount'
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    ashamt,
    @EndUserText.label: 'Moisture Wt'
    moiswt,
    @EndUserText.label: 'Moisture Amt'
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    moisamt,
    @EndUserText.label: 'Net Amt'
    netamt,
    @EndUserText.label: 'Total Wt'
    totwt,
    @EndUserText.label: 'Unit Rate'
    case when totwt is not initial then cast( division( netamt, totwt, 2 ) as abap.dec( 23, 2) )
    else cast( 0 as abap.dec( 23, 2) ) end as unitrate
}
