@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multi-Level HU 2'
define view entity ZR_MULTIHU_2
  as select from ZR_MULTIHU_1 as a
  inner join     I_HandlingUnitItem as b on a.HandlingUnitInternalID = b.HandlingUnitNestedInternalID
{
    key a.BillingDocument,
    key a.BillingDocumentItem,
    key b.HandlingUnitInternalID,
    key b.HandlingUnitExternalID,
    b.HandlingUnitQuantityUnit,
    cast( count( distinct b.HandlingUnitNestedInternalID ) as abap.int4 ) as MaxHandlingUnitQuan
} group by a.BillingDocument, a.BillingDocumentItem, b.HandlingUnitInternalID, b.HandlingUnitExternalID, b.HandlingUnitQuantityUnit
