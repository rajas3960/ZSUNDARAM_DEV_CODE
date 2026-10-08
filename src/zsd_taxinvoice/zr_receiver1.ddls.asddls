@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Receiver 1'
define view entity ZR_RECEIVER1
  as select from I_BillingDocumentItem

{
  key BillingDocument,
      min(BillingDocumentItem) as BillingDocumentItem
}
group by
  BillingDocument
