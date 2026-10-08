@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Hard Coke Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HARD_COKE_RPT 
as select from ZTBL_FCTN_HARDCOKE( mandt : $session.client )
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
    cast( ( coalesce( totbill, 0 ) - coalesce( totpay, 0 ) ) as abap.dec( 23, 2) ) as pricediff,
    uash,
    umois,
    uashup,
    umoisup,
    case when uash is not initial and uash > uashup
    then cast( ( ( coalesce( uash, 0 ) - coalesce( uashup, 0 ) ) * plantqty / 100 ) as abap.dec( 13, 3 ) ) 
    else cast( 0 as abap.dec( 13, 2 ) ) end as ashwt,
    case when uash is not initial and uash > uashup
    then cast( ( ( ( coalesce( uash, 0 ) - coalesce( uashup, 0 ) ) *  cast( ( plantqty * NetPriceAmount ) as abap.dec( 23, 2) ) ) / 100 ) as abap.dec( 23, 2 ) ) 
    else cast( 0 as abap.dec( 13, 2 ) ) end as ashamt,
    case when umois is not initial and umois > umoisup
    then cast( ( ( coalesce( umois, 0 ) - coalesce( umoisup, 0 ) ) * plantqty / 100 ) as abap.dec( 13, 3 ) ) 
    else cast( 0 as abap.dec( 13, 2 ) ) end as moiswt,
    case when umois is not initial and umois > umoisup
    then cast( ( ( ( coalesce( umois, 0 ) - coalesce( umoisup, 0 ) ) *  cast( ( plantqty * NetPriceAmount ) as abap.dec( 23, 2) ) ) / 100 ) as abap.dec( 23, 2 ) ) 
    else cast( 0 as abap.dec( 13, 2 ) ) end as moisamt
}
