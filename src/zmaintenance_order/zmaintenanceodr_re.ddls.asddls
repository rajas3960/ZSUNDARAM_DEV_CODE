@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mainrtenance Order Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMAINTENANCEODR_RE 
as select from I_MaintenanceOrderBasic as mo
left outer join I_MaintOrderComponentDEX  as mocd  on mocd.MaintenanceOrder = mo.MaintenanceOrder
 left outer join I_ProductDescription      as pd   on pd.Product = mocd.Material
                                                   and pd.Language =$session.system_language                                             

left outer join I_PurchaseRequisitionItemAPI01 as pri on pri.PurchaseRequisition = mocd.PurchaseRequisition
                                                    and pri.PurchaseRequisitionItem = mocd.PurchaseRequisitionItem
  left outer join I_OrderTypeText as OTT  on OTT.OrderType = mocd.MaintenanceOrderType
                                         and OTT.Language = $session.system_language    
 left outer join I_BusinessUserBasic as bu on bu.UserID = mo.CreatedByUser    
 left outer join ZORDER_COST as cost on cost.Reservation = mocd.Reservation
                                    and cost.ReservationItem = mocd.ReservationItem
                                    and cost.MaintenanceOrder = mocd.MaintenanceOrder
                                    and cost.MaintenanceOrderOperation = mocd.MaintenanceOrderOperation
left outer join I_CostCenterText as ct on ct.CostCenter = mocd.ResponsibleCostCenter
                                      and ct.Language = $session.system_language

left outer join I_EquipmentText as et on et.Equipment = mocd.Equipment
                                     and et.Language = $session.system_language                                                                            
{
    key mo.MaintenanceOrder,
    key mocd.Reservation    as ReservationNo,
    key mocd.ReservationItem,
    key mocd.ReservationType,
        mocd.MaintenanceOrderOperation,
        mocd.Material         as Material,
        pd.ProductDescription as Materialdes,
        mocd.PurchaseRequisition as PRNo,
        pri.PurchaseRequisitionItemText  as PRmaterialDes,
       concat(concat(mocd.MaintenanceOrderType, ' - '),OTT.OrderTypeName) as OrderType,
        mo.MaintenanceNotification as  Notification,
        mo.MaintPriority           as Priority,
        mocd.LatestAcceptableCompletionDate as Finalduedt,
        mocd.Equipment   as  TechnicalObject,
        et.EquipmentName as  Technicalobjdes,
        mo.MaintOrdBasicStartTime as  Basicstarttime,
        mo.MaintOrdBasicStartDate  as BasicStartdt,
        mo.MaintOrdBasicEndTime   as Basicfinishtime,
        mo.MaintOrdBasicEndDate   as Basicfinishdt,
        mo.MainWorkCenter         as Mainworkcenter,
        mo.MainWorkCenterPlant,
        mo.CompanyCode            as Companycode,
        mocd.ResponsibleCostCenter as Costcenter,
        ct.CostCenterDescription,
       // mo.CreatedByUser           as createdby,
        bu.PersonFullName          as createdby,
        mo.Currency,
        mocd.FunctionalLocation    as Functionallctn,
        mocd.BaseUnit              as Unitofmeasurement,
        @Semantics.quantity.unitOfMeasure: 'Unitofmeasurement'
        mocd.QuantityWithdrawnInBaseUnit  as Quantitywthdrn,
        @Semantics.amount.currencyCode: 'Currency'
        mocd.MaintOrderOpComponentPrice  as priceofcompcurrency,
        cost.DebitAmt as Costvalue
         
        
        
}
