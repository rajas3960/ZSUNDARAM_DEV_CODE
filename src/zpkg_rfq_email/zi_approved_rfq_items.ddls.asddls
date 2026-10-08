@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Approved RFQ items'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_Approved_RFQ_Items
  as select from I_RfqItem_Api01             as rfq
    inner join   I_RfqBidder_Api01           as bidder  on rfq.RequestForQuotation = bidder.RequestForQuotation
    inner join   I_Requestforquotation_Api01 as rfq_api on rfq.RequestForQuotation = rfq_api.RequestForQuotation
  //      inner join   I_RequestForQuotationItemTP as rfq_item on  rfq.RequestForQuotation     = rfq_item.RequestForQuotation
  //                                                           and rfq.RequestForQuotationItem = rfq_item.RequestForQuotationItem
{
  key rfq.RequestForQuotation        as rfqNumber,
  key rfq.RequestForQuotationItem    as rfqItemNumber,
      rfq.PurchaseRequisition        as prNumber,
      rfq.PurchaseRequisitionItem    as prItemNumber,
      rfq.Material                   as material,
      rfq.PurchasingDocumentItemText as materialDescription,
      rfq.OrderQuantityUnit          as uom,
      bidder.Supplier                as bidder
}
//where
//  rfq_api.RFQLifecycleStatus = '2'
