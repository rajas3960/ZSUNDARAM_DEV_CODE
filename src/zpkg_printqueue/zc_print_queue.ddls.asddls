@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CON VIEW FOR PRINT QUEUE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_PRINT_QUEUE 
 provider contract transactional_query
 as projection on ZR_PRINT_QUEUE
{
    key Id,
    key Cbuser,
    key Printque,
    Erdat
}
