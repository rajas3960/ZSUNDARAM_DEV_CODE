@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for DRI Production report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSMS_REPORT
  with parameters

    p_from_date : datum,

    p_to_date   : datum,
    p_plant     : werks_d
  as select distinct from   zdt_dri_prd_01                                                                                                            as A

    inner join            I_ProductText                                                                                                             as b on b.Product = A.material
    inner join            ZI_MATSTOCKTIMESSERIES 
                                                                                                       as j on  j.Material   = A.material
                                                                                                                                                         and (
                                                                                                                                                            j.EndDate     >= $parameters.p_from_date
                                                                                                                                                            and j.EndDate <= $parameters.p_to_date
                                                                                                                                                          )
                                                                                                                                                         and j.Plant      = $parameters.p_plant
  //  left outer join       I_MaterialStockTimeSeries( P_StartDate: $parameters.p_from_date , P_EndDate: $parameters.p_to_date , P_PeriodType: 'D') as c on c.Material = A.material
    left outer join       ZDR_REPORT2( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant)       as c on  c.material    = A.material
                                                                                                                                                         and c.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as d on  d.PostingDate        = $parameters.p_to_date
  //                                                                                                                                                       and d.Plant              = $parameters.p_plant
  //                                                                                                                                                       and d.Material           =  A.material
  //                                                                                                                                                       and d.Plant = A.plant
  //                                                                                                                                                       and d.ManufacturingOrder <> ''
    left outer join       ZDR_REPORT3 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant )     as d on  d.material    = A.material
                                                                                                                                                         and d.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as e on  e.PostingDate = $parameters.p_to_date
  //                                                                                                                                                       and e.Material    = A.material
  //                                                                                                                                                       and e.Plant = A.plant
    left outer join       ZDR_REPORT4 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant )     as e on  e.material    = A.material
                                                                                                                                                         and e.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as f on  f.PostingDate        = $parameters.p_to_date
  //                                                                                                                                                       and f.Material           = A.material
  //                                                                                                                                                       and f.ManufacturingOrder = ''
  //                                                                                                                                                       and f.Plant = A.plant
    left outer join       ZDR_REPORT5 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )    as f on  f.material    = A.material
                                                                                                                                                         and f.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as g on  g.PostingDate                = $parameters.p_to_date
  //                                                                                                                                                       and g.Material                   =  A.material
  //                                                                                                                                                       and g.Plant = A.plant
  //                                                                                                                                                       and g.MaxGoodsIssueQtyInBaseUnit <> 0
    left outer join       ZDR_REPORT6 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )    as g on  g.material    = A.material
                                                                                                                                                         and g.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as h on  h.PostingDate               = $parameters.p_to_date
  //                                                                                                                                                       and h.Material                  =  A.material
  //                                                                                                                                                       and h.MaxGoodsRcptQtyInBaseUnit <> 0
  //                                                                                                                                                       and h.Plant = A.plant
    left outer join       ZDR_REPORT7 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )    as h on  h.material    = A.material
                                                                                                                                                         and h.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as i on  i.PostingDate = $parameters.p_to_date
  //                                                                                                                                                       and i.Material    = A.material
  //                                                                                                                                                       and i.Plant = A.plant

    left outer join       ZDR_REPORT8 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )    as i on  i.material    = A.material
                                                                                                                                                         and i.POSTINGDATE = j.EndDate


  // left outer join       I_GoodsMovementCube                                                                                                     as j on  j.PostingDate = $parameters.p_to_date
  //                                                                                                                                                       and j.Material    = A.material
  //                                                                                                                                                       and j.Plant = A.plant
  //
  //                                                                                                                                               //        on j.Material = A.material
  //
    left outer join       I_Product                                                                                                                 as k on k.Product = b.Product

    left outer join       ZSMS_REPORT2 (  p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant )   as l on  l.material = A.material
                                                                                                                                                         and l.postdate = j.EndDate

    left outer join       ZI_SALES_RETURN ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as m on  m.material    = A.material
                                                                                                                                                         and m.POSTINGDATE = j.EndDate

    left outer join       ZI_PURCHASE_GR_RETURN( p_from_date: $parameters.p_from_date, p_to_date: $parameters.p_to_date, p_plant:$parameters.p_plant  ) as n on n.material = A.material
                                                                                                                                                          and n.POSTINGDATE = j.EndDate
                                                                                                                                                          
     
     // ADDED BY SAR TEAM DT-30-06-2026                                                                                                                                                     
    left outer join       ZI_STO_641( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date , p_plant: $parameters.p_plant )     as o on o.material = A.material
                                                                                                                                                      and o.POSTINGDATE = j.EndDate  
                                                                                                                                                      
    left outer join       ZI_COMP_COST_CENTER_201( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date , p_plant: $parameters.p_plant )   as p on p.material = A.material  
                                                                                                                                                           and p.POSTINGDATE = j.EndDate 
                                                                                                                                                           
                                                                                                                                                           
     left outer join     ZI_TRF_MATE_2_MATE_309( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date , p_plant: $parameters.p_plant )     as q on q.material = A.material
                                                                                                                                                            and q.POSTINGDATE  = j.EndDate    
                                                                                                                                                            
                                                                                                                                                            
    // ADDED BY SAR TEAM DT-30-06-2026                                                                                                                                                                                                                                                                                                       
    // Added by SAR TEAM DT-05-08-2026  
    
    left outer join ZI_Return_Delivery_122( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date , p_plant:$parameters.p_plant  )   as r on r.material = A.material
                                                                                                                                                        and r.POSTINGDATE = j.EndDate    
    // Added by SAR TEAM DT-05-08-2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
{

  key A.material                                         as Material,
  key A.plant                                            as Plant,
  key b.ProductName                                      as Product_name,
  key j.EndDate                                          as postingdate,
      ///key c.PeriodType, // ++ 26.08.25
      //  key c.EndDate ,
      // key c.YearPeriod,
      // key c.StorageLocation,
      // key c.Batch,
      //  key c.Supplier,
      //  key c.SDDocument,
      //  key c.SDDocumentItem,
      //  key c.WBSElementInternalID,
      // key c.EndDate ,
      //   c.InventorySpecialStockType,
      //   c.FiscalYearVariant,
      // d.MaterialDocument,
      //  d.MaterialDocumentItem,

      //   b.ProductName                  as Product_name,
      c.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      //   c.MatlWrhsStkQtyInMatlBaseUnit as OPENING,
      c.OPENING,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default:#SUM
      //      case
      //      when d.GoodsMovementType = '101' or d.GoodsMovementType = '531' or d.GoodsMovementType = '102' or d.GoodsMovementType = '532'
      //      then d.TotalGdsMvtQtyInBaseUnit
      //      end                            as PRODUCTION,
      //  @Aggregation.default:#SUM
      d.PRODUCTION                                       as PRODUCTION,
      //      case
      //      when e.GoodsMovementType = '261' or e.GoodsMovementType = '262'
      //      then e.TotalGdsMvtQtyInBaseUnit
      //      end                            as CONSUMPTION,
      //
      cast(e.CONSUMPTION   as abap.dec( 21, 3 ))                                   as CONSUMPTION,
      //      @Aggregation.default:#SUM
      //      case
      //      when f.GoodsMovementType = '102' or f.GoodsMovementType = '101'
      //      then f.TotalGdsMvtQtyInBaseUnit
      //      end                            as PURCHASE_GR,
      cast(f.PURCHASE_GR as abap.dec( 21, 2) )                                    as PURCHASE_GR,
      //      @Aggregation.default:#SUM
      //      case
      //      when g.GoodsMovementType = '301' or g.GoodsMovementType = '302'
      //      then g.TotalGdsMvtQtyInBaseUnit
      //      end                            as TRANSFER_OUT,
     cast( g.TRANSFIR_OUT  as abap.dec( 21, 2) )                                as TRANSFER_OUT,

      //      @Aggregation.default:#SUM
      //      case
      //      when h.GoodsMovementType = '301' or h.GoodsMovementType = '302'
      //      then h.TotalGdsMvtQtyInBaseUnit
      //      end                            as TRANSFER_IN,
      cast(h.TRANSFIR_IN   as abap.dec( 21, 2 )  )                                as TRANSFER_IN,


      //      @Aggregation.default:#SUM
      //      case
      //      when i.GoodsMovementType = '601' or i.GoodsMovementType = '602'
      //      then i.TotalGdsMvtQtyInBaseUnit
      //      end                            as SALES,
      cast( i.SALES   as abap.dec( 21, 2 )  )                                          as SALES,

      @Aggregation.default:#SUM
      cast( j.closingstock     as abap.dec( 21, 2 )  )                                 as CLOSING_STOCK,
      k.BaseUnit                                         as UOM,
      //      case
      //       when A.material = '200000011' and A.plant = '1005'
      //         then round(division(j.closingstock , 471,2),1)
      //
      //       when A.material = '150000017' and A.plant = '2005'
      //         then round(division(j.closingstock , 469,2),1)
      //       else 0
      //      end                                                as PIECE,
      case
        when A.material = '200000011' and A.plant = '1005'
          then  cast(j.closingstock as abap.dec( 21, 3 )) / cast(471 as abap.dec( 21, 3 ))
        when A.material = '150000017' and A.plant = '2005'
          then cast(j.closingstock as abap.dec( 21, 3 )) / cast(469 as abap.dec( 21, 3 ))
        else 0
         end                                             as PIECE,

      division(A.percentrecovery ,100,2)                 as Recovery,
      cast(e.CONSUMPTION * division(A.percentrecovery ,100,2) as  abap.dec( 21, 2 )  )  as Metal,

      case
      when d.PRODUCTION is null or d.PRODUCTION = 0
      then cast( 0 as abap.dec(15,4) )
      else
      cast(
      division(
      cast( e.CONSUMPTION as abap.dec(15,3) )
      * division( cast( A.percentrecovery as abap.dec(5,2) ), 100, 6 ),
      cast( d.PRODUCTION as abap.dec(15,3) ),
      4 )
      as abap.dec(15,4) )
      end                                                as PercentMetal,
      //  e.CONSUMPTION * division(A.percentrecovery ,100,2) as
      cast( l.Captivepower as abap.dec( 21, 2 )  )                                      as CaptivePower,
      cast( l.Gridpower  as abap.dec( 21, 2 )  )                                       as Gridpower,
      cast( l.TotalPower as abap.dec( 21, 2 )  )                                      as TotalPower,
      case
      when l.TotalPower is null or l.TotalPower = 0
      or d.PRODUCTION is null or d.PRODUCTION = 0
      then cast( 0 as abap.dec(15,4) )
      else
      cast(
        division(
          cast( d.PRODUCTION as abap.dec(15,4) ),
          cast( l.TotalPower as abap.dec(15,4) ),
          4
        ) as abap.dec(15,4)
      )
      end                                                as Average,
      cast ( m.SALES_RETRUN  as abap.dec( 21, 2 )  )                                    as SALES_RETUN,


      //     dats_add_days($parameters.p_from_date , -1,'NULL') as yesterday

       cast(n.PURCHASE_GR_RETURN as abap.dec( 21, 2) )                                    as PURCHASE_GR_RETURN,
       
       // ADDED BY SAR TEAM DT-30-06-2026  
       
       cast(o.STO_641 as abap.dec(21,3) )                                                  as STO_641,
       
       cast(p.COMP_COST_CENTER_201 as abap.dec(21,3) )                                     as COMP_COST_CENTER_201,
       
       cast(q.TRF_MATE_2_MATE as abap.dec(21,3) )                                          as TRF_MATE_2_MATE_309,
       
        // ADDED BY SAR TEAM DT-30-06-2026 
        
        // Added by SAR TEAM DT-05-08-2026
        
        cast(r.Return_to_Delivery as abap.dec( 21,3 ))                                     as Return_to_Delivery
        
        // Added by SAR TEAM DT-05-08-2026
}
where
  A.plant = $parameters.p_plant
