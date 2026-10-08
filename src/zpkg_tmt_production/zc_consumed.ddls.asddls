@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Consumed'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_CONSUMED
  as projection on ZI_CONSUMED
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference ID'
      Referenceid,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc'
      Materialdes,
      @EndUserText.label: 'Batch No.'
      Batchno,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'S. Loc.'
      Storageloc,
      /* Associations */
      _Head : redirected to parent ZC_TMT_HEAD
}
