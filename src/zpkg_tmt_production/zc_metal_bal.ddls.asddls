@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Metal Balancing ~ Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_METAL_BAL
  as projection on ZI_METAL_BAL
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference ID'
      Referenceid,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc.'
      Materialdes,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'Balance'
      Balance,
      /* Associations */
      _Head : redirected to parent ZC_TMT_HEAD
}
