@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zv_contractreport_v10
  as select from    I_BillingDocumentItem     as a
    inner join      I_BillingDocument         as d   on  a.BillingDocument            = d.BillingDocument
                                                     and d.BillingDocumentType        = 'F2'
                                                     and d.BillingDocumentIsCancelled = ' '

    inner join      I_SalesDocumentItem       as b   on  b.SalesDocument     = a.SalesDocument
                                                     and b.SalesDocumentItem = a.SalesDocumentItem

    inner join      I_SalesContractItem       as c   on  c.SalesContract     = b.ReferenceSDDocument
                                                     and c.SalesContractItem = b.ReferenceSDDocumentItem
    left outer join I_OperationalAcctgDocItem as oad on  oad.CompanyCode     = a.CompanyCode and
                                                        oad.BillingDocument = a.BillingDocument
{

  key c.SalesContract,
  key c.SalesContractItem,
      a.BillingQuantityUnit,
      a.BillingDocument,
      cast( oad.AbsltAmtInAdditionalCurrency1 as abap.dec(21,2)) as amountincompanycode

}

group by
  c.SalesContract,
  c.SalesContractItem,
 oad.AbsltAmtInAdditionalCurrency1,
  a.BillingQuantityUnit,
  a.BillingDocument
