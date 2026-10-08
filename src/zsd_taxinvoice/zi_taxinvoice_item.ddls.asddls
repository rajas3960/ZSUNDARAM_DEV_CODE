@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Tax Invoice Item'
@Metadata.ignorePropagatedAnnotations: true
@UI.presentationVariant: [{
    sortOrder: [{
        by: 'BillingDocumentItem',
        direction: #ASC
    }]
}]
define view entity ZI_TAXINVOICE_ITEM
  as select distinct from ZR_ITEMLINE1                   as a
    left outer join       ZR_TAXDETAILS_FINAL            as f on  f.InvoiceNumber  = a.BillingDocument
                                                              and f.BillingdocItem = a.BillingDocumentItem
    left outer join       I_BillingDocumentItemPrcgElmnt as g on  a.BillingDocument     = g.BillingDocument
                                                              and a.BillingDocumentItem = g.BillingDocumentItem
                                                              and g.ConditionType       = 'ZDIS'
    left outer join       I_BillingDocumentItemPrcgElmnt as h on  a.BillingDocument     = h.BillingDocument
                                                              and a.BillingDocumentItem = h.BillingDocumentItem
                                                              and h.ConditionType       = 'ZACC'
    left outer join       I_BillingDocumentItemPrcgElmnt as i on  a.BillingDocument     = i.BillingDocument
                                                              and a.BillingDocumentItem = i.BillingDocumentItem
                                                              and i.ConditionType       = 'ZCES'
    left outer join       I_BillingDocumentItemPrcgElmnt as j on  a.BillingDocument     = j.BillingDocument
                                                              and a.BillingDocumentItem = j.BillingDocumentItem
                                                              and j.ConditionType       = 'JTC2'
    left outer join       I_BillingDocumentItemPrcgElmnt as k on  a.BillingDocument     = k.BillingDocument
                                                              and a.BillingDocumentItem = k.BillingDocumentItem
                                                              and k.ConditionType       = 'ZPR0'
    left outer join       I_BillingDocumentItemPrcgElmnt as l on  a.BillingDocument     = l.BillingDocument
                                                              and a.BillingDocumentItem = l.BillingDocumentItem
                                                              and l.ConditionType       = 'ZVPR'
    left outer join       I_BillingDocument              as t on t.BillingDocument = a.BillingDocument

  association to parent ZI_TAXINVOICE_HEADER as _Head on $projection.BillingDocument = _Head.SerialInvoiceNo
{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.DistributionChannel       as DistributionChannel,
      a.BillingDocumentItemText   as DescOfGoods,
      a.hsncode                   as HSNCode,
      a.BillingQuantityUnit       as OrderUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      a.BillingQuantity           as InvoiceQuantity,
      a.TransactionCurrency,
      a.ItemWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      a.ItemNetWeight,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.NetAmount                 as RatePerUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.Billingnetamount,
      a.HandlingUnitQuantityUnit  as PackingUnit,
      a.HandlingUnitQtyMax        as PackingQuantityMax,
      a.HandlingUnitQtyMin        as PackingQuantityMin,
      a.HandlingUnitPackQty       as PackingQuantityTotal,
      f.CGST                      as CGST,
      f.CGSTRATE                  as CGSTRate,
      f.SGST                      as SGST,
      f.SGSTRATE                  as SGSTRate,
      f.IGST                      as IGST,
      f.IGSTRATE                  as IGSTRate,
      f.UTGST                     as UTGST,
      f.UTGSTRATE                 as UTGSTRate,
      f.TCS                       as TCS,
      f.Freight                   as Freight,
      f.ROUNDOFF                  as Roundoff,
      g.ConditionRateRatio * (-1) as DiscountRate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      g.ConditionAmount * (-1)    as Discount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
      when t.BillingDocumentType = 'F8' or t.BillingDocumentType = 'JSN'
      then l.ConditionAmount
      else
      h.ConditionAmount
      end                         as TaxableAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      i.ConditionAmount           as CessAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      j.ConditionAmount           as TCSAmount,
      k.ConditionRateValue        as RateNew,
      _Head

}
