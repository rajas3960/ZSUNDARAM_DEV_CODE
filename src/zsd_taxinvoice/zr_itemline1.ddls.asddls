@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final View for Itemline'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_ITEMLINE1
  as select distinct from I_BillingDocumentItem as a
    left outer join       I_SalesDocumentItem   as b   on  b.SalesDocument     = a.SalesDocument
                                                       and b.SalesDocumentItem = a.SalesDocumentItem
    left outer join       I_ProductPlantBasic   as c   on  c.Product = b.Material
                                                       and c.Plant   = b.Plant
    left outer join       zdt_matdesc           as mat on  mat.product = a.Material
                                                       and c.Plant     = b.Plant
    left outer join       I_ProductPlantBasic   as h   on  h.Product = a.Product
                                                       and h.Plant   = a.Plant
    left outer join       I_HandlingUnitItem    as d   on  d.HandlingUnitReferenceDocument = a.ReferenceSDDocument
                                                       and d.HandlingUnitRefDocumentItem   = a.ReferenceSDDocumentItem
    left outer join       ZR_RATEPERUNIT        as e   on  e.BillingDocument     = a.BillingDocument
                                                       and e.BillingDocumentItem = a.BillingDocumentItem
    left outer join       ZR_ITEM_HU2           as f   on  f.BillingDocument               = a.BillingDocument
                                                       and f.HandlingUnitReferenceDocument = a.ReferenceSDDocument
                                                       and f.Material                      = a.Product
    left outer join       ZR_ITEM_HU1           as g   on  g.BillingDocument               = a.BillingDocument
                                                       and g.BillingDocumentItem           = a.BillingDocumentItem -- 25.07.25 SP
                                                       and g.HandlingUnitReferenceDocument = a.ReferenceSDDocument -- 25.07.25 SP
    //                                                       and g.HandlingUnitRefDocumentItem = a.ReferenceSDDocumentItem
                                                       and g.Material                      = a.Product -- 25.07.25 SP
    left outer join       I_Customer            as i   on i.Customer = a.SoldToParty
  //    left outer join       I_MaterialDocumentItem_2 as J on J.MaterialDocument = a.ReferenceSDDocument
  //                                                        and a.BillingDocumentType = 'JSN'
  //
{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.DistributionChannel,
      //      case when a.DistributionChannel = '20'
      //      then b.YY1_desitem_SDI
      //      when a.DistributionChannel  = '10'
      //      and  i.CustomerAccountGroup = 'ZEOM'
      //      and  b.YY1_desitem_SDI is not null
      //      and  mat.longtext is not null
      //      then concat_with_space(b.YY1_desitem_SDI, mat.longtext, 1)
      //      when a.DistributionChannel  = '10'
      //      and  i.CustomerAccountGroup = 'ZEOM'
      //      and  b.YY1_desitem_SDI is not null
      //      and  mat.longtext is null
      //      then b.YY1_desitem_SDI
      //      else
      a.BillingDocumentItemText           as BillingDocumentItemText,
      //      mat.longtext                   as BillingDocumentItemText,
      case
      when a.BillingDocumentType = 'JSTO'// or a.BillingDocumentType = 'JSN'
      then h.ConsumptionTaxCtrlCode
      else c.ConsumptionTaxCtrlCode end   as hsncode,
      a.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      a.BillingQuantity,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.NetAmount                         as Billingnetamount,
      a.TransactionCurrency,
      a.ItemWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      a.ItemNetWeight,
      e.NetAmount                         as NetAmount,
      d.HandlingUnitQuantityUnit,
      case when f.HandlingUnitReferenceDocument is null
           then g.MaxHandlingUnitQuan
           when f.HandlingUnitReferenceDocument is not null
           then f.MaxHandlingUnitQuan end as HandlingUnitQtyMax,
      case when f.HandlingUnitReferenceDocument is null
           then g.modpackunits
           when f.HandlingUnitReferenceDocument is not null
           then f.modpackunits
           else 0 end                     as HandlingUnitQtyMin,
      case when f.HandlingUnitReferenceDocument is null
           then g.totalpackunits
           when f.HandlingUnitReferenceDocument is not null
           then f.totalpackunits
           else 0 end                     as HandlingUnitPackQty

}
where
  //      c.ConsumptionTaxCtrlCode is not initial
      e.NetAmount                 is not initial -- 25.07.25
  and a.SalesDocumentItemCategory <> 'CB99'
  and a.SalesDocumentItemCategory <> 'TAE'
