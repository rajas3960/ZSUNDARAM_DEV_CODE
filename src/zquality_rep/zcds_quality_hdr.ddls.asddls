@AbapCatalog.sqlViewName: 'ZCDS_QUALITYHDR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Header Data'
define view ZCDS_QUALITY_HDR

  with parameters
    p_matnr      :abap.char( 40 ),
    p_billingdoc :abap.char(10)
  as select from    I_BillingDocument      as a

    inner join      I_BillingDocumentItem  as b on  b.BillingDocument = a.BillingDocument
                                                and b.Product         = $parameters.p_matnr

    inner join      I_DeliveryDocumentItem as d on  d.DeliveryDocument     = b.ReferenceSDDocument
                                                and d.DeliveryDocumentItem = b.ReferenceSDDocumentItem

    left outer join I_Customer             as f on f.Customer = b.SoldToParty

    left outer join I_ProductDescription   as g on g.Product = b.Product

    left outer join I_SalesDocument        as k on k.SalesDocument = b.SalesDocument

    left outer join I_SalesDocumentItem    as h on  h.SalesDocument     = b.SalesDocument
                                                and h.SalesDocumentItem = b.SalesDocumentItem

    left outer join ZQLTY_QTY_PRINT        as i on i.DeliveryDocument = d.DeliveryDocument

    left outer join I_Product              as j on j.Product = b.Product


    left outer join I_SalesOrderPartner    as m on  m.SalesOrder      = b.SalesDocument
                                                and m.PartnerFunction = 'WE'

    left outer join zdt_gate_item          as l on l.salesorder = b.SalesDocument

    inner join      zdt_gatehead           as n on n.gatepassno = l.gatepassno

{
  key a.BillingDocument,
  key b.BillingDocumentItem,
      b.Plant,
      b.Material,
      b.Batch,
      m.FullName                as CustomerName,
      g.ProductDescription      as filmtype,
      k.PurchaseOrderByCustomer as Pono,
      d.DeliveryDocumentItem,
      b.SalesDocument,
      b.SalesDocumentItem,
      a.BillingDocumentDate,
      g.ProductDescription,
      j.ProductGroup,
      n.vehicleno,
      l.gatepassno,
      l.gateitem

}
where
  a.BillingDocument = $parameters.p_billingdoc
