@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sample Item'
define view entity ZR_SAMPLEITEM
  as select distinct from I_BillingDocumentItem
{
    key BillingDocument,
        BillingDocumentItem,
        Division
} where Division = '1S'
