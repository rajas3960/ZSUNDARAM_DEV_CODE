@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom Entity for Tax Invoice Item Print'
define view entity ZI_TAXINVITEM2_PRINT 
  as select from ZI_TAXINVOICE_ITEM2
{
  key BillingDocument,
  key BillingDocumentItem,
  SerialNumber,
  MaterialDesc
  
}
