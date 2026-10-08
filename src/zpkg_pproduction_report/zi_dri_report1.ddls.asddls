@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dri Production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZI_DRI_REPORT1 
 with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
    as select  distinct from ZI_DRI_REPORT  ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant)
{
  //key PeriodType                                       ,              // ++ 26.08.25
//  key EndDate ,
  //key YearPeriod,
  //key StorageLocation,
//  key Batch,
 //key Supplier,
 // key SDDocument,
//  key SDDocumentItem,
//  key WBSElementInternalID,
  
 // key InventorySpecialStockType,
 // key FiscalYearVariant,
//  key MaterialDocument,
//  key MaterialDocumentItem,
   @EndUserText.label: 'Posting Date '
   key postingdate,
   @EndUserText.label: 'Material '
   key Material,
   @EndUserText.label: 'Plant'
   key Plant,
   @EndUserText.label: 'Material Description'
   Product_name,
   MaterialBaseUnit,
   @EndUserText.label: 'OPENING'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
   @Aggregation.default: #SUM
  // OPENING,
   cast(OPENING as abap.dec( 21, 3 ) ) as  OPENING ,
   @EndUserText.label: 'PRODUCTION KILN1'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  PRODUCTION_KILN1,
   cast( PRODUCTION_KILN1 as abap.dec( 21, 3 ) ) as   PRODUCTION_KILN1 ,
   @EndUserText.label: 'PRODUCTION KILN2'
  // @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  // PRODUCTION_KILN2,
    cast( PRODUCTION_KILN2 as abap.dec( 21, 3 ) ) as   PRODUCTION_KILN2 ,
   @EndUserText.label: 'PRODUCTION KILN3'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  PRODUCTION_KILN3,
    cast( PRODUCTION_KILN3 as abap.dec( 21, 3 ) ) as   PRODUCTION_KILN3 ,
   @EndUserText.label: 'PRODUCTION KILN4'
  // @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  PRODUCTION_KILN4,
   cast( PRODUCTION_KILN4 as abap.dec( 21, 3 ) ) as   PRODUCTION_KILN4 , 
   
   @EndUserText.label: 'PRODUCTION'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  PRODUCTION,
    cast( PRODUCTION as abap.dec( 21, 3 ) ) as   PRODUCTION ,
   
   @EndUserText.label: 'CONSUMPTION KILN1'
//   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//   CONSUMPTION_KILN1,
    cast( CONSUMPTION_KILN1 as abap.dec( 21, 3 ) ) as   CONSUMPTION_KILN1 ,
   
   @EndUserText.label: 'CONSUMPTION KILN2'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  CONSUMPTION_KILN2,
       cast( CONSUMPTION_KILN2 as abap.dec( 21, 3 ) ) as   CONSUMPTION_KILN2,
   @EndUserText.label: 'CONSUMPTION KILN3'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  CONSUMPTION_KILN3,
       cast( CONSUMPTION_KILN3 as abap.dec( 21, 3 ) ) as   CONSUMPTION_KILN3,
   @EndUserText.label: 'CONSUMPTION KILN4'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  CONSUMPTION_KILN4,
      cast( CONSUMPTION_KILN4 as abap.dec( 21, 3 ) ) as   CONSUMPTION_KILN4, 
   
   @EndUserText.label: 'CONSUMPTION'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  CONSUMPTION,
      cast( CONSUMPTION as abap.dec( 21, 3 ) ) as   CONSUMPTION,
   @EndUserText.label: 'PURCHASE GR'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  PURCHASE_GR,
       cast( PURCHASE_GR as abap.dec( 21, 3 ) ) as   PURCHASE_GR,
   @EndUserText.label: 'TRANSFER OUT'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  TRANSFER_OUT,
       cast( TRANSFER_OUT as abap.dec( 21, 3 ) ) as   TRANSFER_OUT,
   @EndUserText.label: 'TRANSFER IN'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  TRANSFER_IN,
    cast( TRANSFER_IN as abap.dec( 21, 3 ) ) as   TRANSFER_IN,
   @EndUserText.label: 'SALES'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//   SALES,
      cast( SALES as abap.dec( 21, 3 ) ) as   SALES,
    @EndUserText.label: 'SALES RETURN'
//     @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//   SALES_RETURN,
      cast(   SALES_RETURN as abap.dec( 21, 3 ) ) as     SALES_RETURN,
   
   @EndUserText.label: 'CLOSING STOCK'
 //  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 //  CLOSING_STOCK
    cast(  CLOSING_STOCK as abap.dec( 21, 3 ) ) as     CLOSING_STOCK,
    
     // ADDED BY SAR TEAM DT-01-07-2026
    @EndUserText.label: 'STO(641)'  
     
   cast( STO_641 as abap.dec( 21, 3 ) ) as STO_641,
   
    @EndUserText.label: 'COMP.COST CENTER(201)' 
   cast ( COMP_COST_CENTER_201 as abap.dec( 21, 3 )) as COMP_COST_CENTER_201,
    
    @EndUserText.label: 'TRF MATE 2 MATE(309)'
   cast(TRF_MATE_2_MATE as abap.dec( 21, 3 )) as TRF_MATE_2_MATE
   
    // ADDED BY SAR TEAM DT-01-07-2026
}
where postingdate <> $parameters.p_from_date
