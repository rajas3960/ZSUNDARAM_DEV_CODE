@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Tax Invoice Item'
@Metadata.allowExtensions: true
define view entity ZC_TAXINVITEM2
  as projection on ZI_TAXINVOICE_ITEM2
{
  key BillingDocument,
  key BillingDocumentItem,
      @EndUserText.label: 'Serial Number'
      SerialNumber,
      @EndUserText.label: 'Material Description'
      MaterialDesc,
      /* Associations */
      _Head : redirected to parent ZC_TAXINVHDR
}
