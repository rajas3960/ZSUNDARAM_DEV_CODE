@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Details Final 4'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_TAX_INVOICE
  as select distinct from ZR_TAXDETAILS_FINAL4 as b

{
  key InvoiceNumber,
  key BillingdocItem,
      sum( Freight )  as Freight,
      sum( Discount ) as Discount
}
group by
  InvoiceNumber,
  BillingdocItem
