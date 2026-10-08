@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Advice Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define view entity ZC_PAYADV_ITEM
  as projection on ZI_PAYADV_ITEM
{
      @EndUserText.label: 'Company Code'
  key CompanyCode,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Payment Doc Number'
  key AccountingDocument,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @EndUserText.label: 'Invoice'
  key SupplierInvoice,
      @EndUserText.label: 'Doc Item'
  key AccountingDocumentItem,
      @EndUserText.label: 'Acc Doc Type'
      AccountingDocumentType,
      @EndUserText.label: 'SP GL Code'
      SpecialGLCode,
      @EndUserText.label: 'Document Date'
      DocumentDate,
      @EndUserText.label: 'Posting Date'
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
      @EndUserText.label: 'Withholding Tax Code'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      WithholdingTaxAmount,
      @EndUserText.label: 'Purchasing Document'
      PurchasingDocument,
      @EndUserText.label: 'FI Invoice' --++ AK 29/04/2025
      FI_Invoice, --++ AK 29/04/2025
      @EndUserText.label: 'SupplierInvoiceReference' --++ AK 29/04/2025
      SupplierInvoiceReference, --++ AK 29/04/2025
      @EndUserText.label: ' total_retention_amount' --++AK 05/05/2025
      total_retention_amount, --++ AK 05/05/2025
      @EndUserText.label: 'total_advance_amount' --++ AK 05/05/2025
      total_advance_amount, --++ AK 05/05/2025
      @EndUserText.label: ' total_amount' --++ AK 05/05/2025
      total_amount, --++ AK 05/05/2025
      @EndUserText.label: ' total_amount' --++ AK 28/07/2025
      total_ded_amount, --++ AK 28/07/2025
      /* Associations */
      _Head : redirected to parent ZC_PAYADV_HEAD
}
