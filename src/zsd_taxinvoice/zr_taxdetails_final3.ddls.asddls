@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Details Final 3'
define view entity ZR_TAXDETAILS_FINAL3
  as select distinct from ZR_DISCOUNT
{
    key InvoiceNumber,
    key BillingdocItem,
    sum(Discount1) as Discount1,
    sum(Discount2) as Discount2,
    sum(Discount3) as Discount3,
    sum(Discount4) as Discount4,
    sum(Discount5) as Discount5
} where Discount1 is not initial or Discount2 is not initial or Discount3 is not initial or
        Discount4 is not initial or Discount5 is not initial
  group by InvoiceNumber,
           BillingdocItem
