@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier 3'
define view entity ZR_SUPPLIER3
  as select from I_BillingDocumentItem as a
{
  key a.BillingDocument,
      min(a.BillingDocumentItem) as BillingDocumentItem
}
group by
  a.BillingDocument
