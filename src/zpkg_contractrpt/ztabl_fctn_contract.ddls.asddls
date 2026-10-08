@EndUserText.label: 'Table Function for Contract Report'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ztabl_FCTN_CONTRACT
//  with parameters
//    @Environment.systemField: #CLIENT
//    client : abap.clnt
returns
{
  key client : abap.clnt;
  key SalesContract : abap.char(10);
  key SalesContractItem : abap.numc(6);  
      SalesOrganization : abap.char(4);
      DistributionChannel : abap.char(4);
      OrganizationDivision : abap.char(4);
      Broker : abap.char(20);
      BrokerName : abap.char(50);
      SalesContractDate : abap.dats;
      SalesContractValidityEndDate : abap.dats;
      SoldToParty : kunnr;
      CustomerFullName : abap.char( 50 );
      TransactionCurrency : abap.cuky( 5 );
      ConditionValue : abap.dec( 23,2);
      ConditionAmount  : abap.dec( 23,2);
      RequestedQuantityUnit : meins ;
       @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      ContractQty : abap.dec( 23,3);
       @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      InvoicedQty : abap.dec( 23,3);
       @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      PendingQty : abap.dec( 23,3);
      CreditSegmentCurrency : abap.char(4);
      EffectiveTotalCreditLimitAmt  : abap.dec( 23,2);
      CreditLimitAmt : abap.dec( 23,2 );
      ReserveValue  : abap.dec( 23,2);
      Reserve :   abap.dec( 23,2);
      DispatchableBalance :   abap.dec( 23,2);
      DispatchableQty : abap.dec( 23,3);
      ProjectedValue :   abap.dec( 23,2);
      Receivable :   abap.dec( 23,2);
      sales_order_no : abap.char( 10 );
      GrossPricePerTon :   abap.dec( 23,2);
      PAYMENTTERMSDESCRIPTION : abap.char( 30 );       // ++ 11.09.25

}
implemented by method
  zcl_contract_data=>sort_data;