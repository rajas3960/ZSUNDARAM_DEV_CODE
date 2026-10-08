@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mainrtenance Order Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMAINTENANCEODR_CV provider contract transactional_query
as projection on ZMAINTENANCEODR_RE
{
    key MaintenanceOrder,
    key ReservationNo,
    key ReservationItem,
    key ReservationType,
    MaintenanceOrderOperation,
    Material,
    Materialdes,
    PRNo,
    PRmaterialDes,
    OrderType,
    Notification,
    Priority,
    Finalduedt,
    TechnicalObject,
    Technicalobjdes,
    Basicstarttime,
    BasicStartdt,
    Basicfinishtime,
    Basicfinishdt,
    Mainworkcenter,
    MainWorkCenterPlant,
    Companycode,
    Costcenter,
    CostCenterDescription,
    createdby,
    Currency,
    Functionallctn,
    Unitofmeasurement,
    @Semantics.quantity.unitOfMeasure: 'Unitofmeasurement'
    Quantitywthdrn,
    @Semantics.amount.currencyCode: 'Currency'
    priceofcompcurrency,
    Costvalue
}
