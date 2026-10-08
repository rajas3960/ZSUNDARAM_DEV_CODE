@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'demo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zdemo3 as select from  I_SalesContractItem as a
    inner join   zdemo2   as b on  a.SalesContract     = b.SalesContract
                                          and a.SalesContractItem = b.SalesContractItem
{
  key b.SalesContract,
  key b.SalesContractItem,
      b.BillingQuantityUnit,
      //      sum( cast( b.amountincompanycode as abap.dec(21,2)) ) as amountincompanycode,
      //cast( b.Netamount as abap.dec(21,2))  as Netamount,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      sum( b.BillingQuantity )                    as BillingQuantity

}

group by
  b.SalesContract,
  b.SalesContractItem,
  b.BillingQuantityUnit
