@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Item View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZIN_ITEM_VIEW 
as select from I_BillingDocumentItem as BOI
{
    key BillingDocument as Invoiceno,
    key BillingDocumentItem,
        Product,
        BillingDocumentItemText,
        cast( NetAmount as abap.dec(15,3)) as Invoiceval
}
