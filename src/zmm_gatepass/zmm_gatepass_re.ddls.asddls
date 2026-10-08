@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT VIEW Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_GATEPASS_RE
  as select from    ZI_GATEHEAD   as HEADER

    left outer join ZI_PO_DETAILS as PO   on PO.Id = HEADER.Id

    left outer join ZI_GATEITEM  as ITEM on  ITEM.Id  = HEADER.Id
     
{
  key HEADER.gatepassno       as Gatepassno,
  key ITEM.gateitem           as gatepassitem,
      HEADER.Status           as Status,
      HEADER.grstatus         as Grstatus,
      HEADER.grstatno            as Grnno,
      HEADER.Movementtype     as Movementtype,
      HEADER.Materialprocess  as Materialprocess,
      HEADER.Companycode      as Companycode,
      HEADER.Supplierno       as Supplierno,
      HEADER.Supplierdesc     as Supplierdesc,
      HEADER.customerno       as Customerno,
      HEADER.customerdesc     as Customerdesc,
      HEADER.challanno        as Challanno,
      HEADER.challandate      as Challandate,
      HEADER.Lrrrno           as Lrrrno,
      HEADER.Lrrrdate         as Lrrrdate,
      HEADER.tpno             as Tpno,

      @Semantics.amount.currencyCode:       'Challanunit'
      HEADER.challanvalue     as Challanvalue,
      HEADER.challanunit      as Challanunit,
      HEADER.challanwt        as ChallanQTY,
      ITEM.Uom                as UOM,
      HEADER.Waybillno        as Waybillno,
      PO.Purchaseorder        as purchaseorder,
      
      PO.Salesorder           as SalesOrder,
      HEADER.createdby        as Createdby,
      HEADER.createdbyname    as Createdbyname,
      HEADER.Invoiceno        as Invoiceno,
      HEADER.drivername       as Drivername,
      HEADER.wuom             as Wuom,
      HEADER.weighbentrydate  as Weighbentrydate,
      HEADER.weighbentrytime  as Weighbentrytime,
      HEADER.weighbexitdate   as Weighbexitdate,
      HEADER.taxinvoice       as Taxinvoice,
      HEADER.weighbexittime   as Weighbexittime,
      HEADER.deliverydocument as Deliverydocument,

      @Semantics.quantity.unitOfMeasure:    'UOM'
      ITEM.grossqty         as Grossqty,
      @Semantics.quantity.unitOfMeasure:    'UOM'
      ITEM.tareqty          as Tareqty,
      @Semantics.quantity.unitOfMeasure:    'UOM'
      ITEM.Qtyactual        as Qtyactual,
      HEADER.Invoicedate      as Invoicedate,

      @Semantics.amount.currencyCode:       'Challanunit'
      HEADER.invoicevalue     as Invoicevalue,
      HEADER.Entrydate        as Entrydate,
      HEADER.Vehicleno        as Vehicleno,
      HEADER.Entrytime        as Entrytime,
      HEADER.Trasporterno     as Trasporterno,
      HEADER.Exitdate         as Exitdate,
      HEADER.Transportername  as Transportername,
      HEADER.transportergst   as Transportergst,

      HEADER.Exittime         as Exittime,

      HEADER.packingwt        as Packingwt,

      HEADER.source           as Source,

      HEADER.destination      as Destination,
      HEADER.remarks          as Remarks,

      @Semantics.quantity.unitOfMeasure:    'UOM'
      ITEM.pendqty         as Pendqty


//      HEADER.tsetout          as Tsetout,
//      HEADER.tprint           as Tprint,
//      HEADER.tgate            as Tgate,
//
//      HEADER.createdon        as Createdon,
//      HEADER.createdat        as Createdat,
//      HEADER.bgr              as Bgr,
//      HEADER.bcancel          as Bcancel,
//      HEADER.cancel           as Cancel,
//      HEADER.genitem          as Genitem,
//      HEADER.delcreated       as Delcreated,
//      HEADER.bdel             as Bdel, 
//      HEADER.pgi              as Pgi,
//      HEADER.pgistat          as Pgistat,
//      HEADER.updtext          as Updtext,
//      HEADER.textupdated      as Textupdated,
//      HEADER.crtinv           as Crtinv,
//      HEADER.getinv           as Getinv,
//      HEADER.poraw            as Poraw,
//      HEADER.attachment       as Attachment,
//      HEADER.mimetype         as Mimetype,
//      HEADER.filename         as Filename,
//      HEADER.id               as id,
//      PO.supplier             as Supplier,
//      PO.item                 as Item
}
