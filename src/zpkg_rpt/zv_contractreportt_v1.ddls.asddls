@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'second'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRePortT_V1
  as select from    I_BillingDocumentItem     as a
    inner join      I_BillingDocument         as d   on  a.BillingDocument            = d.BillingDocument
                                                     and d.BillingDocumentType        = 'F2'
                                                     and d.BillingDocumentIsCancelled = ' '

    inner join      I_SalesDocumentItem       as b   on  b.SalesDocument     = a.SalesDocument
                                                     and b.SalesDocumentItem = a.SalesDocumentItem

    inner join      I_SalesContractItem       as c   on  c.SalesContract     = b.ReferenceSDDocument
                                                     and c.SalesContractItem = b.ReferenceSDDocumentItem
    left outer join I_OperationalAcctgDocItem as oad on  oad.CompanyCode     = a.CompanyCode
                                                     and oad.BillingDocument = a.BillingDocument
{

  key c.SalesContract,
  key c.SalesContractItem,
      a.BillingQuantityUnit,
      a.BillingDocument,
      sum(cast( oad.AmountInCompanyCodeCurrency as abap.dec(21,2))) as amountincompanycode,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      sum( a.BillingQuantity )                                      as BillingQuantity

}

group by
  c.SalesContract,
  c.SalesContractItem,
  a.BillingQuantityUnit,
  a.BillingDocument
  //oad.AmountInCompanyCodeCurrency
