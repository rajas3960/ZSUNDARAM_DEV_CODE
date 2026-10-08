@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass:#MIXED
@Analytics.dataCategory: #CUBE
define root view entity ZI_PAYMENT_HEAD
  as select distinct from ZV_PAYMENT_HEAD as a
//    left outer join        zdt_payment_head    as c on  c.accountingdoc = a.Accountingdoc // zdt_pay_head
//                                               and c.fiscalyear    = a.Fiscalyear
//                                               and c.companycode   = a.Companycode
    left outer join       I_Supplier      as d on d.Supplier = a.Supplier
  composition [0..*] of zi_invoicE_item as _item
  composition [0..*] of ZI_APPR_LOG     as _item1
{
  key a.Accountingdoc as Accountingdoc,
  key a.Fiscalyear    as Fiscalyear,
  key a.Companycode   as Companycode,
      a.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      a.Supplier,
      d.SupplierName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      cast( ( case when a.PayeeBankKey like '%HDFC%' then 'Intra Bank Transfer' 
           when ( ( a.AmountInCompanyCodeCurrency * -1 ) > 200000 ) then 'RTGS' 
           when ( ( a.AmountInCompanyCodeCurrency * -1 ) <= 200000 and ( a.AmountInCompanyCodeCurrency * -1 ) >= 1 ) then 'NEFT' 
           when ( ( a.AmountInCompanyCodeCurrency ) > 200000 ) then 'RTGS' end )
           as abap.char(20) ) as PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      a.BankAccountNumber,
      a.PayeeBankAccount,
      a.PayeeBankKey,
      a.BankName,
      a.apprlevel,
      a.Appr1comment,
      a.Appr2comment,
      a.Status,
      case  when a.Status = 'In Approval'   then 2
           when a.Status = 'UTR Generated'   then 3
           when a.Status = 'Failed'   then 1
           when a.Status = 'Rejected' then 1
           when a.Status = 'Sent to Bank' then 2
           else 3 end as Criticality,
      a.Senton,
      a.Sentat,
      a.Sentby,
      a.PersonFullName,
      a.Utr,
      a.Message,
      a.Messagecode,
      a.Approved,
      a.Rejected,
      a.Inprocess,
      a.Appr1,
      a.Appr2,
      a.Appr3,
      a.Reject1,
      a.Reject2,
      a.Reject3,
      _item,
      _item1
}
where
  a.Supplier is not initial
