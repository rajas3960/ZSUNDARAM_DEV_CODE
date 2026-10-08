@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bundle Cons Mat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONS_BUNDLE
  as select from zdt_cons_batch
  association to parent ZI_TMT_HEAD as _Head on $projection.Id = _Head.Id
{
  key id          as Id,
  key item        as Item,
      referenceid as Referenceid,
      material    as Material,
      materialdes as Materialdes,
      batchno     as Batchno,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      quantity    as Quantity,
      uom         as Uom,
      storageloc  as Storageloc,
      'X'         as copy,
      _Head
}
