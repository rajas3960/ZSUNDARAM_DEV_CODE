@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_BANK_STAT_HEAD as select from zdt_payment_head as a
  left outer join       I_Supplier      as d on d.Supplier = a.supplier
  left outer join I_BusinessUserBasic as b on(
      b.UserID = a.sentby
    )
  
{
    key a.accountingdoc as Accountingdoc,
    key a.fiscalyear as Fiscalyear,
    key a.companycode as Companycode,
    a.paymentrunid as Paymentrunid,
    a.documentdate as Documentdate,
    a.postingdate as Postingdate,
    a.supplier as Supplier,
    d.SupplierName,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    a.amountincompanycodecurrency as Amountincompanycodecurrency,
    a.companycodecurrency as Companycodecurrency,
    a.paymentmethod as Paymentmethod,
    a.housebank as Housebank,
    a.housebankaccount as Housebankaccount,
    a.bankaccountnumber as Bankaccountnumber,
    a.payeebankaccount as Payeebankaccount,
    a.payeebankkey as Payeebankkey,
    a.bankname as BankName,
    a.apprlevel as Apprlevel,
    a.appr1comment as Appr1comment,
    a.appr2comment as Appr2comment,
    a.status as Status,
    case  when a.status = 'In Approval'   then 2
           when a.status = 'UTR Generated'   then 3
           when a.status = 'Failed'   then 1
           when a.status = 'Rejected' then 1
           when a.status = 'Sent to Bank' then 2
           else 3 end as Criticality,
    a.senton as Senton,
    a.sentat as Sentat,
    a.sentby as Sentby,
    b.PersonFullName,
    a.utr as Utr,
    a.message as Message,
    a.messagecode as Messagecode,
    a.approved as Approved,
    a.rejected as Rejected,
    a.inprocess as Inprocess,
    a.appr1 as Appr1,
    a.appr2 as Appr2,
    a.appr3 as Appr3,
    a.reject1 as Reject1,
    a.reject2 as Reject2,
    a.reject3 as Reject3
}
where a.fiscalyear >= '2025'
and a.postingdate >= '20250911'
and a.housebank like 'HDF%'

union all select from ZV_BANK_STAT_HEAD_L1 as a
left outer join       I_Supplier      as d on d.Supplier = a.Supplier
left outer join I_BusinessUserBasic as b on(
      b.UserID = a.Sentby
    )
{
  key a.Accountingdoc,
  key a.Fiscalyear         as Fiscalyear,
  key a.Companycode        as Companycode,
      a.PaymentRunID as Paymentrunid,
      a.DocumentDate as Documentdate,
      a.PostingDate as Postingdate,
      a.Supplier,
      d.SupplierName,
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      a.BankAccountNumber,
      a.PayeeBankAccount,
      a.PayeeBankKey,
      a.bankname as BankName,
      a.apprlevel,
      a.Appr1comment       as Appr1comment,
      a.Appr2comment       as Appr2comment,
      cast ( 'In Approval' as abap.char(20) ) as Status,
      2 as Criticality,
      a.Senton             as Senton,
      a.Sentat             as Sentat,
      a.Sentby             as Sentby,
      b.PersonFullName,
      a.Utr                as Utr,
      a.Message            as Message,
      a.Messagecode        as Messagecode,
      a.Approved           as Approved,
      a.Rejected           as Rejected,
      a.Inprocess          as Inprocess,
      a.Appr1              as Appr1,
      a.Appr2              as Appr2,
      a.Appr3              as Appr3,
      a.Reject1            as Reject1,
      a.Reject2            as Reject2,
      a.Reject3            as Reject3

}
where
  (
    a.accdoc  = 'Y' and a.PayeeBankKey <> '' 
    and ( a.AccountingDocumentType = 'ZP' or a.AccountingDocumentType = 'KZ' )
    and a.Fiscalyear >= '2025'
    and a.PostingDate >= '20250911'
    and a.HouseBank like 'HDF%'
  )
