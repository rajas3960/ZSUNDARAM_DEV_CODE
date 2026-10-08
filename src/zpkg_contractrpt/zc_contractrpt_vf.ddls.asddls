@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_CONTRACTRPT_VF

  provider contract transactional_query 

  as projection on ZV_CONTRACT_VF3
{

              @EndUserText.label: 'Sales Contract'
  key         SalesContract,
              @EndUserText.label: 'Sales Contract Item'
  key         SalesContractItem,
              @EndUserText.label: 'Sales Organization'
              SalesOrganization,
              @EndUserText.label: 'Distribution Channel'
              DistributionChannel,
              @EndUserText.label: 'Division'
              OrganizationDivision,
              @EndUserText.label: 'Broker'
              Broker,
              @EndUserText.label: 'Broker Name'
              BrokerName,
              @EndUserText.label: 'Contract Date'
              SalesContractDate,
              @EndUserText.label: 'Sales Contract Validity End Date'
              SalesContractValidityEndDate,
              @EndUserText.label: 'Customer'
              SoldToParty,
              @EndUserText.label: 'Customer Name'
              CustomerFullName,
              @EndUserText.label: 'Currency'
              TransactionCurrency,
              @EndUserText.label: 'Price per TON'
              ConditionValue,
              @EndUserText.label: 'Contract Base Value'
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              ConditionAmount,
              @EndUserText.label: 'UoM'
              RequestedQuantityUnit,
              @EndUserText.label: 'Contract Qty'
              @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
              ContractQty,
              @EndUserText.label: 'Invoiced Qty'
              @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
              InvoicedQty,
              @EndUserText.label: 'Pending Qty'
              @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
              PendingQty,
              @EndUserText.label: 'Currency'
              @UI.hidden: true
              CreditSegmentCurrency,
              //              @EndUserText.label: 'Credit Limit'
              //              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTRACT'
              //  virtual     creditlimit         : abap.dec( 23, 2 ),
              @EndUserText.label: 'Customer Credit Limit'
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              EffectiveTotalCreditLimitAmt,
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              @EndUserText.label: 'Credit Limit Amount'
              CreditLimitAmt,
              @EndUserText.label: 'Reserve Value'
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              ReserveValue,
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              @EndUserText.label: 'Reserve Value'
              Reserve,
              //              @EndUserText.label: 'Dispatchable Balance'
              //              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTRACT'
              //  virtual     DispatchableBalance : abap.dec( 23, 2 ),
              DispatchableBalance,
              //              @UI.hidden: true
              //              @EndUserText.label: 'Dispatchable Balance'
              //              @Semantics.amount.currencyCode: 'TransactionCurrency'
              //              ,
              //              @EndUserText.label: 'Dispatchable Qty'
              //              @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
              //              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTRACT'
              //  virtual     DispatchableQty     : abap.dec( 23, 3 ),
              @EndUserText.label: 'Dispatchable Qty'
              @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
              // @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONTRACT'
              DispatchableQty,
              @EndUserText.label: 'Projected Value'
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              ProjectedValue,
              @EndUserText.label: 'Receivable'
              @Semantics.amount.currencyCode: 'TransactionCurrency'
              Receivable,
              @EndUserText.label: 'Sales Order Number'
              sales_order_no,
              @EndUserText.label: 'Gross Price Per Ton'
              GrossPricePerTon,
              @EndUserText.label: 'Payment Term Description' // ++ 11.09.25
              PAYMENTTERMSDESCRIPTION



}
