@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZV_CONTRACTRPT_V12
  as select from    I_SalesContractItem       as a
    left outer join I_OperationalAcctgDocItem as oad on  oad.SalesDocument     = a.SalesContract
                                                     and oad.SalesDocumentItem = a.SalesContractItem
    inner join      I_JournalEntry            as j   on  j.AccountingDocument = oad.AccountingDocument
                                                     and j.CompanyCode        = oad.CompanyCode
{

  key a.SalesContract,
  key a.SalesContractItem,
      oad.CompanyCode, 
      //      oad.AssignmentReference,
      //      oad.DocumentItemText,
      oad.TransactionCurrency,
      //@Semantics.amount.currencyCode: 'TransactionCurrency'
      //      sum(oad.AmountInFunctionalCurrency) as AmountInFunctionalCurrency,

      //      case when sum(oad.NetPaymentAbsoluteAmount) > 0 then
      //       sum(oad.NetPaymentAbsoluteAmount) * (-1) else sum(oad.NetPaymentAbsoluteAmount)  end as AmountInFunctionalCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //sum(oad.NetPaymentAbsoluteAmount) as NetPaymentAbsoluteAmount,
      //oad.NetPaymentAbsoluteAmount,

      //            case when sum(oad.NetPaymentAbsoluteAmount) > 0 then
      //             sum(oad.NetPaymentAbsoluteAmount) * (-1) else sum(oad.NetPaymentAbsoluteAmount)  end as AmountInFunctionalCurrency_s,  //update

      //      case when sum(oad.AmountInFunctionalCurrency) > 0 then
      //         sum(oad.AmountInFunctionalCurrency) * (-1) else sum(oad.AmountInFunctionalCurrency)  end as AmountInFunctionalCurrency_s,
      case when oad.DebitCreditCode =  'S' then oad.AmountInFunctionalCurrency * (-1)
      else  oad.AmountInFunctionalCurrency * (-1) end as AmountInFunctionalCurrency_s,

      //      case
      //        when oad.BusinessPlace is initial
      //          then cast( 0 as abap.curr( 15, 2 ) )
      //        when sum( oad.NetPaymentAbsoluteAmount ) > 0
      //          then sum( oad.NetPaymentAbsoluteAmount ) * ( -1 )
      //        else
      //          sum( oad.NetPaymentAbsoluteAmount )
      //      end                                                                                   as AmountInFunctionalCurrency_s,
      j.IsReversal,
      j.IsReversed,
          oad.DebitCreditCode
      //  oad.BusinessPlace
}
where
      j.IsReversal      != 'X'
  and j.IsReversed      != 'X'
  //and oad.DebitCreditCode =  'S'
  and oad.BusinessPlace is not initial

//group by
//  a.SalesContract,
//  a.SalesContractItem,
//  oad.CompanyCode,
//  //  oad.AssignmentReference,
//  //  oad.DocumentItemText,
//  oad.TransactionCurrency,
//  //oad.NetPaymentAbsoluteAmount,
//  oad.AmountInFunctionalCurrency,
//  j.IsReversal,
//  j.IsReversed,
// oad.DebitCreditCode
//oad.BusinessPlace
