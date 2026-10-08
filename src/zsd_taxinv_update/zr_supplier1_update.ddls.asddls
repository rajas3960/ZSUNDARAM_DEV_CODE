@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details of Supplier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SUPPLIER1_UPDATE as select distinct from    I_BillingDocument             as a
   // inner join      ZR_SUPPLIER2                  as e on e.BillingDocument = a.BillingDocument  // -- ON 24.07.25
   left outer join    ZR_SUPPLIER2                  as e on e.BillingDocument = a.BillingDocument
    left outer join I_SalesDocument               as b on b.SalesDocument = e.SalesDocument
  //  left outer join ZI_ELECTDOC2                  as d on d.IN_EDocEInvcExtNmbr = a.BillingDocument
    left outer join ZR_EINVEWAY_F                 as d on d.BillingDocument = a.BillingDocument
    left outer join I_PaymentTermsText            as f on f.PaymentTerms = a.CustomerPaymentTerms
    left outer join I_IncotermsClassificationText as g on g.IncotermsClassification = b.IncotermsClassification
    left outer join I_BillingDocumentBasic        as h on h.BillingDocument = a.BillingDocument
    left outer join I_BillingDocumentItem         as i on i.BillingDocument = a.BillingDocument
    left outer join I_CreditMemoRequest           as j on j.CreditMemoRequest = i.ReferenceSDDocument  
    left outer join I_DeliveryDocument            as k on k.DeliveryDocument = i.ReferenceSDDocument
    left outer join I_DebitMemoRequest            as l on l.DebitMemoRequest = i.ReferenceSDDocument   // ++ 25.07.25


{
  key a.BillingDocument,
  key b.PurchaseOrderByCustomer   as ordernumber,
      a.PurchaseOrderByCustomer   as ordernumber1,
      a.BillingDocumentType       as DocumentType,
      b.CustomerPurchaseOrderDate as orderdate,
      f.PaymentTermsName          as paymentterms,
      ////b.YY1_LCNUMBER_SDH            as lcnumber,
      ////b.YY1_LCDATE_SDH              as lcdate,
      a.CreationDate              as dateofinvoice,
      a.CreationTime              as timeofinvoice,
      d.irn                       as irnnumber,
      a.BillingDocumentDate       as irndate,
      d.signedqrcode              as bitmapcode,
      d.ackdate                   as DateofRemoval,
      ''                          as TimeofRemoval,
      b.IncotermsClassification,
      b.IncotermsLocation1,
      g.IncotermsClassificationName,
      ////b.YY1_Descofitems_SDH         as DESCOFITEMS,
      ////a.YY1_Remarks_BDH             as remarks,
      e.Plant,
      a.CompanyCode               as CompanyCode,
      h.PurchaseOrderByCustomer   as PurchaseOrderByCustomer,
      // case condition for mdebit / credit memo              // ++ 25.07.25 SP
      case 
      when a.BillingDocumentType = 'G2' then j.ReferenceSDDocument         
      when a.BillingDocumentType = 'L2' then l.ReferenceSDDocument
      else null
      end  as ReferenceSDDocument,
      // till this case condition for debit / credit memo              // ++ 25.07.25 SP
      k.YY1_Destination_DLH       as Destination

}
//where
 // e.SalesDocument is not initial;  // -- 24.07.25
