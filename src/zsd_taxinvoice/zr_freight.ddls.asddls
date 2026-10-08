@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Calculation'
define view entity ZR_FREIGHT
  as select from I_BillingDocumentItem      as A 
  inner join I_BillingDocumentItemPrcgElmnt as J on J.BillingDocument    = A.BillingDocument
                                                and J.BillingDocumentItem = A.BillingDocumentItem
{
  key A.BillingDocument     as InvoiceNumber,
  key A.BillingDocumentItem as BillingdocItem,
  case 
  when J.ConditionType = 'ZFRT'
   then cast( J.ConditionAmount as abap.dec(23,2))
   else cast( 0 as abap.dec(23,2))
    end as Freight,
  case 
  when J.ConditionType = 'ZFRT'
   then cast( J.ConditionRateValue as abap.dec(23,2))
   else cast( 0 as abap.dec(23,2)) end as FreightRate,
  case
  when J.ConditionType = 'ZFR1'
   then cast( J.ConditionAmount as abap.dec(23,2))
   else cast( 0 as abap.dec(23,2))
    end as Freight1,
  case 
  when J.ConditionType = 'ZFR1'
   then cast( J.ConditionRateValue as abap.dec(23,2))
   else cast( 0 as abap.dec(23,2)) end as FreightRate1
}
