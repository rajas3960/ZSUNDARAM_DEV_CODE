@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Tax Invoice Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_TAXINVOICE_ITEM2 
as select from ZR_ITEMLINE_FINAL2

association to parent ZI_TAXINVOICE_HEADER as _Head on $projection.BillingDocument = _Head.SerialInvoiceNo
{
   key ZR_ITEMLINE_FINAL2.BillingDocument,
   key ZR_ITEMLINE_FINAL2.BillingDocumentItem,
   ZR_ITEMLINE_FINAL2.MaterialDesc,
   ZR_ITEMLINE_FINAL2.SerialNumber,
   _Head 
}
