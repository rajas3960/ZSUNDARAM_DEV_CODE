@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '101'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BILLETRE_101
  as select from zdt_billetre_101
  association to parent ZR_BILLETRE_HDR as _Head on $projection.Id = _Head.id
{
  key id              as Id,
  key item            as Item,
      referenceid     as Referenceid,
      heatnumber      as Heatnumber,
      lengthmtr       as Lengthmtr,
      batch           as Batch,
      piece           as Piece,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      quantity        as Quantity,
      uom             as Uom,
      storagelocation as Storagelocation,
      plant,
      _Head // Make association public
}
