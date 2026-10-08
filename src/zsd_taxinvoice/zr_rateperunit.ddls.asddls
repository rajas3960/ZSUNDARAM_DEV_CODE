@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rate per unit Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_RATEPERUNIT 
    as select from I_BillingDocumentItem      as a
    left outer join I_BillingDocumentItemPrcgElmnt as J on  J.BillingDocument     = a.BillingDocument
                                                        and J.BillingDocumentItem = a.BillingDocumentItem
{
  key a.BillingDocument,
  key a.BillingDocumentItem,
  case 
  when J.ConditionType = 'ZPR1'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZPR0'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZPEX'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZPR2'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZSRP'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZAST'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZSAM'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZSTO'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZP01'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZP02'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  when J.ConditionType = 'ZVPR'
  then cast( J.ConditionRateAmount as abap.dec(23,2))
  else 
  cast( 0 as abap.dec(23,2))
  end as NetAmount
  
}
