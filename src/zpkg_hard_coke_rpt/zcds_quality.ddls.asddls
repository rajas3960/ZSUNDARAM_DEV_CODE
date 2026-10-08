@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Quality detail'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_QUALITY
  as select from I_MaterialDocumentItem_2 as a
{
  key a.MaterialDocument     as MaterialDocument,
  key a.MaterialDocumentItem as MaterialDocumentItem,
  key a.MaterialDocumentYear as MaterialDocumentYear
}
