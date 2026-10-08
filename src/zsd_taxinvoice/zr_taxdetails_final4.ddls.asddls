@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Details Final 4'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_TAXDETAILS_FINAL4
  as select distinct from ZR_TAXDETAILS_FINAL2 as b

{
  key b.InvoiceNumber,
  key b.BillingdocItem,
      cast( ( b.Freight + b.Freight1 )  as abap.dec( 13, 2 ) ) as Freight,
      cast( 0 as abap.dec( 13, 2 ) )                           as Discount
}
union select distinct from ZR_TAXDETAILS_FINAL3 as c

{
  key c.InvoiceNumber,
  key c.BillingdocItem,
      cast( 0 as abap.dec( 13, 2 ) )                                                                           as Freight,
      cast(  abs( c.Discount1 + c.Discount2 + c.Discount3 + c.Discount4 + c.Discount5 ) as abap.dec( 13, 2 ) ) as Discount
}
