@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds for debit credit note'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_DEBIT_CREDIT
  as select from    I_SuplrInvcItemPurOrdRefAPI01 as a
    left outer join I_PurchaseOrderItemAPI01      as b on  a.PurchaseOrder     = b.PurchaseOrder
                                                       and a.PurchaseOrderItem = b.PurchaseOrderItem
    left outer join I_TaxCodeText                 as c on  c.TaxCode  = a.TaxCode
                                                       and c.Language = 'E'
    left outer join I_SupplierInvoiceAPI01        as d on d.SupplierInvoice = a.SupplierInvoice
{
  key  a.SupplierInvoice,
  key  a.SupplierInvoiceItem,
  key  a.FiscalYear,
       a.PurchaseOrder,
       a.PurchaseOrderItem,
       a.Plant,
       b.PurchaseOrderItemText         as PurchaseOrderItemMaterial,
       a.PurchaseOrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       a.QuantityInPurchaseOrderUnit,
       a.DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a.SupplierInvoiceItemAmount,
       a.IsSubsequentDebitCredit,
       c.TaxCodeName                   as TaxCode,
       a.DebitCreditCode,
       d.SupplierPostingLineItemText   as ItemText,
       d.SupplierInvoiceIDByInvcgParty as InvoiceReference,
       d.CompanyCode                   as CompanyCode
}
where
   (  a.DebitCreditCode         = 'H'
  or(
        a.DebitCreditCode         = 'S'
    and a.IsSubsequentDebitCredit = 'X'
  ) )
//  and a.SupplierInvoice = '5105600380'
