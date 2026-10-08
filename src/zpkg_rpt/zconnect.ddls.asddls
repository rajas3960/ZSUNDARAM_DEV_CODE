@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'connection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zconnect
  as select from    I_SalesContractItem       as a
    left outer join I_OperationalAcctgDocItem as oad on  oad.SalesDocument     = a.SalesContract
                                                     and oad.SalesDocumentItem = a.SalesContractItem
    inner join      I_JournalEntry            as j   on  j.AccountingDocument = oad.AccountingDocument
                                                     and j.CompanyCode        = oad.CompanyCode
{

  key a.SalesContract,
  key a.SalesContractItem,
      oad.CompanyCode,
      oad.AssignmentReference,
      oad.DocumentItemText,
      oad.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      oad.AmountInFunctionalCurrency,
      j.IsReversal,
      j.IsReversed,
      oad.DebitCreditCode
}
where
      j.IsReversal        != 'X'
  and j.IsReversed        != 'X'
  and oad.DebitCreditCode =  'H'
