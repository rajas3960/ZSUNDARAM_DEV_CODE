@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTReport_VF 
  as select from ZV_CONTRACTReport_V3

{

  key SalesContract,
  key SalesContractItem,

      SalesOrganization,
      DistributionChannel,
      OrganizationDivision,
      Broker,
      BrokerName,
      SalesContractDate,
      SalesContractValidityEndDate,
      SoldToParty,
      CustomerFullName,
      TransactionCurrency,
      ConditionValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ConditionAmount,
      RequestedQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      ContractQty,
//      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
//      InvoicedQty,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      PendingQty,
      CreditSegmentCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      EffectiveTotalCreditLimitAmt,
      CreditLimitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ReserveValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Reserve,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      
      //      case when DispatchableBalance > 0 then DispatchableBalance end as DispatchableBalance,
      DispatchableBalance,
      
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      case when GrossPricePerTon is not initial then
      //             division( cast( DispatchableBalance as abap.dec( 15,2 ) ) , cast(PendingQty as abap.dec( 15,2 )) , 2 )
      division( cast( DispatchableBalance as abap.dec( 15,2 ) ) , cast(GrossPricePerTon as abap.dec( 15,2 )) , 2 )
      else 0
      end as DispatchableQty,
      //  case when DispatchableQty > 0 then DispatchableQty end         as DispatchableQty,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ProjectedValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Receivable,
      sales_order_no,
      GrossPricePerTon,
      PaymentTermsDescription // ++ 11.09.25


}
//where
//  PendingQty is not initial
