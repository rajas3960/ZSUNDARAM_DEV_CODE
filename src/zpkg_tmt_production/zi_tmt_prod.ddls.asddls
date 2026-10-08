@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMT Production'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_TMT_PROD

  as select from ZDT_TMT_PROD
 association to parent ZI_TMT_HEAD as _Head on $projection.Id = _Head.Id
{
  key id              as Id,
  key item            as Item,
      referenceid     as Referenceid,
      garde           as Garde,
      tsection        as Tsection,
      batchno         as Batchno,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      weight          as Weight,
      uom             as Uom,
      storagelocation as Storagelocation,
   _Head // Make association public
}
