@AbapCatalog.sqlViewName: 'ZI_MMR_REP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for MMR report'
@Metadata.ignorePropagatedAnnotations: true



define view ZMMR_REPORT
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
  as select distinct from I_Product               as a
    inner join            I_ProductPlantBasic     as e         on  e.Product = a.Product
                                                               and e.Plant   = $parameters.p_plant
    left outer join       I_ProductValuationBasic as b         on  b.Product       = a.Product
                                                               and b.ValuationArea = e.Plant
                                                               and b.ValuationType is initial
    inner join            I_ProductDescription    as c         on  c.Product  = a.Product
                                                               and c.Language = $session.system_language

  // Opening stock (on p_from_date)
    left outer join       ZMMR_REPORT1(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as g         on  g.MATERIAL = a.Product
                                                               and g.enddate  = $parameters.p_from_date

  // Production receipts (101, 531)
    left outer join       ZMMR_REPORT2(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as h         on h.material = a.Product

    left outer join       ZMMR_REPORT2_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as hn        on hn.material = a.Product

  // Purchasing receipts (101 with PO)
    left outer join       ZMMR_REPORT3(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as i         on i.material = a.Product

    left outer join       ZMMR_REPORT3_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as in        on in.material = a.Product

  // Returns (161 for orders, 122 for PO)
    left outer join       ZMMR_REPORT4(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as j         on j.material = a.Product

    left outer join       ZMMR_REPORT4_NEG(
                           p_from_date: $parameters.p_from_date,
                           p_to_date  : $parameters.p_to_date,
                           p_plant    : $parameters.p_plant
                           )                      as jn        on jn.material = a.Product

  // Issue to order (261)
    left outer join       ZMMR_REPORT5(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as k         on k.material = a.Product

    left outer join       ZMMR_REPORT5_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as kn        on kn.material = a.Product

  // Issue to assets (241)
    left outer join       ZMMR_REPORT6(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as l         on l.material = a.Product

    left outer join       ZMMR_REPORT6_NEG(
                              p_from_date: $parameters.p_from_date,
                              p_to_date  : $parameters.p_to_date,
                              p_plant    : $parameters.p_plant
                              )                   as ln        on ln.material = a.Product

  // Sales issues (601)
    left outer join       ZMMR_REPORT7(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as m         on m.material = a.Product

    left outer join       ZMMR_REPORT7_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as mn        on mn.material = a.Product

  // Scrap (551)
    left outer join       ZMMR_REPORT8(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as n         on n.material = a.Product

    left outer join       ZMMR_REPORT8_NEG(
                              p_from_date: $parameters.p_from_date,
                              p_to_date  : $parameters.p_to_date,
                              p_plant    : $parameters.p_plant
                              )                   as nn        on nn.material = a.Product

  // Physical differences (701, 702)
    left outer join       ZMMR_REPORT9(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as o         on o.material = a.Product


    left outer join       ZMMR_REPORT9_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as o_n       on o_n.material = a.Product

  // Subcontract consumption (543)
    left outer join       ZMMR_REPORT10(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as p         on p.material = a.Product

    left outer join       ZMMR_REPORT10_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as pn        on pn.material = a.Product


  // General consumption (201)
    left outer join       ZMMR_REPORT201(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as r         on r.material = a.Product

    left outer join       ZMMR_REPORT201_NEG(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as rn        on rn.material = a.Product

  // Goods Issue to Project (221)
    left outer join       ZMMR_REPORT221(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as z221      on z221.material = a.Product

    left outer join       ZMMR_REPORT222(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as z222      on z222.material = a.Product

  // Goods Issue Transfer out (301)
    left outer join       ZMMR_REPORT301(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as ztrout301 on ztrout301.material = a.Product

    left outer join       ZMMR_REPORT302(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as ztrout302 on ztrout302.material = a.Product

  // Goods Issue Transfer In (301)
    left outer join       ZMMR_REPORT301_IN(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as ztrin301  on ztrin301.material = a.Product

    left outer join       ZMMR_REPORT302_IN(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as ztrin302  on ztrin302.material = a.Product

  // Goods at Subcontractor (541)
    left outer join       ZMMR_REPORT541(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as z541      on z541.material = a.Product

    left outer join       ZMMR_REPORT542(
                           p_from_date: $parameters.p_from_date,
                           p_to_date  : $parameters.p_to_date,
                           p_plant    : $parameters.p_plant
                           )                      as z542      on z542.material = a.Product

  // Goods Issue Transfer (641)
    left outer join       ZMMR_REPORT641(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as z641      on z641.material = a.Product

    left outer join       ZMMR_REPORT642(
                           p_from_date: $parameters.p_from_date,
                           p_to_date  : $parameters.p_to_date,
                           p_plant    : $parameters.p_plant
                           )                      as z642      on z642.material = a.Product

  // Goods Sales Return (653)
    left outer join       ZMMR_REPORT653(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as z653      on z653.material = a.Product

    left outer join       ZMMR_REPORT654(
                           p_from_date: $parameters.p_from_date,
                           p_to_date  : $parameters.p_to_date,
                           p_plant    : $parameters.p_plant
                           )                      as z654      on z654.material = a.Product

  // Closing stock (on p_to_date)
    left outer join       ZMMR_REPORT11(
                          p_from_date: $parameters.p_from_date,
                          p_to_date  : $parameters.p_to_date,
                          p_plant    : $parameters.p_plant
                          )                       as q         on  q.MATERIAL = a.Product
                                                               and q.enddate  = $parameters.p_to_date
{
  key  a.Product                                                                                                       as Material,
  key  e.Plant                                                                                                         as Plant,
  key  $parameters.p_from_date                                                                                         as PeriodFrom,
       a.ProductType                                                                                                   as MaterialType,
       c.ProductDescription                                                                                            as MaterialDescription,
       a.BaseUnit                                                                                                      as BaseUom,
       a.ProductGroup                                                                                                  as MaterialGroup,
       b.ValuationClass                                                                                                as ValuationClass,
       b.Currency                                                                                                      as Currency,
       e.ProfitCenter                                                                                                  as ProfitCenter,

       // Period context (optional)
       //    $parameters.p_from_date                as PeriodFrom,
       $parameters.p_to_date                                                                                           as PeriodTo,

       // Opening and closing
       //       g.MaterialBaseUnit,
       a.BaseUnit                                                                                                      as MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       // coalesce(g.OpeningQTY,          0)     as OpeningQty,
       cast( coalesce( g.OpeningQTY, 0 ) as abap.dec( 15, 3 ) )                                                        as OpeningQty,
       //  coalesce(q.closingQTY,          0)     as ClosingQty,
       cast( coalesce( q.closingQTY, 0 ) as abap.dec( 15, 3 ) )                                                        as ClosingQty,
       // Flows
       cast( coalesce(h.PrdQty,0) - coalesce(hn.PrdQty,0)   as abap.dec( 15, 3 ) )                                     as ProductionQty,
       //  cast( coalesce( h.PrdQty, 0 ) as abap.dec( 15, 2 ) ) as ProductionQty,
       //  coalesce(h.Prdvalue,            0)     as ProductionValue,
       cast( coalesce( h.Prdvalue, 0 ) - coalesce( hn.Prdvalue, 0 ) as abap.dec( 15, 2 ) )                             as ProductionValue,
       h.CompanyCodeCurrency,

       cast(coalesce(i.PurchaseQty,0) - coalesce(in.PurchaseQty,0) as abap.dec( 15, 3 ) )                              as PurchaseQty,
       //     coalesce(i.Purchasevalue,       0)                       as PurchaseValue,
       cast(coalesce(i.Purchasevalue, 0) - coalesce(in.Purchasevalue, 0) as abap.dec( 15, 2 ) )                        as PurchaseValue,

       //       coalesce(j.ReturnQty,           0)                       as ReturnQty,
       //       coalesce(j.Returnvalue,         0)                       as ReturnValue,
       //
       //       coalesce(k.IssueToOrderQty,     0)                       as IssueToOrderQty,
       //       coalesce(k.IssueToOrdervalue,   0)                       as IssueToOrderValue,
       //
       //       coalesce(l.IssueToAssetsQty,    0)                       as IssueToAssetsQty,
       //       coalesce(l.IssueToAssetsvalue,  0)                       as IssueToAssetsValue,
       //
       //       coalesce(m.SaleQty,             0)                       as SaleQty,
       //       coalesce(m.Salevalue,           0)                       as SaleValue,
       //
       //       coalesce(n.ScrapQty,            0)                       as ScrapQty,
       //       coalesce(n.Scrapvalue,          0)                       as ScrapValue,
       //
       //       coalesce(o.PhysicalAdjustmentQty,  0)                    as PhysicalAdjustmentQty,
       //       coalesce(o.PhysicalDifferencevalue, 0)                   as PhysicalDifferenceValue,
       //
       //       coalesce(p.SubContractConsQty,  0)                       as SubContractConsQty,
       //       coalesce(p.SubContractConsvalue,0)                       as SubContractConsValue,

       cast(coalesce(j.ReturnQty,0) - coalesce(jn.ReturnQty,0) as abap.dec( 15, 3 ) )                                  as ReturnQty,
       cast(coalesce(j.Returnvalue,0) - coalesce(jn.Returnvalue,0) as abap.dec( 15, 2 ) )                              as ReturnValue,

       cast(coalesce(k.IssueToOrderQty,0) - coalesce(kn.IssueToOrderQty,0) as abap.dec( 15, 3 ) )                      as IssueToOrderQty,
       cast(coalesce(k.IssueToOrdervalue,0) - coalesce(kn.IssueToOrdervalue,0) as abap.dec( 15, 2 ) )                  as IssueToOrderValue,

       cast(coalesce(l.IssueToAssetsQty,0) - coalesce(ln.IssueToAssetsQty,0) as abap.dec( 15, 3 ) )                    as IssueToAssetsQty,
       cast(coalesce(l.IssueToAssetsvalue,0) - coalesce(ln.IssueToAssetsvalue,0) as abap.dec( 15, 2 ) )                as IssueToAssetsValue,

       cast(coalesce(m.SaleQty,0) - coalesce(mn.SaleQty,0)  as abap.dec( 15, 3 ) )                                     as SaleQty,
       cast(coalesce(m.Salevalue,0) - coalesce(mn.Salevalue,0) as abap.dec( 15, 2 ) )                                  as SaleValue,

       cast(coalesce(n.ScrapQty,0) - coalesce(nn.ScrapQty,0) as abap.dec( 15, 3 ) )                                    as ScrapQty,
       cast(coalesce(n.Scrapvalue,0) - coalesce(nn.Scrapvalue,0) as abap.dec( 15, 2 ) )                                as ScrapValue,

       cast(coalesce(o.PhysicalAdjustmentQty,0) - coalesce(o_n.PhysicalAdjustmentQty,0)  as abap.dec( 15, 3 ) )        as PhysicalAdjustmentQty,
       cast(coalesce(o.PhysicalDifferencevalue,0) - coalesce(o_n.PhysicalDifferencevalue,0) as abap.dec( 15, 2 ) )     as PhysicalDifferenceValue,

       cast(coalesce(p.SubContractConsQty,0) - coalesce(pn.SubContractConsQty,0)   as abap.dec( 15, 3 ) )              as SubContractConsQty,
       cast(coalesce(p.SubContractConsvalue,0) - coalesce(pn.SubContractConsvalue,0)  as abap.dec( 15, 2 ) )           as SubContractConsValue,

       cast(coalesce(r.GenConsumpQty,0) - coalesce(rn.GenConsumpQty,0)  as abap.dec( 15, 3 ) )                         as GenConsumpQty,
       cast(coalesce(r.GenConsumpValue,0) - coalesce(rn.GenConsumpValue,0) as abap.dec( 15, 2 ) )                      as GenConsumpValue,



       cast(coalesce(z221.GItoPrjQty,0) - coalesce(z222.GItoPrjQty,0)  as abap.dec( 15, 3 ) )                          as GItoPrjQty,
       cast(coalesce(z221.GItoPrjValue,0) - coalesce(z222.GItoPrjValue,0) as abap.dec( 15, 2 ) )                       as GItoPrjValue,

       cast(coalesce(ztrout301.GITransferQty,0) - coalesce(ztrout302.GITransferQty,0)  as abap.dec( 15, 3 ) )          as GITransferOutQty,
       cast(coalesce(ztrout301.GITransferValue,0) - coalesce(ztrout302.GITransferValue,0) as abap.dec( 15, 2 ) )       as GITransferOutValue,

       cast(coalesce(ztrin301.GITransferQty,0) - coalesce(ztrin302.GITransferQty,0)  as abap.dec( 15, 3 ) )            as GITransferInQty,
       cast(coalesce(ztrin301.GITransferValue,0) - coalesce(ztrin302.GITransferValue,0) as abap.dec( 15, 2 ) )         as GITransferInValue,

       cast(coalesce(z541.GoodsAtSubcontractQty,0) - coalesce(z542.GoodsAtSubcontractQty,0)  as abap.dec( 15, 3 ) )    as GoodsAtSubcontractQty,
       cast(coalesce(z541.GoodsAtSubcontractValue,0) - coalesce(z542.GoodsAtSubcontractValue,0) as abap.dec( 15, 2 ) ) as GoodsAtSubcontractValue,

       cast(coalesce(z641.GITransferQty,0) - coalesce(z642.GITransferQty,0)  as abap.dec( 15, 3 ) )                    as GITransferQty,
       cast(coalesce(z641.GITransferValue,0) - coalesce(z642.GITransferValue,0) as abap.dec( 15, 2 ) )                 as GITransferValue,

       cast(coalesce(z653.GRReturnQty,0) - coalesce(z654.GRReturnQty,0)  as abap.dec( 15, 3 ) )                        as GRReturnQty,
       cast(coalesce(z653.GRReturnValue,0) - coalesce(z654.GRReturnValue,0) as abap.dec( 15, 2 ) )                     as GRReturnValue,

       case
       when b.InventoryValuationProcedure = 'V' then
       cast(
       cast(coalesce(g.OpeningQTY,0) as abap.dec(15,3))
       * cast(coalesce(b.MovingAveragePrice,0) as abap.dec(15,5))
       as abap.dec(23,2)
       )
       when b.InventoryValuationProcedure = 'S' then
       cast(
       cast(coalesce(g.OpeningQTY, 0) as abap.dec(15,3))
       * cast(coalesce(b.StandardPrice, 0) as abap.dec(15,5))
       as abap.dec(23,2)
       )
       else cast(0 as abap.dec(23,2))
       end                                                                                                             as OpeningValue,

       case
       when b.InventoryValuationProcedure = 'S' then
       cast(
       cast(coalesce(q.closingQTY, 0) as abap.dec(15,3))
       * cast(coalesce(b.StandardPrice, 0) as abap.dec(15,5))
       as abap.dec(23,2)
       )
       when b.InventoryValuationProcedure = 'V' then
       cast(
       cast(coalesce(q.closingQTY, 0) as abap.dec(15,3))
       * cast(coalesce(b.MovingAveragePrice, 0) as abap.dec(15,5))
       as abap.dec(23,2)
       )
       else cast(0 as abap.dec(23,2))
       end                                                                                                             as ClosingValue


}
where
  a.ProductType <> 'ZSRV';
