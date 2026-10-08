@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item HU 2'
define view entity ZR_ITEM_HU2
  as select distinct from I_BillingDocumentItem as a
  left outer join ZR_ITEM_HU1 as b on a.ReferenceSDDocument = b.HandlingUnitReferenceDocument
                                  and a.Material = b.Material
{
    key a.BillingDocument,
    key b.HandlingUnitReferenceDocument,
    key b.Material,
    b.HandlingUnitQuantityUnit,
//    @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityunit'
    cast( sum( b.SumHandlingUnitQuan ) as abap.int4 ) as SumHandlingUnitQuan,
//    @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityunit'
    cast( max( b.MaxHandlingUnitQuan ) as abap.int4 ) as MaxHandlingUnitQuan,
    cast( ( sum( b.totalpackunits ) / count( distinct a.ReferenceSDDocumentItem ) ) as abap.int4 ) as totalpackunits,
    cast( mod( cast( sum( b.SumHandlingUnitQuan ) as abap.int4 ), cast( max( b.MaxHandlingUnitQuan ) as abap.int4 ) )as abap.int4 ) as modpackunits
} where a.SalesDocumentItemCategory = 'CB99' or a.SalesDocumentItemCategory = 'TAE'
group by a.BillingDocument, b.HandlingUnitReferenceDocument, b.Material, b.HandlingUnitQuantityUnit
