@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Against Payment Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YFI_PAY_PURCH as select from I_AccountingDocumentJournal( P_Language: 'E' ) as a
{
    a.AccountingDocument,
    a.FiscalYear,
    a.CompanyCode,
    max( a.PurchasingDocument ) as PurchasingDocument
}
where a.Ledger = '0L' and a.PurchasingDocument is not initial
group by a.AccountingDocument,a.FiscalYear,a.CompanyCode
