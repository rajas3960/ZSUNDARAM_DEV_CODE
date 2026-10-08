@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALES_REG
  as select distinct from I_BillingDocument                                                              as BillingDoc
    inner join            zdt_user_auth                                                                  as user             on  BillingDoc.CompanyCode = user.companycode
                                                                                                                             and user.cbuser            = $session.user
    inner join            I_BillingDocumentItem                                                          as BillingDocItem   on BillingDoc.BillingDocument = BillingDocItem.BillingDocument
    left outer join       I_Customer                                                                     as SoldToCustomer   on BillingDoc.SoldToParty = SoldToCustomer.Customer
    left outer join       I_Customer                                                                     as ShipToCustomer   on BillingDocItem.ShipToParty = ShipToCustomer.Customer
    left outer join       I_Customer                                                                     as BillToCustomer   on BillingDocItem.BillToParty = BillToCustomer.Customer
    left outer join       I_Customer                                                                     as PayerCustomer    on BillingDoc.PayerParty = PayerCustomer.Customer
    left outer join       I_SalesDocument                                                                as SalesDoc         on BillingDocItem.SalesDocument = SalesDoc.SalesDocument
    left outer join       I_SalesDocumentItem                                                            as SalesDocitem     on  BillingDocItem.SalesDocument     = SalesDocitem.SalesDocument
                                                                                                                             and BillingDocItem.SalesDocumentItem = SalesDocitem.SalesDocumentItem
    left outer join       I_BillingDocument                                                              as bildate          on bildate.BillingDocument          = SalesDocitem.ReferenceSDDocument
                                                                                                                             and(
                                                                                                                               BillingDoc.BillingDocumentType    = 'G2'
                                                                                                                               or BillingDoc.BillingDocumentType = 'CBRE'
                                                                                                                               or BillingDoc.BillingDocumentType = 'L2'
                                                                                                                             )
    left outer join       I_SalesDocItemPricingElement                                                   as agentcommisition on  BillingDocItem.SalesDocument     = agentcommisition.SalesDocument
                                                                                                                             and BillingDocItem.SalesDocumentItem = agentcommisition.SalesDocumentItem
                                                                                                                             and agentcommisition.ConditionType   = 'ZBRO'
  //    left outer join       I_SalesDocItemPricingElement   as cgst             on  BillingDocItem.SalesDocument     = cgst.SalesDocument
  //                                                                             and BillingDocItem.SalesDocumentItem = cgst.SalesDocumentItem
  //                                                                             and cgst.ConditionType               = 'JOCG'
    left outer join       I_BillingDocumentItemPrcgElmnt                                                 as cgst             on  BillingDocItem.BillingDocument     = cgst.BillingDocument
                                                                                                                             and BillingDocItem.BillingDocumentItem = cgst.BillingDocumentItem
                                                                                                                             and cgst.ConditionType                 = 'JOCG'

  //    left outer join       I_SalesDocItemPricingElement   as utgst            on  BillingDocItem.SalesDocument     = utgst.SalesDocument
  //                                                                             and BillingDocItem.SalesDocumentItem = utgst.SalesDocumentItem
  //                                                                             and cgst.ConditionType               = 'JOUG'
    left outer join       I_BillingDocumentItemPrcgElmnt                                                 as utgst            on  BillingDocItem.BillingDocument     = utgst.BillingDocument
                                                                                                                             and BillingDocItem.BillingDocumentItem = utgst.BillingDocumentItem
                                                                                                                             and utgst.ConditionType                = 'JOUG'
  //    left outer join       I_SalesDocItemPricingElement   as sgst             on  BillingDocItem.SalesDocument     = sgst.SalesDocument                // -- 13.08.25
  //                                                                             and BillingDocItem.SalesDocumentItem = sgst.SalesDocumentItem            // -- 13.08.25
  //                                                                             and sgst.ConditionType               = 'JOSG'                            // -- 13.08.25
    left outer join       I_BillingDocumentItemPrcgElmnt                                                 as sgst             on  BillingDocItem.BillingDocument     = sgst.BillingDocument     // ++ 13.08.25
                                                                                                                             and BillingDocItem.BillingDocumentItem = sgst.BillingDocumentItem // ++ 13.08.25
                                                                                                                             and sgst.ConditionType                 = 'JOSG'                   // ++ 13.08.25
  //    left outer join       I_SalesDocItemPricingElement   as Igst             on  BillingDocItem.SalesDocument     = Igst.SalesDocument     // -- 13.08.25
  //                                                                             and BillingDocItem.SalesDocumentItem = Igst.SalesDocumentItem // -- 13.08.25
  //                                                                             and Igst.ConditionType               = 'JOIG'                 // 13.08.25
    left outer join       I_BillingDocumentItemPrcgElmnt                                                 as Igst             on  BillingDocItem.BillingDocument     = Igst.BillingDocument     // ++ 13.08.25
                                                                                                                             and BillingDocItem.BillingDocumentItem = Igst.BillingDocumentItem // ++ 13.08.25
                                                                                                                             and Igst.ConditionType                 = 'JOIG'                   // ++ 13.08.25


  //    left outer join       I_SalesDocItemPricingElement   as freight          on  BillingDocItem.SalesDocument     = freight.SalesDocument
  //                                                                             and BillingDocItem.SalesDocumentItem = freight.SalesDocumentItem
  //                                                                             and freight.ConditionType            = 'ZFRE'
    left outer join       I_BillingDocItemPrcgElmntBasic                                                 as tcs              on  BillingDocItem.BillingDocument     =  tcs.BillingDocument
                                                                                                                             and BillingDocItem.BillingDocumentItem =  tcs.BillingDocumentItem
                                                                                                                             and (
                                                                                                                                tcs.ConditionType                   =  'JTC1'
                                                                                                                                or tcs.ConditionType                =  'JTC2'
                                                                                                                                or tcs.ConditionType                =  'JTCT'
                                                                                                                              )
                                                                                                                             and tcs.ConditionAmount                <> 0.00
    left outer join       I_SalesDocItemPricingElement                                                   as compcess         on  BillingDocItem.SalesDocument     =  compcess.SalesDocument
                                                                                                                             and BillingDocItem.SalesDocumentItem =  compcess.SalesDocumentItem
                                                                                                                             and compcess.ConditionType           =  'ZCES'
                                                                                                                             and compcess.ConditionAmount         <> 0.00
  // -- on 13.08.25 by sp
  //    left outer join       I_SalesDocItemPricingElement   as srate            on  BillingDocItem.SalesDocument     =  srate.SalesDocument
  //                                                                             and BillingDocItem.SalesDocumentItem =  srate.SalesDocumentItem
  //                                                                             and srate.ConditionType              =  'ZPR0'
  //                                                                             and srate.ConditionAmount            <> 0.00
  // -- till this by sp on 13.08.25
  // ++ by sp on 13.08.25
    left outer join       I_BillingDocumentItemPrcgElmnt                                                 as srate            on  BillingDocItem.BillingDocument     =  srate.BillingDocument
                                                                                                                             and BillingDocItem.BillingDocumentItem =  srate.BillingDocumentItem
                                                                                                                             and srate.ConditionType                =  'ZPR0'
                                                                                                                             and srate.ConditionAmount              <> 0.00
  // ++ till this by sp on 13.08.25
    left outer join       I_BillingDocItemPrcgElmntBasic                                                 as inv              on  inv.BillingDocument     = BillingDoc.BillingDocument
                                                                                                                             and inv.BillingDocumentItem = BillingDocItem.BillingDocumentItem
                                                                                                                             and inv.ConditionType       = 'ZACC'
    left outer join       I_Plant                                                                        as Plant            on BillingDocItem.Plant = Plant.Plant
    left outer join       I_Product                                                                      as Product          on BillingDocItem.Product = Product.Product
    left outer join       I_IN_ElectronicDocTransptRegn                                                  as EWayBill         on BillingDoc.BillingDocument = EWayBill.ElectronicDocSourceKey
    left outer join       I_DeliveryDocument                                                             as deliverydoc      on  deliverydoc.DeliveryDocument               = BillingDocItem.ReferenceSDDocument
                                                                                                                             and BillingDocItem.ReferenceSDDocumentCategory = 'J'
    left outer join       I_DeliveryDocumentItem                                                         as deliverydocitem  on  deliverydocitem.DeliveryDocument           = BillingDocItem.ReferenceSDDocument
                                                                                                                             and deliverydocitem.DeliveryDocumentItem       = BillingDocItem.ReferenceSDDocumentItem
                                                                                                                             and BillingDocItem.ReferenceSDDocumentCategory = 'J'
    left outer join       I_ProductPlantBasic                                                            as prdplnt          on  prdplnt.Product = BillingDocItem.Material
                                                                                                                             and prdplnt.Plant   = BillingDocItem.Plant
    left outer join       I_JournalEntry                                                                 as je               on  je.AccountingDocument = BillingDoc.AccountingDocument
                                                                                                                             and je.FiscalYear         = BillingDoc.FiscalYear
  // left outer join       I_BillingDocumentPartner       as agent            on  agent.BillingDocument = BillingDoc.BillingDocument
  //                                                                          and agent.PartnerFunction = 'ZB'
    left outer join       I_SalesDocumentPartner                                                         as agent            on  agent.SalesDocument   = BillingDocItem.SalesDocument
                                                                                                                             and agent.PartnerFunction = 'ZB'
    left outer join       I_Customer                                                                     as agentname        on agentname.Customer = agent.Customer

    left outer join       zdt_einveway                                                                   as einv             on einv.vbeln = BillingDoc.BillingDocument
  //  left outer join       ZV_GATEHEAD                    as gate             on gate.Gatepassno = deliverydoc.YY1_GatePassNumber_DLH // -- on 13.08.25 by sp

    left outer join       ZR_CANCELL_BIL                                                                 as canc             on canc.Vbeln = BillingDoc.CancelledBillingDocument
     // ++ on 13.08.25 by sp
    left outer join       ZR_CANCELL_BIL                                                                 as canc1            on canc1.Vbeln = BillingDoc.BillingDocument
     // ++ on 24.02.26 by pp
 

    left outer join       I_BillingDocumentItemPrcgElmnt                                                 as roundoff         on  BillingDocItem.BillingDocument     = roundoff.BillingDocument // ++ NEW ADDED ON 14.08.25
                                                                                                                             and BillingDocItem.BillingDocumentItem = roundoff.BillingDocumentItem
                                                                                                                             and roundoff.ConditionType             = 'DRD1'

    left outer join       I_DeliveryDocument                                                             as gatepassnumber   on BillingDocItem.ReferenceSDDocument = gatepassnumber.DeliveryDocument
    left outer join       I_BillingDocumentItemCube(P_ExchangeRateType : 'M',P_DisplayCurrency  : 'INR') as BDC              on  BDC.BillingDocument     = BillingDocItem.BillingDocument
                                                                                                                             and BDC.BillingDocumentItem = BillingDocItem.BillingDocumentItem
    left outer join       I_BillingDocument                                                              as bdoc             on bdoc.CancelledBillingDocument = BillingDoc.BillingDocument

{
  key    BillingDoc.BillingDocument,
  key    BillingDocItem.BillingDocumentItem,
         case
         when BillingDoc.BillingDocumentType = 'F2' then
         'Invoice'
         when BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' then
         'Credit Note'
         when BillingDoc.BillingDocumentType = 'L2' then
         'Debit Note'

         when BillingDoc.BillingDocumentType = 'S1' and BDC.CancelledBillingDocument <> '' and BillingDoc.BillingDocumentCategory = 'L'
              then 'Cancelled Invoice'
         when BillingDoc.BillingDocumentType = 'S1' and BDC.CancelledBillingDocument <> '' and BillingDoc.BillingDocumentCategory = 'A'
              then 'Cancelled Debit Invoice'
         //              when BillingDoc.BillingDocumentType = 'S1'
         //              then 'Cancelled Invoice'
          when BillingDoc.BillingDocumentType = 'F8' then
         'Proforma Invoice'
         when BillingDoc.BillingDocumentType = 'S2' then
         'Cancelled Credit Note' end                                                            as billtype,
         BillingDoc.CompanyCode,
         BillingDoc.BillingDocumentType                                                         as billtyp,
         BillingDoc.BillingDocumentIsCancelled                                                  as cancelled,
         BillingDoc.BillingDocumentDate,
         BillingDocItem.SalesDocument,
         BillingDocItem.SalesDocumentItem                                                       as OrderItem,
         SalesDoc.SalesDocumentDate,
         BillingDocItem.ReferenceSDDocument                                                     as DeliveryNo,
         BillingDocItem.ReferenceSDDocumentItem                                                 as DeliveryItem,
         deliverydoc.ActualGoodsMovementDate                                                    as deliverydate,
         case
         when BillingDoc.BillingDocumentType <> 'G2' and BillingDoc.BillingDocumentType <> 'CBRE' and
          BillingDoc.BillingDocumentType <> 'L2' then
         SalesDocitem.ReferenceSDDocument end                                                   as salescontract,
         case
         when BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' or
         BillingDoc.BillingDocumentType = 'L2' then
         SalesDocitem.ReferenceSDDocument end                                                   as Orginalinvno,

         case
         when BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' or
         BillingDoc.BillingDocumentType = 'L2' then
         bildate.CreationDate end                                                               as Orginalinvdate,

         BillingDoc.SalesOrganization,
         BillingDoc.DistributionChannel,
         BillingDoc.Division,
         BillingDoc.SoldToParty,
         SoldToCustomer.BPCustomerFullName                                                      as SoldToPartyName,
         SoldToCustomer.TaxNumber3                                                              as soldtogstin,
         BillingDocItem.ShipToParty,
         ShipToCustomer.BPCustomerFullName                                                      as ShipToPartyName,
         ShipToCustomer.TaxNumber3                                                              as ShipToGSTIN,
         ///     agent.Customer                                                                         as Broker,
         agent.Partner                                                                          as Broker,
         agentname.CustomerName                                                                 as Brokername,
         prdplnt.ConsumptionTaxCtrlCode                                                         as HSNCode,
         Product.Product,
         Product.ProductType,
         BillingDocItem.BillingDocumentItemText,
         BillingDocItem.BillingQuantityUnit                                                     as uom,
         //         @Semantics.quantity.unitOfMeasure: 'UOM'
         //         case
         //         when BillingDoc.CancelledBillingDocument  is not initial  or BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE'
         //         then cast( ( BillingDocItem.BillingQuantity * ( -1 ) ) as abap.dec(23,2))
         //         else cast( BillingDocItem.BillingQuantity as abap.dec(23,2))     end                   as BillingQuantity,
         ////         case
         ////         when BillingDoc.CancelledBillingDocument is not initial
         ////             or BillingDoc.BillingDocumentType = 'G2'
         ////             or BillingDoc.BillingDocumentType = 'L2'
         ////             or BillingDoc.BillingDocumentType = 'CBRE' then
         ////          case
         ////            when abs(BillingDocItem.BillingQuantity) = 1
         ////                 or abs(BillingDocItem.BillingQuantity) = 0 then 0
         ////            else cast( - cast(BillingDocItem.BillingQuantity as abap.dec(23,2)) as abap.dec(23,2))
         ////          end
         ////         else
         ////          case
         ////            when abs(BillingDocItem.BillingQuantity) = 1
         ////                 or abs(BillingDocItem.BillingQuantity) = 0 then 0
         ////            else cast(BillingDocItem.BillingQuantity as abap.dec(23,2))
         ////          end
         ////        else
         ////         case
         ////            when Product.ProductType = 'ZSRV'
         ////                 then 0
         ////           // else cast(BillingDocItem.BillingQuantity as abap.dec(23,2))
         ////          end
         ////         end                                                                                    as BillingQuantity, // till this ++ sp on 10.09.25

         //         case
         //         when BillingDoc.CancelledBillingDocument is not initial
         //             or BillingDoc.BillingDocumentType = 'G2'
         //             or BillingDoc.BillingDocumentType = 'L2'
         //             or BillingDoc.BillingDocumentType = 'CBRE'
         //         then
         //           case
         //              when abs(BillingDocItem.BillingQuantity) = 1
         //                   or abs(BillingDocItem.BillingQuantity) = 0
         //              then 0
         //              else cast(- cast(BillingDocItem.BillingQuantity as abap.dec(23,2)) as abap.dec(23,2))
         //           end
         //
         //         else
         //         case
         ////               when BDC.SDDocumentReason = '210'
         ////                then cast( 0.00 as abap.dec(23,2) )
         ////               when BillingDoc.BillingDocumentType = 'G2'
         ////                 or BillingDoc.BillingDocumentType = 'CBRE'
         ////                 or BillingDoc.BillingDocumentType = 'L2'
         ////                then cast( 0.00 as abap.dec(23,2) )
         //              when Product.ProductType = 'ZSRV'
         //              then cast(0.00 as abap.dec(23,2))
         //              else
         //                 case
         //                    when abs(BillingDocItem.BillingQuantity) = 1
         //                         or abs(BillingDocItem.BillingQuantity) = 0
         //                    then cast(0.00 as abap.dec(23,2))
         //                    else cast(BillingDocItem.BillingQuantity as abap.dec(23,2))
         //                 end
         //           end
         //             end                                                                                as BillingQuantity,

         case

            when ( BillingDoc.BillingDocumentType = 'G2'
                or BillingDoc.BillingDocumentType = 'L2'
                or BillingDoc.BillingDocumentType = 'CBRE' )
                 and BDC.SDDocumentReason = '210'
            then cast(0.00 as abap.dec(23,2))

          //  when  // BillingDoc.CancelledBillingDocument is not initial
             when     BillingDoc.BillingDocumentType = 'G2'
                 or BillingDoc.BillingDocumentType = 'S1'
                 or BillingDoc.BillingDocumentType = 'CBRE'
            then
                 case
                     when abs(BillingDocItem.BillingQuantity) = 1
                       or abs(BillingDocItem.BillingQuantity) = 0
                     then cast(0.00 as abap.dec(23,2))
                     else cast(- BillingDocItem.BillingQuantity as abap.dec(23,2))
                 end

            else
                 case
                     when BDC.SDDocumentReason = '210'
                     then cast(0.00 as abap.dec(23,2))

                     when Product.ProductType = 'ZSRV'
                     then cast(0.00 as abap.dec(23,2))

                     when abs(BillingDocItem.BillingQuantity) = 1
                       or abs(BillingDocItem.BillingQuantity) = 0
                     then cast(0.00 as abap.dec(23,2))
   //
                     else cast(BillingDocItem.BillingQuantity as abap.dec(23,2))
                 end

         end                                                                                    as BillingQuantity,


         BillingDocItem.Plant,
         BillingDocItem.ProfitCenter,
         BillingDocItem.Batch,
          //BillingDoc.CancelledBillingDocument is not initial
    case
     when 
     BillingDoc.BillingDocumentType = 'G2'
    or BillingDoc.BillingDocumentType = 'CBRE'
    or BillingDoc.BillingDocumentType = 'S1'
         then   cast( srate.ConditionRateValue * -1 as abap.dec(23,2) ) 
         else cast( srate.ConditionRateValue as abap.dec(23,2) )    end       as Rate,
         SalesDocitem.TransactionCurrency                                                       as amtuom,

//         case
//         when BillingDoc.CancelledBillingDocument  is not initial or BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' or BillingDoc.BillingDocumentType <> 'S2'
//         then cast( ( srate.ConditionAmount * ( -1 ) ) as abap.dec(23,2))
//         
//         else cast( srate.ConditionAmount as abap.dec(23,2))     end                            as taxablevalue,

case
  when //BillingDoc.CancelledBillingDocument is not initial
     BillingDoc.BillingDocumentType = 'G2'
    or BillingDoc.BillingDocumentType = 'CBRE'
    or BillingDoc.BillingDocumentType = 'S1'
  then cast( srate.ConditionAmount * -1 as abap.dec(23,2) )
 
//  when BillingDoc.BillingDocumentType = 'S2'
//  then cast( srate.ConditionAmount as abap.dec(23,2) )
 
  else cast( srate.ConditionAmount  as abap.dec(23,2) )
end as taxablevalue,

         
         cast( cast(  Igst.ConditionRateValue  as abap.dec( 15,2 ) )   as abap.char(30))  as      IGSTRATE,

         //         case
         //          when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         //         then
         //         cast( ( (cast ( Igst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec(23,2))
         //         when SalesDocitem.OrderQuantity is not initial
         //         then
         //         cast( (cast ( Igst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) as abap.dec(23,2))
         //         else 0 end                                                                             as IGSTvalue,
         case
         when Igst.ConditionAmount is not initial and (  BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' or BillingDoc.BillingDocumentType = 'S1'  )                                  // ++ 13.08.25
         then
         cast ( ( Igst.ConditionAmount * -( 1 ) ) as abap.dec(23,2))
         when Igst.ConditionAmount is not initial then
         cast( Igst.ConditionAmount   as abap.dec(23,2) )
         else null
         end                                                                                    as IGSTvalue,
         cast( cast(  cgst.ConditionRateValue    as abap.dec( 15,2 )     )    as abap.char(30)) as CGSTRATE,

         //         @DefaultAggregation: #SUM
         //         case
         //         when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         //         then
         //         cast( ( ( cast ( cgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec( 23,2 ) )
         //         when SalesDocitem.OrderQuantity is not initial
         //         then
         //         cast(  ( cast ( cgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) )  as abap.dec( 23,2 ) )
         //         else 0 end                                                                             as CGSTvalue,
         case
         when cgst.ConditionAmount is not initial and ( BillingDoc.BillingDocumentType = 'G2' or  BillingDoc.BillingDocumentType = 'CBRE'or BillingDoc.BillingDocumentType = 'S1'  )                                   // ++ 13.08.25
         then
         cast ( ( cgst.ConditionAmount * -( 1 ) ) as abap.dec(23,2))
         when cgst.ConditionAmount is not initial then
         cast( cgst.ConditionAmount   as abap.dec(23,2) )
         else null
         end                                                                                    as cGSTvalue,


         cast( cast( sgst.ConditionRateValue       as abap.dec( 15,2 )  )  as abap.char(30) )   as SGSTRATE,


         //         case
         //         when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         //         then
         //         cast( ( ( cast ( sgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( - 1 ) ) as abap.dec( 23,2 ) )
         //         when SalesDocitem.OrderQuantity is not initial then
         //         cast(  ( cast ( sgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) )  as abap.dec( 23,2 ) )
         //         else 0 end                                                                             as SGSTvalue,

         case
         when sgst.ConditionAmount is not initial and ( BillingDoc.BillingDocumentType = 'G2' or   BillingDoc.BillingDocumentType = 'CBRE'or BillingDoc.BillingDocumentType = 'S1' )                                      // ++ 13.08.25
         then
         cast ( ( sgst.ConditionAmount * -( 1 ) ) as abap.dec(23,2))
         when sgst.ConditionAmount is not initial then
         cast( sgst.ConditionAmount   as abap.dec(23,2) )
         else null
         end                                                                                    as sGSTvalue,


         cast( cast(  utgst.ConditionRateValue  as abap.dec( 15,2 ) )   as abap.char(30) )      as UTGSTRATE,

         //         case
         //          when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         //         then
         //         cast( ( (cast ( utgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec(23,2))
         //         when SalesDocitem.OrderQuantity is not initial
         //         then
         //         cast( (cast ( utgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) as abap.dec(23,2))
         //         else 0 end                                                                             as UTGSTvalue,
         case
         when utgst.ConditionAmount is not initial and ( BillingDoc.CancelledBillingDocument  is not initial  or BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' )                                     // ++ 13.08.25
         then
         cast ( ( utgst.ConditionAmount * -( 1 ) ) as abap.dec(23,2))
         when utgst.ConditionAmount is not initial then
         cast( utgst.ConditionAmount   as abap.dec(23,2) )
         else null
         end                                                                                    as utGSTvalue,



         cast( cast ( tcs.ConditionRateValue    as abap.dec( 15,2 )     )  as abap.char(30) )   as tcsrate,

         case
         when  BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE'or BillingDoc.BillingDocumentType = 'S1' 
         then
         cast ( ( tcs.ConditionAmount * ( -1 ) ) as abap.dec( 23,2 ) )
         else  cast(  tcs.ConditionAmount  as abap.dec( 23,2 ) )  end                           as Tcsvalue,

         case
          when ( BillingDoc.CancelledBillingDocument  is not initial or BillingDoc.BillingDocumentType = 'G2' or BillingDoc.BillingDocumentType = 'CBRE' ) and SalesDocitem.OrderQuantity is not initial then
         cast( ( ( cast ( compcess.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec(23,2))
         when SalesDocitem.OrderQuantity is not initial
         then
         cast( ( cast ( compcess.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) as abap.dec(23,2))
         else 0 end                                                                             as compcessamt,

         case
         when BillingDoc.BillingDocumentType = 'S1'
         then canc.Transportername
         else
         einv.transportername end                                                               as transportername,

         case
          when BillingDoc.BillingDocumentType = 'S1'
          then canc.Transportergstin
          else
         einv.transportergstin end                                                              as transportergstin,

         case
          when BillingDoc.BillingDocumentType = 'S1'
          then canc.Vehiclenumber
          else
         einv.vehiclenumber end                                                                 as vehiclenumber,

         case
          when BillingDoc.BillingDocumentType = 'S1'
          then canc.Irn
          else
         einv.irn end                                                                           as irn,

         case
          when BillingDoc.BillingDocumentType = 'S1'
          then canc.Eway
          else
         einv.eway end                                                                          as eway,

         case
          when BillingDoc.BillingDocumentType = 'S1'
          then canc.Ewaycanceldate
          else
         einv.ewaycanceldate end                                                                as ewaycanceldate,
         //         einv.transportergstin,
         //         einv.vehiclenumber,
         //         einv.irn,
         //         einv.eway,
         //         einv.ewaycanceldate,
         //  gate.Lrrrdate,                 // -- 13.08.25 by sp
         //  gate.Lrrrno                    // -- 13.08.25 by sp
         case
         when BillingDoc.BillingDocumentType = 'S1'
         then canc.Transporterdocumentdate
         else
         einv.transporterdocumentdate end                                                       as Lrrrdate,

         case
         when BillingDoc.BillingDocumentType = 'S1'
         then canc.Transporterdocumentnumber
         else
         einv.transporterdocumentnumber end                                                     as Lrrrno,


         //         einv.transporterdocumentdate                                                           as Lrrrdate, // ++ 13.08.25 by sp
         //         einv.transporterdocumentnumber                                                         as Lrrrno, // ++ 13.08.25 by sp
         case when roundoff.ConditionAmount is not initial                                         // ++  new column added 14.08.25
         then
         cast ( roundoff.ConditionAmount  as abap.dec(23,2))
         else null
         end                                                                                    as RoundingOff,
         gatepassnumber.YY1_GatePassNumber_DLH                                                  as gatepassnumber, // new column added on 18.08.25
         BDC.BillingDocumentIsCancelled,
         BDC.BillingDocumentType,
         BDC.CancelledBillingDocument,
         BDC.ShippingCondition,
         BDC.SDDocumentReason,
         case 
         when BDC.SDDocumentReason = '001' then 'Sales Call'
         when BDC.SDDocumentReason = '002' then 'Trade Fair Sales Activity'
         when BDC.SDDocumentReason = '003' then 'Television Commercial'
         when BDC.SDDocumentReason = '004' then 'Customer Recommendation'
         when BDC.SDDocumentReason = '005' then 'Newspaper Advertisement'
         when BDC.SDDocumentReason = '006' then 'Excellent Price'
         when BDC.SDDocumentReason = '007' then 'Fast Delivery'
         when BDC.SDDocumentReason = '008' then 'Good Service'
         when BDC.SDDocumentReason = '009' then 'Standard Return'
         when BDC.SDDocumentReason = '101' then 'Poor Quality'
         when BDC.SDDocumentReason = '102' then 'Damaged in Transit'
         when BDC.SDDocumentReason = '105' then 'Free of Charge Sample'
         when BDC.SDDocumentReason = '200' then 'Price Difference: Price was too low'
         when BDC.SDDocumentReason = '210' then 'Fi-Price Difference'
         end                                                                                    as Orderreason,
         BillingDoc.OverallBillingStatus,
         case
         when BillingDoc.OverallBillingStatus =' ' then 'Not Relevant'
         when BillingDoc.OverallBillingStatus ='A' then 'Completed'
         when BillingDoc.OverallBillingStatus ='B' then 'To Be Posted'
         when BillingDoc.OverallBillingStatus ='C' then 'Canceled'
         when BillingDoc.OverallBillingStatus ='D' then 'Incomplete'
         end                                                                                    as BillingStatus,

         canc1.Irncanceldate                                                                     as EINVCancellationDate


}
