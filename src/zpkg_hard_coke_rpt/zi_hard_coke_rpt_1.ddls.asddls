@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Hard Coke Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HARD_COKE_RPT_1 
as select from ZI_HARD_COKE_RPT
{
    key MaterialDocument,
    key MaterialDocumentItem,
    key MaterialDocumentYear,
    PostingDate,
    Supplier,
    SupplierName,
    ChallanNo,
    Material,
    ProductName,
    Plant,
    StorageLocation,
    QuantityInEntryUnit,
    MaterialBaseUnit,
    plantqty,
    wtdiff,
    NetPriceAmount,
    DocumentCurrency,
    totbill,
    totpay,
    pricediff,
    uash,
    umois,
    uashup,
    umoisup,
    ashwt,
    ashamt,
    moiswt,
    moisamt,
    cast( ( coalesce( ashamt, 0 ) + coalesce( pricediff, 0 ) + coalesce( moisamt, 0 ) ) as abap.dec( 23, 2 ) ) as netamt,
    cast( ( coalesce( ashwt, 0 ) + coalesce( wtdiff, 0 ) + coalesce( moiswt, 0 ) ) as abap.dec( 23, 2 ) ) as totwt
}
