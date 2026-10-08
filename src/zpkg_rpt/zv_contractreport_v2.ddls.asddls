@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRePorT_V2 
  as select from ZV_CONTRACTRePorT_V0

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
      @Semantics.amount.currencyCode: 'CreditSegmentCurrency'
      EffectiveTotalCreditLimitAmt,
      CreditLimitAmt,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Receivable,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ReserveValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      division( cast( PendingQty as abap.dec( 15,2 ))  * 10 *  cast( GrossPricePerTon as abap.dec( 15,2 )) , 100, 2 ) as Reserve,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case
      when EffectiveTotalCreditLimitAmt is not null and ReserveValue is not null
      then cast( EffectiveTotalCreditLimitAmt as abap.dec( 21,2 ) ) -  cast( ReserveValue as abap.dec( 21,2 ) )
      when EffectiveTotalCreditLimitAmt is not null and ReserveValue is null
      then cast( EffectiveTotalCreditLimitAmt as abap.dec( 21,2 ) )
      else 0
      end                                                                                                             as DispatchableBalance,
      // cast( ContractQty as abap.dec( 15,2 ) ) * cast( ConditionValue as abap.dec( 15,2 ) ) as ProjectedValue
      cast( PendingQty as abap.dec( 15,2 ) ) * cast( GrossPricePerTon as abap.dec( 15,2 ) )                           as ProjectedValue,
      sales_order_no,
      GrossPricePerTon,
      PAYMENTTERMSDESCRIPTION                                                                                         as PaymentTermsDescription // ++ 11.09.25

}
