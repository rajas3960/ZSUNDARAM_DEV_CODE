@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Cancellation'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_PUR_REG_003 
as select from I_JournalEntryItem as JEI

{
    key JEI.AccountingDocument,
    key JEI.FiscalYear,
    key JEI.CompanyCode,
    key JEI.PurchasingDocument,
    key JEI.PurchasingDocumentItem,
        JEI.ReferenceDocument,
        JEI.ReferenceDocumentItem,
        
        JEI.ReversalReferenceDocument,
        JEI.TransactionTypeDetermination,
        JEI.IsReversal
        
   

}
where JEI.Ledger = '0L'
  and JEI.TransactionTypeDetermination = 'WRX'
  and JEI.ReversalReferenceDocument <> ''
