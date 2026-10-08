@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HDR'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_BILLETRE_HDR
  as projection on ZR_BILLETRE_HDR
{
  key id,
      @EndUserText.label: 'Reference ID'
      referenceid,
      @EndUserText.label: 'Production Order'
      productionorder,
      @EndUserText.label: 'Plant'
      plant,
      @EndUserText.label: 'Posting Date'
      postingdate,
      @EndUserText.label: 'Material'
      material,
      @EndUserText.label: 'Material Desc'
      materialdesc,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      orderquantity,
      @EndUserText.label: 'UOM'
      uom,
      @EndUserText.label: 'Status'
      status,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'Progress'
      Progress,
      @EndUserText.label: 'Total'
      Total,
      @EndUserText.label: 'Width'
      width,
      @EndUserText.label: 'Height'
      height,
      @EndUserText.label: 'Density'
      density,
      postcheck,
      postcnf,
      post101,
      post261,
      post531,
      getcons,
      @EndUserText.label: 'No Of Heats'
      noofheats,
      @EndUserText.label: 'No of Batches'
      noofbatches,
      /* Associations */
      _101 : redirected to composition child ZC_BILLETRE_101,
      _261 : redirected to composition child ZC_BILLETRE_261,
      _531 : redirected to composition child ZC_BILLETRE_531
}
