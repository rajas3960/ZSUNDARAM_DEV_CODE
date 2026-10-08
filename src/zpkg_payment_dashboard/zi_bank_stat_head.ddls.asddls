@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_bank_stat_head as select from ZV_BANK_STAT_HEAD as a
  composition [0..*] of ZI_bank_stat_item as _item
  composition [0..*] of ZI_bank_stat_log  as _item1
{
    key a.Accountingdoc as Accountingdoc,
    key a.Fiscalyear as Fiscalyear,
    key a.Companycode as Companycode,
    a.Paymentrunid as Paymentrunid,
    a.Documentdate as Documentdate,
    a.Postingdate as Postingdate,
    a.Supplier as Supplier,
    a.SupplierName,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    a.Amountincompanycodecurrency as Amountincompanycodecurrency,
    a.Companycodecurrency as Companycodecurrency,
    cast( ( case when a.Payeebankkey like '%HDFC%' then 'Intra Bank Transfer' 
           when ( ( a.Amountincompanycodecurrency * -1 ) > 200000 ) then 'RTGS' 
           when ( ( a.Amountincompanycodecurrency * -1 ) <= 200000 and ( a.Amountincompanycodecurrency * -1 ) >= 1 ) then 'NEFT' 
           when ( ( a.Amountincompanycodecurrency ) > 200000 ) then 'RTGS' end )
           as abap.char(20) ) as PaymentMethod,
    a.Housebank as Housebank,
    a.Housebankaccount as Housebankaccount,
    a.Bankaccountnumber as Bankaccountnumber,
    a.Payeebankaccount as Payeebankaccount,
    a.Payeebankkey as Payeebankkey,
    a.BankName,
    a.Apprlevel as Apprlevel,
    a.Appr1comment as Appr1comment,
    a.Appr2comment as Appr2comment,
    a.Status as Status,
    case  when a.Status = 'In Approval'   then 2
           when a.Status = 'UTR Generated'   then 3
           when a.Status = 'Failed'   then 1
           when a.Status = 'Rejected' then 1
           when a.Status = 'Sent to Bank' then 2
           else 3 end as Criticality,
    a.Senton as Senton,
    a.Sentat as Sentat,
    a.Sentby as Sentby,
    a.PersonFullName,
    a.Utr as Utr,
    a.Message as Message,
    a.Messagecode as Messagecode,
    a.Approved as Approved,
    a.Rejected as Rejected,
    a.Inprocess as Inprocess,
    a.Appr1 as Appr1,
    a.Appr2 as Appr2,
    a.Appr3 as Appr3,
    a.Reject1 as Reject1,
    a.Reject2 as Reject2,
    a.Reject3 as Reject3,
      _item,
      _item1
}
where a.Status <> ''
