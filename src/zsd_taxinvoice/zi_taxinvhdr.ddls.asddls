@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Tax Invoice Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TAXINVHDR
  as select from   ZR_SUPPLIER    as a
    left outer join ZR_RECEIVER    as b on b.BillingDocument = a.BillingDocument
    left outer join ZR_CONSIGNEE   as c on c.BillingDocument = a.BillingDocument
    left outer join ZR_TRANSPORTER as d on d.BillingDocument = a.BillingDocument
    left outer join ZI_DetailsOfBank as e on e.Customer = c.Customer
    left outer join ZR_TAXDETAILS_FINAL as f on f.InvoiceNumber = a.BillingDocument
                                            // and   f.BillingdocItem = a.BillingDocumentItem
    left outer join ZI_PLANT_DETAILS_FINAL as g on g.BillingDocument = a.BillingDocument

  composition [0..*] of ZI_TAXINVITEM as _Item
{

  key a.BillingDocument      as SerialInvoiceNo,
      a.ordernumber          as OrderNumber,
      a.DocumentType         as DocumentType,
      c.Customer             as Customer,
      e.BankName             as BankName,
      e.BankAddress          as BankAddress,
      e.AccountNumber        as AccountNumber,
      e.AccountName          as AccountName,
      e.IfscCode             as IfscCode,
      c.BusinessPartnerName1 as CBusinessName,
      c.BPAddrStreetName     as CAddress,
      c.CityName             as CCityName,
      c.RegionName           as CStateName,
      c.PostalCode           as CStateCode,
      c.TaxNumber3           as CGSTIN,
      c.FullAddress          as CFullAddress,
      b.BusinessPartnerName1 as RBusinessName,
      b.BPAddrStreetName     as RAddress,
      b.CityName             as RCityName,
      b.RegionName           as RStateName,
      b.TaxNumber3           as RGSTIN,
      b.FullAddress          as RFullAddress,
      a.orderdate            as OrderDate,
      a.paymentterms         as PaymentTerms,
//      a.lcnumber             as LCNumber,
//      a.lcdate               as LCDate,
      a.dateofinvoice        as DateOfInvoice,
      a.irnnumber            as IRNNumber,
      a.irndate              as IRNDate,
      a.bitmapcode           as BitmapCode,
//      d.name                 as TransporterName,
//      d.lrnumber             as LRNumber,
//      d.lrdate               as LRDate,
//      d.vehiclenumber        as VehicleNumber,
//      d.dispatchedthrough    as DispatchedThrough,
//      d.exchangerate         as ExchangedRate,
//      d.containernumber      as ContainerNumber,
//      d.YY1_unitpackage_DLH,
      f.CGST                 as CGST,
      f.CGSTRATE             as CGSTRate,
      f.SGST                 as SGST,
      f.SGSTRATE             as SGSTRate,
      f.IGST                 as IGST,
      f.IGSTRATE             as IGSTRate,
      f.TCS                  as TCS,
      g.PlantNo              as PlantNo,
      g.PlantName            as PlantName,
      g.PlantAddress         as PlantAddress,
      g.State                as StateOfSupply,
      g.StateCode            as StateCode,
      ''                     as tprint,
      ''                     as amountinwords,
      _Item

} 
where c.Customer is not initial

