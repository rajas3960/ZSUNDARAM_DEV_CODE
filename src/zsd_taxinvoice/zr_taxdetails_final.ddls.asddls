@EndUserText.label: 'Final view for Tax Details'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_TAXDETAILS_FINAL
  as select distinct from ZR_TAXDETAILS  as a
    left outer join       ZR_TAX_INVOICE as b on  a.InvoiceNumber  = b.InvoiceNumber
                                              and a.BillingdocItem = b.BillingdocItem
{
  key a.InvoiceNumber,
  key a.BillingdocItem,
      sum(a.CGST)      as CGST,
      sum(a.SGST)      as SGST,
      sum(a.IGST)      as IGST,
      sum(a.UTGST)     as UTGST,
      sum(a.TCS)       as TCS,
      //SOC for roundoff on 04.08.25
      sum(a.ROUNDOFF)  as ROUNDOFF,
      //EOC
      sum(a.CGSTRate)  as CGSTRATE,
      sum(a.SGSTRate)  as SGSTRATE,
      sum(a.IGSTRate)  as IGSTRATE,
      sum(a.UTGSTRate) as UTGSTRATE,
      b.Freight        as Freight,
      b.Discount       as Discount
}
where
     a.CGSTRate is not initial
  or a.SGSTRate is not initial
  or a.IGSTRate is not initial
  or a.TCS      is not initial
  or a.ROUNDOFF is not initial
  or b.Freight  is not initial
  or b.Discount is not initial
group by
  a.InvoiceNumber,
  a.BillingdocItem,
  b.Freight,
  b.Discount
