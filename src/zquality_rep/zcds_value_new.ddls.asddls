@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 New Values'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_VALUE_NEW
  as select from    I_BillingDocument     as a
    left outer join I_BillingDocumentItem as b on b.BillingDocument = a.BillingDocument
{
  key a.BillingDocument                        as InvNo,
      a.CreationDate                           as InvDate,
      a.PurchaseOrderByCustomer                as PO,
      b.Material,
      b.BillingDocumentItemText                as MaterialName,
      cast( b.ItemNetWeight as abap.dec(21,2)) as Quantity,
      a.SoldToParty                            as CustomerName
}
