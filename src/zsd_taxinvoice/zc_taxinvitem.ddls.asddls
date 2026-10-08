@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Tax Invoice Item'
@Metadata.allowExtensions: true
define view entity ZC_TAXINVITEM
  as projection on ZI_TAXINVOICE_ITEM
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
      Discount,
      @EndUserText.label:  'Net Amount'
      Billingnetamount,
      @EndUserText.label:  'Taxable Amount'
      TaxableAmount,
      @EndUserText.label:  'Cess Amount'
      CessAmount,
      @EndUserText.label:  'TCS Amount'
      TCSAmount,
      @EndUserText.label:  'Rate'
      RateNew,
      _Head : redirected to parent ZC_TAXINVHDR
}
