@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Item consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define view entity ZC_bank_stat_item as projection on ZI_bank_stat_item
{
         @Search.defaultSearchElement: true
          @EndUserText.label: 'Company Code'
  key     CompanyCode,
          @EndUserText.label: 'Accounting Document'
  key     AccountingDocument,
          @EndUserText.label: 'Payment Document Fiscal Year'
  key     ClearingJournalEntryFiscalYear,
          @EndUserText.label: 'Supplier Invoice Fiscal Year'
  key     FiscalYear,
          //         @EndUserText.label: 'Accounting Doc Item'
          // key     AccountingDocumentItem,
          @EndUserText.label: 'Invoice No'
          @Consumption.semanticObject: 'SupplierInvoice'
          @UI.lineItem: [ { position: 10, label: 'Invoice Document'},
          {type: #FOR_INTENT_BASED_NAVIGATION, semanticObjectAction: 'displayFactSheet'}]
  key     SupplierInvoice,
          @EndUserText.label: 'Doc Item'
  key     AccountingDocumentItem,
           @EndUserText.label: 'Invoice Journal Entry'
  key     FI_Invoice,
          @EndUserText.label: 'Doc Type'
          AccountingDocumentType,
          @EndUserText.label: 'Spl GL Ind'
          SpecialGLCode,
          @EndUserText.label: 'Document Date'
          DocumentDate,
          @EndUserText.label: 'Posting No'
          PostingDate,
          @EndUserText.label: 'Invoice Amount'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          AmountInCompanyCodeCurrency,
          @EndUserText.label: 'Currency'
          CompanyCodeCurrency,
          @EndUserText.label: 'Due Date'
          NetDueDate,
          @EndUserText.label: 'Payment Terms'
          PaymentTerms,
          @EndUserText.label: 'Withholding Tax Amount'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          WithholdingTaxAmount,
          @EndUserText.label: 'Purchasing Document'
          PurchasingDocument,
    /* Associations */
     _Head : redirected to parent ZC_bank_stat_head
}
