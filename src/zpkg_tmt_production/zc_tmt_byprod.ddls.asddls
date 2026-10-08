@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMT By prod ~ projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_TMT_BYPROD
  as projection on ZI_TMT_BYPROD
{
  key Id,
  key Item,
      @EndUserText.label: 'Reference ID'
      Referenceid,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc'
      Materialdes,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'Storage Loc.'
      Storageloc,
      /* Associations */
      _Head : redirected to parent ZC_TMT_HEAD
}
