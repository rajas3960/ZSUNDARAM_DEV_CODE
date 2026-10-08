@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice GST Tax'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZIN_INVOICE_TAX
  as select from    I_BillingDocumentItem          as BDI
    left outer join I_BillingDocumentItemPrcgElmnt as IGST on  IGST.BillingDocument     = BDI.BillingDocument
                                                           and IGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and IGST.ConditionType       = 'JOIG' //Standard IGST
    left outer join I_BillingDocumentItemPrcgElmnt as CGST on  CGST.BillingDocument     = BDI.BillingDocument
                                                           and CGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and CGST.ConditionType       = 'JOCG' //Standard CGST
    left outer join I_BillingDocumentItemPrcgElmnt as SGST on  SGST.BillingDocument     = BDI.BillingDocument
                                                           and SGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and SGST.ConditionType       = 'JOSG' //Standard SGST

{
  key BDI.BillingDocument,
  key BDI.BillingDocumentItem,
      BDI.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'      
      BDI.NetAmount,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( IGST.ConditionAmount as abap.dec(15,2)) as IGSTAmount,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'      
      cast( CGST.ConditionAmount as abap.dec(15,2)) as CGSTAmount,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'      
      cast( SGST.ConditionAmount as abap.dec(15,2)) as SGSTAmount,
      case
           when IGST.ConditionType is not initial then cast( IGST.ConditionRateValue as abap.int4 )
           when CGST.ConditionType is not initial then
           cast( cast( CGST.ConditionRateValue as abap.int4 ) * 2 as abap.int4 ) 
           else null end as Taxrate  
}           
