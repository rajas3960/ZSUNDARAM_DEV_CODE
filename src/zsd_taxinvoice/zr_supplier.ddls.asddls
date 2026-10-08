@EndUserText.label: 'Details of Supplier'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_SUPPLIER 
  as select from    I_BillingDocument   as a 
    left outer join I_BillingDocumentItem as e on e.BillingDocument = a.BillingDocument
    left outer join I_SalesDocument         as b on b.SalesDocument = e.SalesDocument
    left outer join I_BillingDocument       as c on c.BillingDocument = a.BillingDocument
    left outer join I_IN_ElectronicDocInvoice as d on d.IN_EDocEInvcExtNmbr = a.BillingDocument
    
{
  key a.BillingDocument,
  //key a.BillingDocumentItem,
  key b.PurchaseOrderByCustomer as ordernumber,
      a.BillingDocumentType as DocumentType,
      b.CustomerPurchaseOrderDate as orderdate,
      c.CustomerPaymentTerms as paymentterms,
      ///b.YY1_LCNUMBER_SDH as lcnumber,
      ///b.YY1_LCDATE_SDH as lcdate,
      c.CreationDate as dateofinvoice,
      d.IN_ElectronicDocInvcRefNmbr as irnnumber,
      d.IN_ElectronicDocAcknDate as irndate,
      d.IN_ElectronicDocQRCodeTxt as bitmapcode

}
where e.SalesDocument is not initial ;
 