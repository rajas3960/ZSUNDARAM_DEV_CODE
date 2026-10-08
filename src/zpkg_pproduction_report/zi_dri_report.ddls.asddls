@AbapCatalog.sqlViewName: 'ZI_DRI_REP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for DRI Production report'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_DRI_REPORT
  with parameters

    p_from_date : datum,

    p_to_date   : datum,
    p_plant     : werks_d
  as select distinct from zdt_dri_prd_01                                                                                                         as A
  
    inner join            I_ProductText                                                                                                           as b on b.Product = A.material
       inner join       ZI_MATSTOCKTIMESSERIES as j on j.Material = A.material
         and ( j.EndDate >= $parameters.p_from_date and j.EndDate <= $parameters.p_to_date )
         and j.Plant = $parameters.p_plant
  //  left outer join       I_MaterialStockTimeSeries( P_StartDate: $parameters.p_from_date , P_EndDate: $parameters.p_to_date , P_PeriodType: 'D') as c on c.Material = A.material
    left outer join       ZDR_REPORT2( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant)     as c on c.material = A.material
    and c.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as d on  d.PostingDate        = $parameters.p_to_date
  //                                                                                                                                                       and d.Plant              = $parameters.p_plant
  //                                                                                                                                                       and d.Material           =  A.material
  //                                                                                                                                                       and d.Plant = A.plant
  //                                                                                                                                                       and d.ManufacturingOrder <> ''
    left outer join       ZDR_REPORT3 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant )   as d on  d.material    = A.material
                                                                                                                                                         and d.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as e on  e.PostingDate = $parameters.p_to_date
  //                                                                                                                                                       and e.Material    = A.material
  //                                                                                                                                                       and e.Plant = A.plant
    left outer join       ZDR_REPORT4 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant )   as e on  e.material    = A.material
                                                                                                                                                        and e.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as f on  f.PostingDate        = $parameters.p_to_date
  //                                                                                                                                                       and f.Material           = A.material
  //                                                                                                                                                       and f.ManufacturingOrder = ''
  //                                                                                                                                                       and f.Plant = A.plant
    left outer join       ZDR_REPORT5 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )  as f on f.material = A.material
      and f.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as g on  g.PostingDate                = $parameters.p_to_date
  //                                                                                                                                                       and g.Material                   =  A.material
  //                                                                                                                                                       and g.Plant = A.plant
  //                                                                                                                                                       and g.MaxGoodsIssueQtyInBaseUnit <> 0
    left outer join       ZDR_REPORT6 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )  as g on g.material = A.material
      and g.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as h on  h.PostingDate               = $parameters.p_to_date
  //                                                                                                                                                       and h.Material                  =  A.material
  //                                                                                                                                                       and h.MaxGoodsRcptQtyInBaseUnit <> 0
  //                                                                                                                                                       and h.Plant = A.plant
    left outer join       ZDR_REPORT7 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )  as h on h.material = A.material
      and h.POSTINGDATE = j.EndDate
  //    left outer join       I_GoodsMovementCube                                                                                                     as i on  i.PostingDate = $parameters.p_to_date
  //                                                                                                                                                       and i.Material    = A.material
  //                                                                                                                                                       and i.Plant = A.plant

    left outer join       ZDR_REPORT8 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant  )  as i on i.material = A.material
      and i.POSTINGDATE = j.EndDate

 
  // left outer join       I_GoodsMovementCube                                                                                                     as j on  j.PostingDate = $parameters.p_to_date
  //                                                                                                                                                       and j.Material    = A.material
  //                                                                                                                                                       and j.Plant = A.plant
  //
  //                                                                                                                                               //        on j.Material = A.material
  //


    left outer join      ZR_PROD_KILN1 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as k on k.Material = A.material
    and k.PostingDate = j.EndDate
    
    left outer join     ZR_PROD_KILN2 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as L on L.Material = A.material
    and L.PostingDate = j.EndDate
    
     left outer join     ZR_PROD_KILN3 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as M on M.Material = A.material
    and M.PostingDate = j.EndDate
    
     left outer join     ZR_PROD_KILN4 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as N on N.Material = A.material
    and N.PostingDate = j.EndDate
    
     left outer join     ZR_CONS_KILN1 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as O on O.Material = A.material
    and O.PostingDate = j.EndDate
    
    left outer join     ZR_CONS_KILN2 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as P on P.Material = A.material
    and P.PostingDate = j.EndDate
    
    
   left outer join     ZR_CONS_KILN3 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as Q on Q.Material = A.material
    and Q.PostingDate = j.EndDate
    
    left outer join     ZR_CONS_KILN4 ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as R on R.Material = A.material
    and R.PostingDate = j.EndDate
    
    
    left outer join       ZI_SALES_RETURN ( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date , p_plant:$parameters.p_plant ) as S on S.material = A.material
                                                                                                                                                       and S.POSTINGDATE = j.EndDate 
       
    // ADDED BY SAR TEAM DT-01-07-2026
    
   left outer join ZI_STO_641( p_from_date: $parameters.p_from_date, p_to_date:$parameters.p_to_date , p_plant:$parameters.p_plant  )  as T on T.material = A.material  
                                                                                                                                            and T.POSTINGDATE = j.EndDate   
                                                                                                                                            
                                                                                                                                            
   left outer join ZI_COMP_COST_CENTER_201( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date , p_plant:$parameters.p_plant  )    as U on U.material = A.material 
                                                                                                                                                        and U.POSTINGDATE = j.EndDate
                                                                                                                                                        
   left outer join ZI_TRF_MATE_2_MATE_309( p_from_date: $parameters.p_from_date, p_to_date:$parameters.p_to_date , p_plant:$parameters.p_plant  )      as V on V.material = A.material
                                                                                                                                                        and V.POSTINGDATE = j.EndDate
                                                                                                                                                        
    // ADDED BY SAR TEAM DT-01-07-2026                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
{

  key A.material                     as Material,
  key A.plant                        as Plant,
  key b.ProductName                  as Product_name,
  key j.EndDate                  as postingdate,
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
      k.qty as                       PRODUCTION_KILN1,
      L.qty as                       PRODUCTION_KILN2,
      M.qty as                       PRODUCTION_KILN3,
      N.qty as                       PRODUCTION_KILN4,
     
      d.PRODUCTION                   as PRODUCTION,
      //      case
      //      when e.GoodsMovementType = '261' or e.GoodsMovementType = '262'
      //      then e.TotalGdsMvtQtyInBaseUnit
      //      end                            as CONSUMPTION,
      //
      O.qty as                       CONSUMPTION_KILN1,
      P.qty as                       CONSUMPTION_KILN2,
      Q.qty as                       CONSUMPTION_KILN3,
      R.qty as                       CONSUMPTION_KILN4,
      
      e.CONSUMPTION                  as CONSUMPTION,
      //      @Aggregation.default:#SUM
      //      case
      //      when f.GoodsMovementType = '102' or f.GoodsMovementType = '101'
      //      then f.TotalGdsMvtQtyInBaseUnit
      //      end                            as PURCHASE_GR,
      f.PURCHASE_GR                  as PURCHASE_GR,
      //      @Aggregation.default:#SUM
      //      case
      //      when g.GoodsMovementType = '301' or g.GoodsMovementType = '302'
      //      then g.TotalGdsMvtQtyInBaseUnit
      //      end                            as TRANSFER_OUT,
      g.TRANSFIR_OUT                 as TRANSFER_OUT,

      //      @Aggregation.default:#SUM
      //      case
      //      when h.GoodsMovementType = '301' or h.GoodsMovementType = '302'
      //      then h.TotalGdsMvtQtyInBaseUnit
      //      end                            as TRANSFER_IN,
      h.TRANSFIR_IN                  as TRANSFER_IN,


      //      @Aggregation.default:#SUM
      //      case
      //      when i.GoodsMovementType = '601' or i.GoodsMovementType = '602'
      //      then i.TotalGdsMvtQtyInBaseUnit
      //      end                            as SALES,
      i.SALES                        as SALES,
      S.SALES_RETRUN                 as SALES_RETURN,

      @Aggregation.default:#SUM
      j.closingstock as CLOSING_STOCK,

      //     dats_add_days($parameters.p_from_date , -1,'NULL') as yesterday

 // ADDED BY SAR TEAM DT-01-07-2026
     T.STO_641                       as STO_641,
     U.COMP_COST_CENTER_201          as COMP_COST_CENTER_201,
     V.TRF_MATE_2_MATE               as TRF_MATE_2_MATE 
   // ADDED BY SAR TEAM DT-01-07-2026   
     
}
where A.plant = $parameters.p_plant
