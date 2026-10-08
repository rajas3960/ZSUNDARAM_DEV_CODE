@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Metal Balancing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_METAL_BAL as select from ZDT_METAL_BAL
 association to parent ZI_TMT_HEAD as _Head on $projection.Id = _Head.Id
{
    key id as Id,
    key item as Item,
    referenceid as Referenceid,
    material as Material,
    materialdes as Materialdes,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    quantity as Quantity,
    uom as Uom,
    balance as Balance,
    _Head
}
