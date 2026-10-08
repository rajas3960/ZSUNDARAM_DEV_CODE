@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bundle Consumption ~ Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_CONS_BUNDLE
  as projection on ZI_CONS_BUNDLE
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference ID'
      Referenceid,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc.'
      Materialdes,
      @EndUserText.label: 'Batch No'
      Batchno,
      @EndUserText.label: 'Weight'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'S. Loc.'
      Storageloc,
      copy,
      /* Associations */
      _Head : redirected to parent ZC_TMT_HEAD
}
