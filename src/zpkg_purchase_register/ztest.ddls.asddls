@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZTest 
as select from I_JournalEntryItem as JEI


{
     key JEI.FiscalYear as FiscalYear,
     key JEI.CompanyCode as CompanyCode,
     key JEI.AccountingDocument as AccountingDocument,
     key JEI.AccountingDocumentItem as AccountingDocumentItem,
     key JEI.PurchasingDocument as PurchasingDocument,
     key JEI.PurchasingDocumentItem as PurchasingDocumentItem,
         JEI.ReferenceDocument as ReferenceDocument,
         JEI.ReferenceDocumentItem as ReferenceDocumentItem,
         JEI.PostingKey as PostingKey,
         JEI.LedgerGLLineItem as LedgerGLLineItem
}
where JEI.PostingKey = '21'
 and JEI.Ledger = '0L'
