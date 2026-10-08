@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '261'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BILLETRE_261
  as projection on ZR_BILLETRE_261
{
  key Id,
  key Item,
      Referenceid,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Material Desc'
      Materialdescription,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'Storage Loc.'
      Storagelocation,
      plant,
      @EndUserText.label: 'Pieces Consumed'
      piece,
      /* Associations */
      _Head : redirected to parent ZC_BILLETRE_HDR
}
