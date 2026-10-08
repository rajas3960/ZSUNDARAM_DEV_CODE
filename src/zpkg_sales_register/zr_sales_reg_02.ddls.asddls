@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales register'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_SALES_REG_02
  as select distinct from I_BillingDocument              as BillingDoc
  inner join zdt_user_auth as user on BillingDoc.CompanyCode = user.companycode
                                   and user.cbuser = $session.user
    inner join            I_BillingDocumentItem          as BillingDocItem   on BillingDoc.BillingDocument = BillingDocItem.BillingDocument
    left outer join       I_Customer                     as SoldToCustomer   on BillingDoc.SoldToParty = SoldToCustomer.Customer
    left outer join       I_Customer                     as ShipToCustomer   on BillingDocItem.ShipToParty = ShipToCustomer.Customer
    left outer join       I_Customer                     as BillToCustomer   on BillingDocItem.BillToParty = BillToCustomer.Customer
    left outer join       I_Customer                     as PayerCustomer    on BillingDoc.PayerParty = PayerCustomer.Customer
    left outer join       I_SalesDocument                as SalesDoc         on BillingDocItem.SalesDocument = SalesDoc.SalesDocument
    left outer join       I_SalesDocumentItem            as SalesDocitem     on  BillingDocItem.SalesDocument     = SalesDocitem.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem = SalesDocitem.SalesDocumentItem
    left outer join       I_SalesDocItemPricingElement   as agentcommisition on  BillingDocItem.SalesDocument     = agentcommisition.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem = agentcommisition.SalesDocumentItem
                                                                             and agentcommisition.ConditionType   = 'ZBRO'
    left outer join       I_SalesDocItemPricingElement   as cgst             on  BillingDocItem.SalesDocument     = cgst.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem = cgst.SalesDocumentItem
                                                                             and cgst.ConditionType               = 'JOCG'
    left outer join       I_SalesDocItemPricingElement   as utgst            on  BillingDocItem.SalesDocument     = utgst.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem = utgst.SalesDocumentItem
                                                                             and cgst.ConditionType               = 'JOUG'
    left outer join       I_SalesDocItemPricingElement   as sgst             on  BillingDocItem.SalesDocument     = sgst.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem = sgst.SalesDocumentItem
                                                                             and sgst.ConditionType               = 'JOSG'
    left outer join       I_SalesDocItemPricingElement   as Igst             on  BillingDocItem.SalesDocument     = Igst.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem = Igst.SalesDocumentItem
                                                                             and Igst.ConditionType               = 'JOIG'
  //    left outer join       I_SalesDocItemPricingElement   as freight          on  BillingDocItem.SalesDocument     = freight.SalesDocument
  //                                                                             and BillingDocItem.SalesDocumentItem = freight.SalesDocumentItem
  //                                                                             and freight.ConditionType            = 'ZFRE'
    left outer join       I_BillingDocItemPrcgElmntBasic as tcs              on  BillingDocItem.BillingDocument     =  tcs.BillingDocument
                                                                             and BillingDocItem.BillingDocumentItem =  tcs.BillingDocumentItem
                                                                             and (
                                                                                tcs.ConditionType                   =  'JTC1'
                                                                                or tcs.ConditionType                =  'JTC2'
                                                                                or tcs.ConditionType                =  'JTCT'
                                                                              )
                                                                             and tcs.ConditionAmount                <> 0.00
    left outer join       I_SalesDocItemPricingElement   as compcess         on  BillingDocItem.SalesDocument     =  compcess.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem =  compcess.SalesDocumentItem
                                                                             and compcess.ConditionType           =  'ZCES'
                                                                             and compcess.ConditionAmount         <> 0.00
    left outer join       I_SalesDocItemPricingElement   as srate            on  BillingDocItem.SalesDocument     =  srate.SalesDocument
                                                                             and BillingDocItem.SalesDocumentItem =  srate.SalesDocumentItem
                                                                             and srate.ConditionType              =  'ZPR0'
                                                                             and srate.ConditionAmount            <> 0.00

    left outer join       I_BillingDocItemPrcgElmntBasic as inv              on  inv.BillingDocument     = BillingDoc.BillingDocument
                                                                             and inv.BillingDocumentItem = BillingDocItem.BillingDocumentItem
                                                                             and inv.ConditionType       = 'ZACC'
    left outer join       I_Plant                        as Plant            on BillingDocItem.Plant = Plant.Plant
    left outer join       I_Product                      as Product          on BillingDocItem.Product = Product.Product
    left outer join       I_IN_ElectronicDocTransptRegn  as EWayBill         on BillingDoc.BillingDocument = EWayBill.ElectronicDocSourceKey
    left outer join       I_DeliveryDocument             as deliverydoc      on  deliverydoc.DeliveryDocument               = BillingDocItem.ReferenceSDDocument
                                                                             and BillingDocItem.ReferenceSDDocumentCategory = 'J'
    left outer join       I_DeliveryDocumentItem         as deliverydocitem  on  deliverydocitem.DeliveryDocument           = BillingDocItem.ReferenceSDDocument
                                                                             and deliverydocitem.DeliveryDocumentItem       = BillingDocItem.ReferenceSDDocumentItem
                                                                             and BillingDocItem.ReferenceSDDocumentCategory = 'J'
    left outer join       I_ProductPlantBasic            as prdplnt          on  prdplnt.Product = BillingDocItem.Material
                                                                             and prdplnt.Plant   = BillingDocItem.Plant
    left outer join       I_JournalEntry                 as je               on  je.AccountingDocument = BillingDoc.AccountingDocument
                                                                             and je.FiscalYear         = BillingDoc.FiscalYear
    left outer join       I_BillingDocumentPartner       as agent            on  agent.BillingDocument = BillingDoc.BillingDocument
                                                                             and agent.PartnerFunction = 'ZB'
    left outer join       I_Customer                     as agentname        on agentname.Customer = agent.Customer

    left outer join       zdt_einveway                   as einv             on einv.vbeln = BillingDoc.BillingDocument
    left outer join       ZV_GATEHEAD                    as gate             on gate.Gatepassno = deliverydoc.YY1_GatePassNumber_DLH


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
         when BillingDoc.BillingDocumentType = 'S1' then
         'Cancelled Invoice'
          when BillingDoc.BillingDocumentType = 'F8' then
         'Proforma Invoice'
         when BillingDoc.BillingDocumentType = 'S2' then
         'Cancelled Credit Note' end                                                            as billtype,
         BillingDoc.BillingDocumentDate,
         BillingDocItem.SalesDocument,
         BillingDocItem.SalesDocumentItem                                                       as OrderItem,
         SalesDoc.SalesDocumentDate,
         BillingDocItem.ReferenceSDDocument                                                     as DeliveryNo,
         BillingDocItem.ReferenceSDDocumentItem                                                 as DeliveryItem,
         deliverydoc.ActualGoodsMovementDate                                                    as deliverydate,
         SalesDocitem.ReferenceSDDocument                                                       as salescontract,
         BillingDoc.SalesOrganization,
         BillingDoc.DistributionChannel,
         BillingDoc.Division,
         BillingDoc.SoldToParty,
         SoldToCustomer.BPCustomerFullName                                                      as SoldToPartyName,
         SoldToCustomer.TaxNumber3                                                              as soldtogstin,
         BillingDocItem.ShipToParty,
         ShipToCustomer.BPCustomerFullName                                                      as ShipToPartyName,
         ShipToCustomer.TaxNumber3                                                              as ShipToGSTIN,
         agent.Customer                                                                         as Broker,
         agentname.CustomerName                                                                 as Brokername,
         prdplnt.ConsumptionTaxCtrlCode                                                         as HSNCode,
         Product.Product,
         Product.ProductType,
         BillingDocItem.BillingDocumentItemText,
         BillingDocItem.BillingQuantityUnit                                                     as uom,
         @Semantics.quantity.unitOfMeasure: 'UOM'
         case
         when BillingDoc.CancelledBillingDocument  is not initial
         then cast( ( BillingDocItem.BillingQuantity * ( -1 ) ) as abap.dec(23,2))
       // when BillingDoc.BillingDocumentType = 'S2'  and BillingDoc.BillingDocumentType = 'L2' 
       // then cast( ( BillingDocItem.BillingQuantity * ( -1 ) ) as abap.dec(23,2))
         else cast( BillingDocItem.BillingQuantity as abap.dec(23,2))     end                            as BillingQuantity,
         
         BillingDocItem.Plant,
         BillingDocItem.ProfitCenter,
         BillingDocItem.Batch,
         cast(cast( srate.ConditionRateValue as abap.dec(23,2))  as abap.char(30) )             as Rate,
         SalesDocitem.TransactionCurrency                                                       as amtuom,

         case
         when BillingDoc.CancelledBillingDocument  is not initial 
         then cast( ( srate.ConditionAmount * ( -1 ) ) as abap.dec(23,2))
         //when BillingDoc.BillingDocumentType = 'S2' and BillingDoc.BillingDocumentType is not initial 
        // then cast( ( srate.ConditionAmount * ( -1 ) ) as abap.dec(23,2))
         else cast( srate.ConditionAmount as abap.dec(23,2))     end                            as taxablevalue,

         cast( cast(  Igst.ConditionRateValue  as abap.dec( 15,2 ) )   as abap.char(30) )       as IGSTRATE,

         case
          when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         then
         cast( ( (cast ( Igst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec(23,2))
         when SalesDocitem.OrderQuantity is not initial
         then
         cast( (cast ( Igst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) as abap.dec(23,2))
         else 0 end                                                                             as IGSTvalue,

         cast( cast(  cgst.ConditionRateValue    as abap.dec( 15,2 )     )    as abap.char(30)) as CGSTRATE,

         @DefaultAggregation: #SUM
         case
         when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         then
         cast( ( ( cast ( cgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec( 23,2 ) )
         when SalesDocitem.OrderQuantity is not initial
         then
         cast(  ( cast ( cgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) )  as abap.dec( 23,2 ) )
         else 0 end                                                                             as CGSTvalue,

         cast( cast( sgst.ConditionRateValue       as abap.dec( 15,2 )  )  as abap.char(30) )   as SGSTRATE,


         case
         when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         then
         cast( ( ( cast ( sgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( - 1 ) ) as abap.dec( 23,2 ) )
         when SalesDocitem.OrderQuantity is not initial then
         cast(  ( cast ( sgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) )  as abap.dec( 23,2 ) )
         else 0 end                                                                             as SGSTvalue,

         cast( cast(  utgst.ConditionRateValue  as abap.dec( 15,2 ) )   as abap.char(30) )      as UTGSTRATE,

         case
          when SalesDocitem.OrderQuantity is not initial and BillingDoc.CancelledBillingDocument  is not initial
         then
         cast( ( (cast ( utgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec(23,2))
         when SalesDocitem.OrderQuantity is not initial
         then
         cast( (cast ( utgst.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) as abap.dec(23,2))
         else 0 end                                                                             as UTGSTvalue,


         cast( cast ( tcs.ConditionRateValue    as abap.dec( 15,2 )     )  as abap.char(30) )   as tcsrate,

         case
         when BillingDoc.CancelledBillingDocument  is not initial then
         cast ( ( tcs.ConditionAmount * ( -1 ) ) as abap.dec( 23,2 ) )
         else  cast(  tcs.ConditionAmount  as abap.dec( 23,2 ) )  end                           as Tcsvalue,

         case
          when BillingDoc.CancelledBillingDocument  is not initial and SalesDocitem.OrderQuantity is not initial then
         cast( ( ( cast ( compcess.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) * ( -1 ) ) as abap.dec(23,2))
         when SalesDocitem.OrderQuantity is not initial
         then
         cast( ( cast ( compcess.ConditionAmount  as abap.dec( 23,2 ) ) / cast( SalesDocitem.OrderQuantity as abap.dec( 23 , 3 ) ) ) * cast ( BillingDocItem.BillingQuantity as abap.dec( 23 , 3 ) ) as abap.dec(23,2))
         else 0 end                                                                             as compcessamt

//         einv.transportername,
//         einv.transportergstin,
//         einv.vehiclenumber,
//         einv.irn,
//         einv.eway,
//         einv.ewaycanceldate,
//         gate.Lrrrdate,
//         gate.Lrrrno





}
