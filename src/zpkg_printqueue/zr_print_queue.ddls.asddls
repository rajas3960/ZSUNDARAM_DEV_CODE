@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for print queue'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_PRINT_QUEUE
  as select from zdt_printqueue
{
  key   id                      as Id,
  key   cbuser                  as Cbuser,
  key   printque                as Printque,
        cast( '' as abap.dats ) as Erdat
}
