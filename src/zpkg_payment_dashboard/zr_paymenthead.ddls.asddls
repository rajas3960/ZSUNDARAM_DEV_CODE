@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PAYMENTHEAD
  as select from zdt_payment_head
{
  key accountingdoc               as Accountingdoc,
  key fiscalyear                  as Fiscalyear,
  key companycode                 as Companycode,
      paymentrunid                as Paymentrunid,
      documentdate                as Documentdate,
      postingdate                 as Postingdate,
      supplier                    as Supplier,
      suppliername                as Suppliername,
      @Semantics.amount.currencyCode : 'companycodecurrency'
      amountincompanycodecurrency as Amountincompanycodecurrency,
      companycodecurrency         as Companycodecurrency,
      paymentmethod               as Paymentmethod,
      housebank                   as Housebank,
      housebankaccount            as Housebankaccount,
      bankaccountnumber           as Bankaccountnumber,
      payeebankaccount            as Payeebankaccount,
      payeebankkey                as Payeebankkey,
      apprlevel                   as Apprlevel,
      appr1comment                as Appr1comment,
      appr2comment                as Appr2comment,
      status                      as Status,
      criticality                 as Criticality,
      senton                      as Senton,
      sentat                      as Sentat,
      sentby                      as Sentby,
      utr                         as Utr,
      message                     as Message,
      messagecode                 as Messagecode,
      approved                    as Approved,
      rejected                    as Rejected,
      inprocess                   as Inprocess,
      appr1                       as Appr1,
      appr2                       as Appr2,
      appr3                       as Appr3,
      reject1                     as Reject1,
      reject2                     as Reject2,
      reject3                     as Reject3
}
