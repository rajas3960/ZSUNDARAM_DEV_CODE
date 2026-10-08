@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection ~ CSQ Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define root view entity ZC_CSQ_ITEM
  as projection on ZI_CSQ_ITEM
{
               @EndUserText.label: 'Request For Quotation'
               @Consumption.filter.mandatory: true
  key          RequestForQuotation,
               @EndUserText.label: 'Request For Quotation Item'
               @Consumption.filter.mandatory: true
  key          RequestForQuotationItem,
               @EndUserText.label: 'Supplier Quotation'
  key          SupplierQuotation,
               @EndUserText.label: 'Supplier Quotation Item'
  key          SupplierQuotationItem,
               @EndUserText.label: 'Material'

               Material,
               @EndUserText.label: 'Material Description'
               PurchasingDocumentItemText,
               @EndUserText.label: 'Order Quantity Unit'
               OrderQuantityUnit,
               @EndUserText.label: 'Purchasing Group'
               PurchasingGroup,
               @EndUserText.label: 'Currency'
               curr,
               @EndUserText.label: 'Price basis'
               IncotermsClassification,
               @EndUserText.label: 'Price basis Location'
               IncotermsLocation1,
               @EndUserText.label: 'Payment Terms'
               PaymentTerms,
               @EndUserText.label: 'Plant'
               Plant,
               @EndUserText.label: 'Supplier'
               Supplier,
               @EndUserText.label: 'Supplier Name'
               SupplierName,
               @EndUserText.label: 'Delivery Date'
               PurgDocPriceDate,
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Net Price'
               NetAmount,
               @EndUserText.label: 'Order Price Unit'
               OrderPriceUnit,
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Gross Price'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      GrossPrice        : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Discount'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      discount          : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Pkg & Fwd Charges'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      pkgfwb            : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Insurance'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      insurance         : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Freight'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      freight           : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Customs Duty'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      customduty        : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Social Welfare Cess'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      socialwelfare     : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Miscellaneous Cost'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      Miscellaneouscost : abap.curr( 23,2),
               @Semantics.amount.currencyCode: 'curr'
               @EndUserText.label: 'Total Net Landed Cost'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CSQ_IMP'
  virtual      total             : abap.curr( 23,2)
}
