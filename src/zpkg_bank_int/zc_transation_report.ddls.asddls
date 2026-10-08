@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Consumption View For Transation Report'
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_TRANSATION_REPORT
  provider contract transactional_query
  as projection on ZI_TRANSATION_REPORT
{

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Transation ID'
  key Transactionid,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'UTR'
  key Utr,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Remitter Name'
      Remittername,
      @EndUserText.label: 'From Acount Name'
      Fromaccountnumber,
      @EndUserText.label: 'From Bank Name'
      Frombankname,
      @EndUserText.label: 'Remitter IFSC'
      Remitterifsc,
      @EndUserText.label: 'Virtual Account Number'
      Virtualaccount,
      @Semantics.amount.currencyCode: 'WAERS'
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'MMID'
      Mmid,
      @EndUserText.label: 'Value Date'
      Valuedate,
      @EndUserText.label: 'Transfer Mode'
      Transfermode,
      @EndUserText.label: 'Credit Date'
      Creditdate,
      @EndUserText.label: 'Credit Time'
      Credittime,
      @EndUserText.label: 'Cheque No'
      Chequeno,
      @EndUserText.label: 'Narration'
      Narration,
      @EndUserText.label: 'Accounting Document'
      @Search.defaultSearchElement: true
      Accountingdoc,
      @EndUserText.label: 'Company Code'
      @Search.defaultSearchElement: true
      Companycode,
      @EndUserText.label: 'Fiscal Year'
      @Search.defaultSearchElement: true
      Fiscalyear,
      @EndUserText.label: 'Waers'
      Waers,
      @EndUserText.label: 'Status'
      @Search.defaultSearchElement: true
      Status,
      @EndUserText.label: 'Created On'
      Createdon,
      @EndUserText.label: 'Created At'
      Createdat,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'Error Count'
      error_count,
      @EndUserText.label: 'Progress'
      Progress,
      @EndUserText.label: 'Total'
      Total,
      @EndUserText.label: 'Post'
      Post,
      @EndUserText.label: 'Mail Sent'
      mailsent,
      @EndUserText.label: 'Mail Sent At'
      mailsentat,
      @EndUserText.label: 'Mail Sent On'
      mailsenton,
      /* Associations */
      _Item : redirected to composition child ZC_ERROR_ITEM
}
