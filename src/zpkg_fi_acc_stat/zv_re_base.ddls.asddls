@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RE Base Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_RE_BASE as select distinct from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(AmountInCompanyCodeCurrency) as baseamt
}
where TransactionTypeDetermination <> 'BSX'
and  TransactionTypeDetermination <> 'EIN'
and ( AccountingDocumentItemType  = 'W'
or AccountingDocumentItemType = 'M'
or AccountingDocumentItemType = 'S'
or AccountingDocumentItemType = 'F'
or AccountingDocumentItemType = 'P'
)
group by AccountingDocument,
CompanyCode,
FiscalYear,
CompanyCodeCurrency
