@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bundle Generation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BUNDLE_GEN
  as select from zdt_bundle_gen
  association to parent ZI_TMT_HEAD as _Head on $projection.Id = _Head.Id
{
  key id              as Id,
  key item            as Item,
      referenceid     as Referenceid,
      bundleno        as Bundleno,
      length          as Length,
      tbatchno        as Tbatchno,
      bbatchno        as Bbatchno,
      noofpcs         as Noofpcs,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      weight          as Weight,
      uom             as Uom,
      storagelocation as Storagelocation,
      _Head
}
