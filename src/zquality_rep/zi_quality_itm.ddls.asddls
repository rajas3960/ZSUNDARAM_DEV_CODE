@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Item level'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_QUALITY_ITM
  as select from zdt_quality_itm
  association to parent ZI_QUALITY_HDR as _Head on $projection.Id = _Head.Id
{

  key id               as Id,
  key item             as Item,
      billingdoc       as Billingdoc,
      billingitem      as Billingitem,
      batch            as batch,
      quantity         as quantity,
      charname         as CharName,
      chardesc         as CharDesc,
      maxlimit         as MaxLimit,
      minlimit         as MinLimit,
      results          as Results,
      uom              as Uom,
      uomname          as Uomname,
      test_method_text as Test_Method_Text,
      test_range       as Test_Range,
      _Head
}
