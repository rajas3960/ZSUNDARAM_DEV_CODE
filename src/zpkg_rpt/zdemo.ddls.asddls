@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'demo_pp'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zdemo 
  as select from I_SalesContractItem   as a
    inner join   zv_contractreport_v10 as b on a.SalesContract = b.SalesContract
                                             and  a.SalesContractItem = b.SalesContractItem
{
  key b.SalesContract,
  key b.SalesContractItem,
      b.BillingQuantityUnit,
      //sum( cast( b.amountincompanycode as abap.dec(21,2)) ) as amountincompanycode,
      sum( cast( b.amountincompanycode as abap.dec(21,2)) ) as amountincompanycode
//      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//      sum( b.BillingQuantity )                                     as BillingQuantity

}

group by
  b.SalesContract,
  b.SalesContractItem,
 b.BillingQuantityUnit
