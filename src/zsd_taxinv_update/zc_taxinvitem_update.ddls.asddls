//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Tax Invoice item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define view entity ZC_TAXINVITEM_UPDATE as projection on ZCSDS_TAXINVOICE_ITEMUPDATE
{
  key BillingDocument,
  key BillingDocumentItem,
      @EndUserText.label: 'Description of Goods'
      DescOfGoods,
      @EndUserText.label: 'HSN/SAC Code'
      HSNCode,
      @EndUserText.label: 'Order Unit'
      OrderUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      @EndUserText.label: 'Invoice Quantity' 
      InvoiceQuantity,
      TransactionCurrency,
      @EndUserText.label: 'Net Weight Unit'
      ItemWeightUnit,
      @EndUserText.label: 'Net Weight'
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @EndUserText.label: 'Rate (per unit)'
      RatePerUnit,
      @EndUserText.label: 'Packing Unit'
      PackingUnit,
      @EndUserText.label: 'Packing Quantity Max'
      PackingQuantityMax,
      @EndUserText.label: 'Packing Quantity Min'
      PackingQuantityMin,
      @EndUserText.label: 'Packing Quantity Total'
      PackingQuantityTotal,
      @EndUserText.label: 'CGST'
      CGST,
      @EndUserText.label: 'CGST Rate'
      CGSTRate,
      @EndUserText.label: 'SGST'
      SGST,
      @EndUserText.label: 'SGST Rate'
      SGSTRate,
      @EndUserText.label: 'IGST'
      IGST,
      @EndUserText.label: 'IGST Rate'
      IGSTRate,
      @EndUserText.label: 'UTGST'
      UTGST,
      @EndUserText.label: 'UTGST Rate'
      UTGSTRate,
      @EndUserText.label: 'TCS'
      TCS,
      @EndUserText.label: 'Freight'
      Freight,
      @EndUserText.label: 'Discount Rate'
      DiscountRate,
      @EndUserText.label: 'Discount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Discount,
      @EndUserText.label:  'Net Amount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Billingnetamount,
      @EndUserText.label:  'Taxable Amount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxableAmount,
      @EndUserText.label:  'Cess Amount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      CessAmount,
      @EndUserText.label:  'TCS Amount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TCSAmount,
      @EndUserText.label:  'Rate'
      RateNew,
      _Head : redirected to parent ZC_TAXINVHDR_UPDATE
}
