@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO STO'
define view entity ZR_PO_STO
  as select distinct from  I_BillingDocumentItem  as a
  inner join               I_PurchaseOrderAPI01 as b on b.PurchaseOrder = a.SalesDocument
{
    key a.BillingDocument,
        a.SalesDocument as PurchaseOrder,
        b.PurchaseOrderDate
} where a.BillingDocumentType = 'JSTO'
