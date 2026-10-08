@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '101'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BILLETRE_101
  as projection on ZR_BILLETRE_101
{
  key Id,
  key Item,
      Referenceid,
      @EndUserText.label: 'Billet Batch Number'
      Heatnumber,
      @EndUserText.label: 'Length'
      Lengthmtr,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Pieces Generated'
      Piece,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'Storage Loc.'
      Storagelocation,
      plant,
      /* Associations */
      _Head : redirected to parent ZC_BILLETRE_HDR
}
