@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TAX INVOICE ITEM2 UPDATE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TAXINVOICE_ITEM2_UPDATE
  as select from ZR_ITEMLINE_FINAL2_UPDATE

  association to parent ZI_TAXINVOICE_HEADER_UPDATE as _Head on $projection.BillingDocument = _Head.SerialInvoiceNo
{
  key ZR_ITEMLINE_FINAL2_UPDATE.BillingDocument,
  key ZR_ITEMLINE_FINAL2_UPDATE.BillingDocumentItem,
      ZR_ITEMLINE_FINAL2_UPDATE.MaterialDesc,
      ZR_ITEMLINE_FINAL2_UPDATE.SerialNumber,
      _Head
}
