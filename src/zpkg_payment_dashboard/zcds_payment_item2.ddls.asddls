@AbapCatalog.sqlViewName: 'ZSQ_PAY_ITEM2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS TO FETCH TDS AMOUNT FOR KZ DOCUMENTS'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PAYMENT_ITEM2 as select from I_OperationalAcctgDocItem
{
    I_OperationalAcctgDocItem.CompanyCode,
    I_OperationalAcctgDocItem.FiscalYear,
    I_OperationalAcctgDocItem.ClearingJournalEntry,
    I_OperationalAcctgDocItem.WithholdingTaxAmount,
    I_OperationalAcctgDocItem.AccountingDocumentType,
    I_OperationalAcctgDocItem.DebitCreditCode
}
group by CompanyCode,FiscalYear,ClearingJournalEntry,WithholdingTaxAmount,AccountingDocumentType,DebitCreditCode
