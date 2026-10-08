@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZV_CONTRACT_VF3
  as select from ztabl_FCTN_CONTRACT
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
      ConditionAmount,
      RequestedQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      ContractQty,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      InvoicedQty,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      PendingQty,
      CreditSegmentCurrency,
      EffectiveTotalCreditLimitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when PendingQty > 0 then CreditLimitAmt else 0 end                              as CreditLimitAmt,
      //      case when PendingQty > 0 then CreditLimitAmt else 0 end as CreditLimitAmt,
      ReserveValue,
      case when PendingQty > 0 then Reserve else 0 end                                     as Reserve,
      case when PendingQty > 0 and CreditLimitAmt >= 0 then DispatchableBalance else 0 end as DispatchableBalance,
      case when PendingQty > 0 and CreditLimitAmt >= 0 then DispatchableQty else 0 end     as DispatchableQty,
      ProjectedValue,
      case when PendingQty > 0 then Receivable else 0 end                                  as Receivable,
      sales_order_no,
      GrossPricePerTon,
      PAYMENTTERMSDESCRIPTION // ++ 11.09.25
}
