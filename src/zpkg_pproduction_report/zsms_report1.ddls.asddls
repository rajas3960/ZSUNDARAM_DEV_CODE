@AbapCatalog.sqlViewName: 'ZSMS_REP1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SMS Report1'
@Metadata.ignorePropagatedAnnotations: true
define view ZSMS_REPORT1
  with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d
  as select from    I_GoodsMovementCube as  b 
 
  
//   //                                           )
//   inner join I_MfgOrderConfirmation as c on c.Plant = $parameters.p_plant
//              //  and c.ManufacturingOrder = b.ManufacturingOrder  
// // inner join I_MfgOrderConfirmation as c
// // and   c.ManufacturingOrder = b.ManufacturingOrder
//// and c.Plant    = b.Plant
//    //ADDED BY SAR TEAM 5-5-2026
//     inner join I_Product as p
//      on p.Product = b.Material   // join material with product
////ADDED BY SAR TEAM 5-5-2026
//{
//  key b.PostingDate as postdate,
//  key b.Material                      as material,
//    //  b.MaterialBaseUnit,
//     
//       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//    //   case 
//     //  when b.Plant = '2005'and b.MaterialType = '261' and b.StorageLocation = '2SRM'
//      // then
//   sum(b.TotalGdsMvtQtyInBaseUnit)    as Captivepower,
// 
//  // b.TotalGdsMvtQtyInBaseUnit   as Captivepower,
//    b.MaterialBaseUnit,
// 
//   
//    //ADDED BY SAR TEAM 5-5-2026
//     // Conditional Gridpower logic
//     
//      case 
//        when p.ProductType = 'ZRAW'and c.Plant = '2005' 
//        then 0
//        else c.OpConfirmedWorkQuantity2
//      end as Gridpower
//      //ADDED BY SAR TEAM 5-5-2026
//}
//
//where 
//b.Material = '000000000200000003'
//and c.ManufacturingOrderType = 'ZBIL' 
//and b.GoodsMovementType = '261' or b.GoodsMovementType = '262'
////and b.GoodsMovementType = '261' 
////and  b.StorageLocation = '2SRM'
//////and b.MaterialType = 'ZFIN'
//////and b.ManufacturingOrder = '000032000402'
////and b.Plant = $parameters.p_plant
//and  ( b.PostingDate >= $parameters.p_from_date and b.PostingDate <= $parameters.p_to_date )
//group by
//b.PostingDate,
//  b.Material,
//  b.MaterialBaseUnit,
//  p.ProductType,
//  c.Plant,
//  c.OpConfirmedWorkQuantity2
//  //b.TotalGdsMvtQtyInBaseUnit
  
  
  
  
  
  
  
  
  
  
  //NEW LOGIC
  
 inner join I_MfgOrderConfirmation as c
    on c.ManufacturingOrder = b.ManufacturingOrder
   and c.Plant              = b.Plant

 inner join I_ManufacturingOrder as mo
    on mo.ManufacturingOrder = b.ManufacturingOrder

 inner join I_Product as p
    on p.Product = mo.Product

{
    
  key b.PostingDate as postdate,

  key mo.Product    as material,   // Billet Material

      b.MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'

      sum( b.TotalGdsMvtQtyInBaseUnit ) as Captivepower,

      sum(

        case

          when p.ProductType = 'ZRAW'
           and c.Plant = '2005'

          then 0

          else c.OpConfirmedWorkQuantity2

        end

      ) as Gridpower

}

where

      b.Material = '000000000200000003'

  and b.Plant = $parameters.p_plant

  and (
        b.GoodsMovementType = '261'
        or b.GoodsMovementType = '262'
      )

  and mo.ManufacturingOrderType = 'ZBIL'

  and b.PostingDate >= $parameters.p_from_date

  and b.PostingDate <= $parameters.p_to_date

group by

      b.PostingDate,
      mo.Product,
      b.MaterialBaseUnit

