@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Quality Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_QUALITY_ITM 
 as projection on ZI_QUALITY_ITM
{
  key Id,
  key Item,
      @EndUserText.label: 'Invoice No.'
      Billingdoc,
      @EndUserText.label: 'Invoice Item'
      Billingitem,
      @EndUserText.label: 'Batch'
      batch,
      @EndUserText.label: 'Quantity'
      quantity,
      @EndUserText.label: 'Characteristics Name'
      CharName,
      @EndUserText.label: 'Characteristics Description'
      CharDesc,
      @EndUserText.label: 'Maximum Limit'
      MaxLimit,
      @EndUserText.label: 'Minimum Limit'
      MinLimit,
      @EndUserText.label: 'Results'
      Results,
      @EndUserText.label: 'Unit Of Measurement'
      Uom,
      @EndUserText.label: 'Unit Description'
      Uomname,
      @EndUserText.label: 'Test Method Text'
      Test_Method_Text,
      @EndUserText.label: 'Test Range'
      Test_Range,
      /* Associations */
      _Head : redirected to parent ZC_QUALITY_HDR
}
