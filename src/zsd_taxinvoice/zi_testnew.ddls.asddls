@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TESTING'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TESTNEW as select  from 
  I_BillingDocument   as a 
    inner join I_BillingDocumentItem as e on e.BillingDocument = a.BillingDocument
                                                and e.BillingDocumentItem = '000010'
    left outer join I_SalesDocument         as b on b.SalesDocument = e.SalesDocument
  // left outer join zi_electdoc as d on d.IN_EDocEInvcExtNmbr = a.DocumentReferenceID 
    left outer join I_PaymentTermsText as f on f.PaymentTerms = a.CustomerPaymentTerms
    left outer join I_IncotermsClassificationText as g on g.IncotermsClassification = b.IncotermsClassification
 
    
{
  key a.BillingDocument,
  key b.PurchaseOrderByCustomer as ordernumber,
  //key d.ElectronicDocUUID ,
      a.BillingDocumentType as DocumentType,
      b.CustomerPurchaseOrderDate as orderdate,
      f.PaymentTermsName as paymentterms,
      ////b.YY1_LCNUMBER_SDH as lcnumber,
      ////b.YY1_LCDATE_SDH as lcdate,
      a.CreationDate as dateofinvoice,
      a.CreationTime as timeofinvoice,
//      d.IN_ElectronicDocInvcRefNmbr as irnnumber,
//      d.IN_ElectronicDocAcknDate as irndate,
//      d.IN_ElectronicDocQRCodeTxt as bitmapcode,
//      d.IN_ElectronicDocAcknDate as DateofRemoval,
//      d.IN_ElectronicDocAcknTime as TimeofRemoval,
      b.IncotermsClassification,
      g.IncotermsClassificationName,
      ////b.YY1_Descofitems_SDH as DESCOFITEMS,
      e.Plant

}
where e.SalesDocument is not initial 
