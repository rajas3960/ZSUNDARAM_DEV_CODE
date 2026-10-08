@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true


//define view entity ZMM_PUR_REG_001
//as select from I_JournalEntryItem as JEI 
//{
//    key JEI.FiscalYear as FiscalYear,
//    key JEI.CompanyCode as CompanyCode,
//    //key JEI.AccountingDocument as AccountingDocument,
//    key    JEI.PurchasingDocument as PurchasingDocument,
//    key    JEI.PurchasingDocumentItem as PurchasingDocumentItem,
//    key    JEI.ReferenceDocument as ReferenceDocument,
//        @Semantics.amount.currencyCode: 'Frigtcury'
//        JEI.AmountInCompanyCodeCurrency as Frigtamount,
//        JEI.TransactionCurrency as Frigtcury,
//        JEI.AccountingDocument as AccountingDocument
//       // JEI.ReferenceDocument
//       
//
//
//
//}
//where JEI.Ledger = '0L'
//and JEI.TransactionTypeDetermination = 'FR1'



define view entity ZMM_PUR_REG_001
  as select from I_JournalEntryItem as JEI
{
    key JEI.FiscalYear            as FiscalYear,
    key JEI.CompanyCode           as CompanyCode,
    key JEI.PurchasingDocument    as PurchasingDocument,
    key JEI.PurchasingDocumentItem as PurchasingDocumentItem,
    key JEI.ReferenceDocument     as ReferenceDocument,

    @Semantics.amount.currencyCode: 'Frigtcury'
    sum( JEI.AmountInCompanyCodeCurrency ) as Frigtamount,

    JEI.TransactionCurrency as Frigtcury
}
where JEI.Ledger = '0L'
  and JEI.TransactionTypeDetermination = 'FR1'

group by
    JEI.FiscalYear,
    JEI.CompanyCode,
    JEI.PurchasingDocument,
    JEI.PurchasingDocumentItem,
    JEI.ReferenceDocument,
    JEI.TransactionCurrency
