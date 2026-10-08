@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Error'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_error_item
  as select from zdt_post_log
  association to parent ZI_TRANSATION_REPORT as _Head on  $projection.Transactionid = _Head.Transactionid
                                              and $projection.Utr           = _Head.Utr
{
  key transactionid as Transactionid,
  key utr           as Utr,
  key error_count   as Error_Count,
      error         as Error,
      _Head
}
