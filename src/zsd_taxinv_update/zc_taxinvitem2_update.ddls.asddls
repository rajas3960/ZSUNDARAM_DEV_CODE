//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Tax Invoice item2'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define view entity ZC_TAXINVITEM2_UPDATE as projection on ZI_TAXINVOICE_ITEM2_UPDATE
{
  key BillingDocument,
  key BillingDocumentItem,
      @EndUserText.label: 'Serial Number'
      SerialNumber,
      @EndUserText.label: 'Material Description'
      MaterialDesc,
      /* Associations */
      _Head : redirected to parent ZC_TAXINVHDR_UPDATE
}
