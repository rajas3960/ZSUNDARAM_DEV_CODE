@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Tax Invoice Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TAXINVOICE_HEADER
  as select from    ZR_SUPPLIER1           as a
    left outer join ZR_PO_STO              as k on k.BillingDocument = a.BillingDocument
    left outer join ZR_RECEIVER            as c on c.BillingDocument = a.BillingDocument
    left outer join ZR_CONSIGNEE           as b on b.BillingDocument = a.BillingDocument
    left outer join ZR_PAYER               as l on l.BillingDocument = a.BillingDocument
    left outer join zi_address             as pyr on pyr.billdoc         = a.BillingDocument
    left outer join ZR_STORECEIVER         as i on i.BillingDocument = a.BillingDocument
    left outer join ZR_TRANSPORTER         as d on d.BillingDocument = a.BillingDocument
    left outer join ZI_BankDetails          as e on e.CompanyCode = a.CompanyCode
    left outer join ZI_DataOfBank          as m on  m.Plant    = ''
                                                and m.Customer = l.Customer
    left outer join ZI_PLANT_DETAILS_FINAL as g on g.BillingDocument = a.BillingDocument
    left outer join ZI_DetailsForStateCode as h on h.StateName = g.StateCode
    left outer join ZI_GstIsoDetails       as j on j.PlantNo = g.PlantNo
    left outer join ZR_SALES_ORDER         as f on f.BillingDocument = a.BillingDocument
    left outer join zdt_files              as n on n.serialinvoiceno = a.BillingDocument
    left outer join I_BillingDocument           as o on o.BillingDocument = a.BillingDocument
    left outer join ZI_RegisteredOfficeDet      as r on r.CompanyCode = a.CompanyCode
    left outer join zsd_billing_txt             as t on t.billingdocument = a.BillingDocument 
                                                   and t.textid = 'TX05'
  composition [0..*] of ZI_TAXINVOICE_ITEM  as _Item
  composition [0..*] of ZI_TAXINVOICE_ITEM2 as _Item2

{
  key a.BillingDocument          as SerialInvoiceNo,
      case
      when a.DocumentType = 'JSTO' // or a.DocumentType = 'JSN' 
      then k.PurchaseOrder
//      else a.ordernumber end     as OrderNumber,
       else o.PurchaseOrderByCustomer end as OrderNumber,

      a.DocumentType             as DocumentType,

      case
      when a.IncotermsClassification = 'EXW'
      then
      a.IncotermsClassificationName
      else
      ''
      end                        as Deliveryterms,
 
 ////     a.DESCOFITEMS,
      f.SalesOrder               as SalesOrder,
      b.Customer                 as Customer,
      b.CustomerName,
      e.CompanyCode              as PlantBank,
      e.BankAddress              as BankAddress,
      e.AccountNumber            as AccountNumber,
      e.BankName                 as BankName,
      e.IfscCode                 as IfscCode,
//      case
//      when m.Customer is not initial
//      then m.Plant
//      else e.CompanyCode end     as PlantBank,
//      case
//      when m.Customer is not initial
//      then m.BankName
//      else e.BankName end        as BankName,
//      case
//      when m.Customer is not initial
//      then m.BankAddress
//      else e.BankAddress end     as BankAddress,
//      case
//      when m.Customer is not initial
//      then m.AccountNumber
//      else e.AccountNumber end   as AccountNumber,
////      case
////      when m.Customer is not initial
////      then m.AccountName
////      else e.AccountName end     as AccountName,
//      case
//      when m.Customer is not initial
//      then m.IfscCode
//      else e.IfscCode end        as IfscCode,
      case
      when a.DocumentType = 'JSTO'
      then i.BusinessPartnerName1
      else
      c.BusinessPartnerName1 end as CBusinessName,
      case
      when a.DocumentType = 'JSTO'
      then i.BPAddrStreetName
      else
      c.BPAddrStreetName end     as CAddress,
      case
      when a.DocumentType = 'JSTO'
      then i.CityName
      else
      c.CityName     end         as CCityName,
      case
      when a.DocumentType = 'JSTO'
      then i.Region
      else
      c.RegionName    end            as CStateName,
      case
      when a.DocumentType = 'JSTO'
      then i.StateCode
      else
      c.statecode    end         as CStateCode,
      case
      when a.DocumentType = 'JSTO'
      then i.TaxNumber3
      else
      c.TaxNumber3     end       as CGSTIN,
      case
      when a.DocumentType = 'JSTO'
      then i.FullAddress
      else
      c.FullAddress    end       as CFullAddress,
      b.BusinessPartnerName1     as RBusinessName,
      b.BPAddrStreetName         as RAddress,
      b.CityName                 as RCityName,
      b.RegionName               as RStateName,
      b.StateCode                as RStateCode,
      b.TaxNumber3               as RGSTIN,
      b.FullAddress              as RFullAddress,
      case
      when a.DocumentType = 'JSTO'
      then k.PurchaseOrderDate
      else a.orderdate end       as OrderDate,
      a.paymentterms             as PaymentTerms,
    //  //a.lcnumber                 as LCNumber,
    // // a.lcdate                   as LCDate,
      a.dateofinvoice            as DateOfInvoice,
      a.timeofinvoice            as TimeOfInvoice,
      a.DateofRemoval            as DateOfRemoval,
      a.TimeofRemoval            as TimeOfRemoval,
      a.irnnumber                as IRNNumber,
      a.irndate                  as IRNDate,
      a.bitmapcode               as BitmapCode,
     //// d.name                     as TransporterName,
    ////  d.lrnumber                 as LRNumber,
    ////  d.lrdate                   as LRDate,
    ////  d.vehiclenumber            as VehicleNumber,
//      case
//      when a.DocumentType = 'JSTO'
//      then 0
 //     else
//      case
//      when d.distributionchannel = '20'
//      then cast( d.exchangerate * 100 as abap.dec(13, 5) )
//      else d.exchangerate end as ExchangedRate,
      d.exchangerate             as ExchangedRate,
  ////    d.containernumber          as ContainerNumber,
   ////   d.YY1_unitpackage_DLH,
 //     case
    ////  when a.DocumentType = 'F2'
    ////  then
    ////  d.Trasname
   ////   else
   ////   d.dispatchedthrough
   ////   end                        as DispatchedThrough,
 ////     a.remarks                  as remarks,
 
      pyr.Payerid,
      pyr.Pyraddrid,
      pyr.payertxt,
      pyr.BilltoGSTIN,
      pyr.BilltoCountry,
      pyr.BilltoStreetName,
      pyr.BilltoRegion,
      pyr.Billtopostalcode,
      pyr.payergst,
 
      a.CompanyCode              as CompanyCode,
      g.PlantNo                  as PlantNo,
      g.PlantName                as PlantName,
      j.PlantAddress             as PlantAddress,
      g.State                    as StateOfSupply,
      g.StateCode                as StateCode,
      j.GstNo                    as GSTNo,
      j.IsoNo                    as ISONo,
      ''                         as tprint,
      ''                         as amountinwords,
      @Semantics.largeObject: { mimeType: 'Mimetype', fileName: 'Filename', contentDispositionPreference: #INLINE }
      n.attachment               as Attachment,
      @Semantics.mimeType: true
      n.mimetype                 as Mimetype,
      n.filename                 as Filename,
      a.PurchaseOrderByCustomer  as PurchaseOrderByCustomer,
      a.ReferenceSDDocument      as ReferenceSDDocument,
      r.Cin                      as CIN,
      r.Contact                  as Contact,
      r.Email                    as Email,
      r.RegOffice                as RegOffice,
      r.Website                  as Website,
      d.TransporterDate          as TransporterDate,
      d.TransporterName          as TransporterName,
      d.VehicleNumber            as VehicleNumber,
      t.longtext                 as Remarks,
      d.TransporterNo            as TransporterNo,
      concat( concat( a.IncotermsClassification, ' - ' ), a.IncotermsLocation1 )     as IncotermsLocation1,
      a.Destination              as Destination,

     _Item,
      _Item2
}

where
  b.Customer is not initial
 // and
 // (a.DocumentType = 'JSTO' or a.DocumentType = 'JSN')  // Added condition for both JSTO and JSN
