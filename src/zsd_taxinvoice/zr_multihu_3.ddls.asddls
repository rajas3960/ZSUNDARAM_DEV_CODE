@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multi-Level HU 3'
define view entity ZR_MULTIHU_3
  as select distinct from ZR_MULTIHU_2
{
    key BillingDocument,
    key BillingDocumentItem,
    HandlingUnitQuantityUnit,
    MaxHandlingUnitQuan
}
