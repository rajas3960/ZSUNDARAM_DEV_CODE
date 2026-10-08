@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREGN_4
  as select from ZR_INPUTREGN_2
{
  key CompanyCode,
  key AccountingDocumentType,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,
      AccountingDocumentItemType,
      TaxItemAcctgDocItemRef,
      TaxCode,
      TransactionTypeDetermination,
      DebitCreditCode,
      TransactionCurrency,
      CompanyCodeCurrency,
      //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( TaxBaseAmountInCoCodeCrcy as abap.dec(13,2) ) as TaxBaseAmountInCoCodeCrcy,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case DebitCreditCode
      //          when 'H' then AmountInTransactionCurrency * -1
          when 'H' then AmountInTransactionCurrency
          else AmountInTransactionCurrency end as taxamt,
      //      AmountInTransactionCurrency as taxamt,
      taxchar1
}
where
      AccountingDocumentItemType =  'T'
  and TaxItemAcctgDocItemRef     <> '000000'
