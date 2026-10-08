@Metadata.allowExtensions: true
@EndUserText.label: 'Input Registration'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED

//@Analytics.dataCategory: #CUBE
define root view entity ZC_INPUTREGN_FINAL
  provider contract transactional_query
  as projection on ZI_INPUTREGN_FINAL
{
      @EndUserText.label: 'Company Code'
      @Search.defaultSearchElement: true
  key CompanyCode,
      @EndUserText.label: 'Journal Entry Type'
      @Search.defaultSearchElement: true
  key AccountingDocumentType,
      @EndUserText.label: 'Year'
  key FiscalYear,
      @EndUserText.label: 'Journal Entry No'
  key AccountingDocument,
      @UI.hidden: true
  key AccountingDocumentItem,
      @UI.hidden: true
  key AccountingDocumentItemType,
      @EndUserText.label: 'GL Code'
  key GLAccount,
      @EndUserText.label: 'Vendor Code'
      IN_GSTPartner,
      @EndUserText.label: 'HSN/SAC CODE'
      IN_HSNOrSACCode,
      //      @UI.hidden: true
      //      Material,
      //      @UI.hidden: true
      //      IN_GSTPlaceOfSupply,
      @EndUserText.label: ''
      Plant,
      @EndUserText.label: 'Item Code'
      Product,
      @EndUserText.label: 'Profit Centre'
      ProfitCenter,
      @EndUserText.label: 'PO No'
      PurchasingDocument,
      //      @UI.hidden: true
      //      PurchasingDocumentItem,
      //      @UI.hidden: true
      //      TaxItemAcctgDocItemRef,
      @EndUserText.label: 'Currency'
      TransactionCurrency,
      @EndUserText.label: 'Currency'
      CompanyCodeCurrency,
      @EndUserText.label: 'Taxcode'
      TaxCode,
      @EndUserText.label: 'Taxcode Description'
      TaxCodeName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'SGST'
      SGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'CGST'
      CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'IGST'
      IGST,
      @EndUserText.label: 'RCM Status'
      Rcmstat,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'RCM SGST'
      RCMSGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'RCM CGST'
      RCMCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'RCM IGST'
      RCMIGST,
      //      @UI.hidden: true
      //      TransactionTypeDetermination,
      //      @UI.hidden: true
      //      ValuationArea,
      //      @UI.hidden: true
      //      DebitCreditCode,
      @EndUserText.label: 'Taxable Value'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInTransactionCurrency,
      @EndUserText.label: 'Total Inv Value'
      ttlinvvalue,
      @EndUserText.label: 'Invoice/DR No'
      DocumentReferenceID,
      //      @EndUserText.label: 'INVOICE/DR Yr'
      //      @UI.hidden: true
      //      Invoicenoyr,
      @EndUserText.label: 'INVOICE/DR Date'
      Invoicedate,
      @EndUserText.label: 'Journal Entry Date'
      DocumentDate,
      @EndUserText.label: 'Posting Date'
      creationdate,
      @EndUserText.label: 'Document No'
      //      DocumentReferenceID,
      Invoiceno,
      @EndUserText.label: 'Product Type'
      ProductType,
      @EndUserText.label: 'PO Date'
      PurchaseOrderDate,
      @EndUserText.label: 'GL Name'
      GLAccountLongName,
      @EndUserText.label: 'Vendor Name'
      SupplierName,
      @EndUserText.label: 'GST NO'
      TaxNumber3,
      @EndUserText.label: 'State'
      RegionName,
      @EndUserText.label: 'Item Description'
      ProductName,
      @EndUserText.label: 'Business place'
      BusinessPlace,
      @EndUserText.label: 'Business Place Name'
      BusinessPlaceDescription,
      @EndUserText.label: 'Business Place GST'
      IN_GSTIdentificationNumber
}
