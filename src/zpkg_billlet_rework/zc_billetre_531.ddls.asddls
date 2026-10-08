@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '531'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BILLETRE_531
  as projection on ZR_BILLETRE_531
{
  key Id,
  key Item,
      Referenceid,
      @EndUserText.label: 'Billet Batch No.'
      Heatnumber,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc'
      Materialdescription,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'Storage loc'
      Storagelocation,
      plant,
      /* Associations */
      _Head : redirected to parent ZC_BILLETRE_HDR
}
