@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accounting Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_ACCONTINGDOC as select distinct from I_JournalEntry
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    substring(OriginalReferenceDocument, 1, 10) as suppplierinv,
    substring(OriginalReferenceDocument, 11, 4 ) as supfiscalyear,
    PostingDate
   
}
where OriginalReferenceDocument is not initial
and AccountingDocumentType = 'RE'
