@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_CONTRACTRPT_V10
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
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      oad.AmountInFunctionalCurrency as AmountInFunctionalCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      oad.NetPaymentAbsoluteAmount as AmountInFunctionalCurrency_H,
      //oad.AmountInFunctionalCurrency as AmountInFunctionalCurrency_H,
      j.IsReversal,
      j.IsReversed,
      oad.DebitCreditCode,
      oad.BusinessPlace
}
where
      j.IsReversal        != 'X'
  and j.IsReversed        != 'X'
  and oad.DebitCreditCode =  'H'
  //  and oad.DebitCreditCode =  'S'
  and oad.BusinessPlace   is initial

//group by
//  a.SalesContract,
//  a.SalesContractItem,
//  oad.CompanyCode,
//  //  oad.AssignmentReference,
//  //  oad.DocumentItemText,
//  oad.TransactionCurrency,
//  oad.NetPaymentAbsoluteAmount,
// // oad.AmountInFunctionalCurrency,
//  j.IsReversal,
//  j.IsReversed,
//  oad.DebitCreditCode,
//oad.BusinessPlace
