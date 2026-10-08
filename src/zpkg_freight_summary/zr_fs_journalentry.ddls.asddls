@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Data:Freight Summary Rep'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_FS_JOURNALENTRY
  as select from I_JournalEntry     as JE
    inner join   I_JournalEntryItem as JEI on  JEI.AccountingDocument = JE.AccountingDocument
                                           and JEI.FiscalYear         = JE.FiscalYear
                                           and JEI.CompanyCode        = JE.CompanyCode
                                           and JEI.Ledger             = '0L'
{
  key substring(JE.OriginalReferenceDocument,1,10)            as MaterialDocument,
  key substring(JE.OriginalReferenceDocument,11,4)            as MaterialDocumentYear,
  key JEI.TransactionTypeDetermination,
      JEI.ReferenceDocument,
      substring(JEI.ReferenceDocumentItem,3,4)                as ReferenceDocumentItem,
      cast(JEI.AmountInCompanyCodeCurrency as abap.dec(23,2)) as Amt

}
where
      JE.OriginalReferenceDocument     is not null
  and JE.OriginalReferenceDocument     is not initial
  and JEI.TransactionTypeDetermination = 'WRX'
  or  JEI.TransactionTypeDetermination = 'FR1'
