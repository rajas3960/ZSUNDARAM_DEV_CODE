@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item HU 1'
define view entity ZR_ITEM_HU1
  as select distinct from I_BillingDocumentItem as a
  left outer join I_HandlingUnitItem as b on a.ReferenceSDDocument = b.HandlingUnitReferenceDocument
                                         and a.ReferenceSDDocumentItem = b.HandlingUnitRefDocumentItem
                                         and a.Material = b.Material
  left outer join ZR_MULTIHU_3       as c on a.BillingDocument = c.BillingDocument
                                         and a.BillingDocumentItem = c.BillingDocumentItem
{
    key a.BillingDocument,
    key a.BillingDocumentItem,
    key b.HandlingUnitReferenceDocument,
//  Cannot be kept as primary key to avoid problems with batch split case
//    key b.HandlingUnitRefDocumentItem,
    key b.Material,
    b.HandlingUnitQuantityUnit,
//    @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityunit'
    cast( sum(b.HandlingUnitQuantity) as abap.int4 ) as SumHandlingUnitQuan,
//    @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityunit'
    case
    when c.MaxHandlingUnitQuan is not null
    then c.MaxHandlingUnitQuan
    else
    cast( max(b.HandlingUnitQuantity) as abap.int4 ) end as MaxHandlingUnitQuan,
    case
    when c.MaxHandlingUnitQuan is not null
    then cast( ceil( sum(b.HandlingUnitQuantity) / c.MaxHandlingUnitQuan ) as abap.int4 )
    else
    cast( ceil( sum(b.HandlingUnitQuantity) / max(b.HandlingUnitQuantity) ) as abap.int4 ) end as totalpackunits,
    case
    when c.MaxHandlingUnitQuan is not null
    then cast( mod( cast( sum(b.HandlingUnitQuantity) as abap.int4 ), c.MaxHandlingUnitQuan ) as abap.int4 )
    else
    cast( mod( cast( sum(b.HandlingUnitQuantity) as abap.int4 ), cast( max(b.HandlingUnitQuantity) as abap.int4 ) ) as abap.int4 ) end as modpackunits
    
} group by a.BillingDocument,
           a.BillingDocumentItem,
           b.HandlingUnitReferenceDocument,
//           b.HandlingUnitRefDocumentItem,
           b.Material,
           b.HandlingUnitQuantityUnit,
           c.MaxHandlingUnitQuan
