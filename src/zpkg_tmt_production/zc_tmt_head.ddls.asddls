@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMT Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_TMT_HEAD
  as projection on ZI_TMT_HEAD
{
  key Id,
      @EndUserText.label: 'Reference ID'
      Referenceid,
      @EndUserText.label: 'Production Order'
      Productionorder,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Posting Date'
      Postingdate,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc.'
      Materialdesc,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'Progress'
      Progress,
      @EndUserText.label: 'Total'
      Total,
      @EndUserText.label: 'Department'
      department,
      @EndUserText.label: 'Available Order Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Avlquantity,
      @EndUserText.label: 'Quantity UOM'
      Uom,
      @EndUserText.label: 'Consistency Check'
      conscheck,
      postcnf,
      post101,
      post261,
      post531,
      @EndUserText.label: 'No of Batch/Bundle'
      noofbatch,
      getcons,
      @EndUserText.label: 'Activity(Grid Power)'
      activity,
      /* Associations */
      _item  : redirected to composition child ZC_TMT_PROD,
      _item1 : redirected to composition child ZC_TMT_BYPROD,
      _item2 : redirected to composition child ZC_CONSUMED,
      _item3 : redirected to composition child ZC_METAL_BAL,
      _item4 : redirected to composition child ZC_BUNDLE_GEN,
      _item5 : redirected to composition child ZC_CONS_BUNDLE
}
