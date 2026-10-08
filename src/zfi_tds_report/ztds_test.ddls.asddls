@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TEST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZTDS_TEST as select from I_OperationalAcctgDocItem 
                                                    

{

key CompanyCode,
key AccountingDocument,
key FiscalYear,
key AccountingDocumentItem,
AccountingDocumentItemType,
ClearingDate,
ClearingCreationDate,
TaxCode,
TaxItemGroup,
TransactionTypeDetermination,
GLAccount,
Plant,
TransactionCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
AmountInTransactionCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
AmountInCompanyCodeCurrency

}
