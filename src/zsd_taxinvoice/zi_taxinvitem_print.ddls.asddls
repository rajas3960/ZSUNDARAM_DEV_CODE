@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom Entity for Tax Invoice Item Print'
//@UI.presentationVariant: [{
//    sortOrder: [{
//        by: 'BillingDocumentItem',
//        direction: #ASC
//    }]
//}]
define view entity ZI_TAXINVITEM_PRINT
//  as select from ZV_TAXINV_ITEMP    "old one
  as select from zsd_taxitemprint       //"new one added by SAR Team on 14.04.2026
{
  key billingdocument,
  key billingdocumentitem,
      descofgoods,
      hsncode,
      //      OrderQuantityUnit,
      //      OrderQuantity,
      //      OrderUnit,
      orderunit1 as OrderUnit,
      orderunit1 as OrderUnit1,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit1'
      invoicequantity,
      transactioncurrency,
      itemweightunit,
      itemnetweight,
      distributionchannel,
      rateperunit,
      packingunit,
      packingquantitymax,
      packingquantitymin,
      packingquantitytotal,
      cgst,
      cgstrate,
      sgst,
      sgstrate,
      igst,
      igstrate,
      utgst,
      utgstrate,
      tcs,
      freight,
      roundoff,
      //      FreightRate,
      discountrate,
      discount,
      billingnetamount,
      taxableamount,
      cessamount,
      tcsamount,
      ratenew
      //      DiscountRate
      //      Division

}
