@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTReport_V3 
  as select from ZV_CONTRACTRePorT_V2

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
      case
          when EffectiveTotalCreditLimitAmt is not null and EffectiveTotalCreditLimitAmt > 0
          then  cast( EffectiveTotalCreditLimitAmt  as abap.dec( 21,2 ) )
          when  EffectiveTotalCreditLimitAmt is null or EffectiveTotalCreditLimitAmt < 0
          then 0
          else 0
          end as EffectiveTotalCreditLimitAmt,
      CreditLimitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ReserveValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Reserve,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
      when CreditLimitAmt is not null and Reserve is not null
      then cast( CreditLimitAmt as abap.dec( 21,2 ) ) -  cast( Reserve as abap.dec( 21,2 ) )
      when CreditLimitAmt is not null and Reserve is null
      then cast( CreditLimitAmt as abap.dec( 21,2 ) )
      else 0
      end     as DispatchableBalance,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      case when GrossPricePerTon is not initial then
      division( cast( DispatchableBalance as abap.dec( 15,2 ) ) , cast( GrossPricePerTon as abap.dec( 15,2 )) , 2 )
      else 0
      end     as DispatchableQty,
      ProjectedValue,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when Receivable is not null and Receivable > 0
      then cast (Receivable as abap.dec( 21,2 ) )
      when Receivable is null or Receivable < 0
      then 0
      else 0
      end     as Receivable,
      sales_order_no,
      GrossPricePerTon,
      PaymentTermsDescription // ++ 11.09.25
}
