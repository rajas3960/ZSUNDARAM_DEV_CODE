@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'demo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zdemo2
  as select from    I_BillingDocumentItem     as a
    inner join      I_BillingDocument         as d   on  a.BillingDocument            = d.BillingDocument
                                                     and d.BillingDocumentType        = 'F2'
                                                     and d.BillingDocumentIsCancelled = ' '

    inner join      I_SalesDocumentItem       as b   on  b.SalesDocument     = a.SalesDocument
                                                     and b.SalesDocumentItem = a.SalesDocumentItem

    inner join      I_SalesContractItem       as c   on  c.SalesContract     = b.ReferenceSDDocument
                                                     and c.SalesContractItem = b.ReferenceSDDocumentItem
    left outer join I_OperationalAcctgDocItem as oad on  oad.CompanyCode       = a.CompanyCode
                                                     and oad.BillingDocument   = a.BillingDocument
                                                     and oad.SalesDocument     = c.SalesContract
                                                     and oad.SalesDocumentItem = c.SalesContractItem
{

  key c.SalesContract,
  key c.SalesContractItem,
      a.BillingQuantityUnit,
      a.BillingDocument,
      //      a.BillingPlanRule,
      //      a.BillingDocumentType,
      //cast( a.NetAmount as abap.dec(15,2) ) as Netamount,
      //cast( oad.AbsltAmtInAdditionalCurrency1 as abap.dec(15,2) ) as Netamount,
      //sum( cast( oad.AmountInCompanyCodeCurrency as abap.dec(21,2)) ) as amountincompanycode,
      a.BillingPlanRule,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      a.BillingQuantity
}
where a.BillingPlanRule is initial

group by
  c.SalesContract,
  c.SalesContractItem,
  a.BillingQuantityUnit,
  oad.AmountInCompanyCodeCurrency,
  a.BillingDocument,
  a.BillingQuantity,
  a.BillingPlanRule //,a.BillingPlanRule,a.BillingDocumentType
//a.NetAmount
//oad.AbsltAmtInAdditionalCurrency1
