@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMT Production ~ Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_TMT_PROD
  as projection on ZI_TMT_PROD
{
  key Id,
  key Item,
      Referenceid,
      @EndUserText.label: 'Grade'
      Garde,
      @EndUserText.label: 'Section(mm)'
      Tsection,
      @EndUserText.label: 'Batch no.'
      Batchno,
      @EndUserText.label: 'Weight'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Weight,
      Uom,
      @EndUserText.label: 'Storage Location'
      Storagelocation,
      /* Associations */
      _Head : redirected to parent ZC_TMT_HEAD
}
