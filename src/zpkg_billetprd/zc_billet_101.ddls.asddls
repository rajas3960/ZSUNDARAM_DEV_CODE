@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Production - 101'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BILLET_101

  as projection on ZR_BILLET_101

{
  key id,
  key item,
      @EndUserText.label: 'Reference ID'
      referenceid,
      @EndUserText.label: 'Heat Number'
      heatnumber,
      @EndUserText.label: 'Material'
      material,
      @EndUserText.label: 'Plant'
      plant,
      @EndUserText.label: 'Length(MTR)'
      lengthmtr,
      @EndUserText.label: 'Batch'
      batch,
      @EndUserText.label: 'Piece'
      piece,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'uom'
      quantity,
      @EndUserText.label: 'UoM'
      uom,
      @EndUserText.label: 'Storage Location'
      storagelocation,
      /* Associations */
      _Head : redirected to parent ZC_BILLET_HDR
}
