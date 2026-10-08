@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multi-Level HU 1'
define view entity ZR_MULTIHU_1
  as select distinct from I_BillingDocumentItem as a
  left outer join         I_HandlingUnitItem    as d on d.HandlingUnitReferenceDocument = a.ReferenceSDDocument
                                                    and d.HandlingUnitRefDocumentItem   = a.ReferenceSDDocumentItem
{
  key a.BillingDocument,
  key a.BillingDocumentItem,
  key d.HandlingUnitInternalID,
  d.HandlingUnitExternalID
}
where a.SalesDocumentItemCategory <> 'CB99'
  and a.SalesDocumentItemCategory <> 'TAE'
