@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Discount Calculation'
define view entity ZR_DISCOUNT
  as select from I_BillingDocumentItem      as A 
  inner join I_BillingDocumentItemPrcgElmnt as J on J.BillingDocument    = A.BillingDocument
                                                and J.BillingDocumentItem = A.BillingDocumentItem
{
  key A.BillingDocument     as InvoiceNumber,
  key A.BillingDocumentItem as BillingdocItem,
  case
  when J.ConditionType = 'ZVOL'
   then cast( J.ConditionAmount as abap.dec(23,2)) 
   else cast( 0 as abap.dec(23,2)) 
    end as Discount1,
  case
  when J.ConditionType = 'ZCSH'
   then cast( J.ConditionAmount as abap.dec(23,2)) 
   else cast( 0 as abap.dec(23,2)) 
    end as Discount2,
  case
  when J.ConditionType = 'ZSPL'
   then cast( J.ConditionAmount as abap.dec(23,2)) 
   else cast( 0 as abap.dec(23,2)) 
    end as Discount3,
  case
  when J.ConditionType = 'ZADV'
   then cast( J.ConditionAmount as abap.dec(23,2)) 
   else cast( 0 as abap.dec(23,2)) 
    end as Discount4,
  case
  when J.ConditionType = 'ZFIT'
   then cast( J.ConditionAmount as abap.dec(23,2)) 
   else cast( 0 as abap.dec(23,2)) 
    end as Discount5
}
