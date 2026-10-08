@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Details Final 2'
define view entity ZR_TAXDETAILS_FINAL2
  as select distinct from ZR_FREIGHT
{
    key InvoiceNumber,
    key BillingdocItem,
    sum(Freight) as Freight,
    sum(Freight1) as Freight1
} where Freight is not initial or Freight1 is not initial
  group by InvoiceNumber,
           BillingdocItem
