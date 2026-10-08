@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
//define view entity ZR_PURCHASE_REG_002   as select distinct from  I_PurchaseOrderAPI01 
//{
//    key PurchaseOrder as PurchaseOrder
//}

define view entity ZR_PURCHASE_REG_002 
as select from I_JournalEntryItem as JEI 
{
    key JEI.FiscalYear as FiscalYear,
    key JEI.CompanyCode as CompanyCode,
    key JEI.AccountingDocument as AccountingDocument,
        JEI.PurchasingDocument as PurchasingDocument,
        JEI.PurchasingDocumentItem as PurchasingDocumentItem,
        @Semantics.amount.currencyCode: 'Frigtcury'
        JEI.AmountInCompanyCodeCurrency as Frigtamount,
        JEI.TransactionCurrency as Frigtcury,
        JEI.ReferenceDocument
       



}
where JEI.Ledger = '0L'
and JEI.TransactionTypeDetermination = 'FR1'
