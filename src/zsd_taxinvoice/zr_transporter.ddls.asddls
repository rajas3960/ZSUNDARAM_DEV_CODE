@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transporter Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_TRANSPORTER 
 as select distinct from I_BillingDocumentItem as a
   left outer join I_DeliveryDocument      as b on b.DeliveryDocument = a.ReferenceSDDocument
   left outer join I_BillingDocument       as c on c.BillingDocument = a.BillingDocument
   left outer join I_DeliveryDocumentItem  as d on d.DeliveryDocument = a.ReferenceSDDocument
   left outer join zdt_gate_item           as e on e.salesorder = d.ReferenceSDDocument 
                                                and e.gatepassno = b.YY1_GatePassNumber_DLH
   left outer join zdt_gatehead            as f on f.gatepassno = e.gatepassno
   left outer join zdt_einveway            as g on g.vbeln = a.BillingDocument

{
  key a.BillingDocument,
     //// b.YY1_TRANSPORTERNAME_DLH as name,
      ////b.YY1_LR_NUMBER_DLH as lrnumber,
      ////b.YY1_lr_date_DLH as lrdate,
     //// b.YY1_VEHICLENUMBER_DLH as vehiclenumber,
     //// b.YY1_DISPATCHEDTHROUGH_DLH as dispatchedthrough,
      a.DistributionChannel as distributionchannel,
      a.PriceDetnExchangeRate as exchangerate,
      c.CreationDate          as TransporterDate,
      case 
      when g.newtranno is initial
      then g.transporterdocumentnumber
      else
      g.newtranno
      end                     as TransporterNo,
      g.transportername       as TransporterName,
      case
      when g.newvehicleno is initial
      then g.vehiclenumber
      else
      g.newvehicleno
      end                     as VehicleNumber
//      case
//      when c.CompanyCode = '1000' or c.CompanyCode = '2000'
//      then
//      f.transportername
//      when c.CompanyCode = '3000' or c.CompanyCode = '4000'
//      then g.transportername
//      end                     as TransporterName,
//      case
//      when c.CompanyCode = '1000' or c.CompanyCode = '2000'
//      then
//      f.vehicleno             
//      when c.CompanyCode = '3000' or c.CompanyCode = '4000'
//      then 
//      g.vehiclenumber 
//      end                     as VehicleNumber
     //// b.YY1_CONTAINERNUMBER_DLH as containernumber,
     //// b.YY1_TRASPOTERNAME_DLH as Trasname,
    ////  b.YY1_unitpackage_DLH
  
}
