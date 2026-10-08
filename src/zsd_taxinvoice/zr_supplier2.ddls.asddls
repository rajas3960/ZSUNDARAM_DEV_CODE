@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier 2'
define view entity ZR_SUPPLIER2
  as select from I_BillingDocumentItem as a
    inner join   ZR_SUPPLIER3          as b on  a.BillingDocument     = b.BillingDocument
                                            and a.BillingDocumentItem = b.BillingDocumentItem
{
  key a.BillingDocument,
      a.BillingDocumentItem,
      a.Plant,
      a.SalesDocument
}
