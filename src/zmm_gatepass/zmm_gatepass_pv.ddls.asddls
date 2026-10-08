@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZMM_GATEPASS_PV 
provider contract transactional_query
as projection on ZMM_GATEPASS_RE
{
    key Gatepassno,
    key gatepassitem,
    Status,
    Grstatus,
    Grnno,
    Movementtype,
    Materialprocess,
    Companycode,
    Supplierno,
    Supplierdesc,
    Customerno,
    Customerdesc,
    Challanno,
    Challandate,
    Lrrrno,
    Lrrrdate,
    Tpno,
     @Semantics.amount.currencyCode:       'Challanunit'
    Challanvalue,
    Challanunit,
    ChallanQTY,
    UOM,
    Waybillno,
    purchaseorder,
    SalesOrder,
    Createdby,
    Createdbyname,
    Invoiceno,
    Drivername,
    Wuom,
    Weighbentrydate,
    Weighbentrytime,
    Weighbexitdate,
    Taxinvoice,
    Weighbexittime,
    Deliverydocument,
    @Semantics.quantity.unitOfMeasure:    'UOM'
    Grossqty,
    @Semantics.quantity.unitOfMeasure:    'UOM'
    Tareqty,
    @Semantics.quantity.unitOfMeasure:    'UOM'
    Qtyactual,
    Invoicedate,
    @Semantics.amount.currencyCode:       'Challanunit'
    Invoicevalue,
    Entrydate,
    Vehicleno,
    Entrytime,
    Trasporterno,
    Exitdate,
    Transportername,
    Transportergst,
    Exittime,
    Packingwt,
    Source,
    Destination,
    Remarks,
    @Semantics.quantity.unitOfMeasure:    'UOM'
    Pendqty
}
