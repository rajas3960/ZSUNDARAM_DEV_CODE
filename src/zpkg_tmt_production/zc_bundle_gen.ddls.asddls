@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bundle Generation ~ projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BUNDLE_GEN
  as projection on ZI_BUNDLE_GEN
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference ID'
      Referenceid,
      @EndUserText.label: 'Bundle No.'
      Bundleno,
      @EndUserText.label: 'Length'
      Length,
      @EndUserText.label: 'TMT Batch no.'
      Tbatchno,
      @EndUserText.label: 'Bundle batch no.'
      Bbatchno,
      @EndUserText.label: 'No. of piece'
      Noofpcs,
      @EndUserText.label: 'Weight'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Weight,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'S. Loc.'
      Storagelocation,
      /* Associations */
      _Head : redirected to parent ZC_TMT_HEAD
}
