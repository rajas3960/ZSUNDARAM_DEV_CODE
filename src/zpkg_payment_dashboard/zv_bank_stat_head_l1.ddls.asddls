@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Header Level 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass:#MIXED
@Analytics.dataCategory: #CUBE
define view entity ZV_BANK_STAT_HEAD_L1
  as select distinct from ZV_PAYMENT_HEAD_L2        as a
    inner join            ZV_PAYMENT_HEAD_L3        as a1 on(
      a1.AccountingDocument = a.AccountingDocument
      and a1.FiscalYear     = a.FiscalYear
      and a1.CompanyCode    = a.CompanyCode
    )
    left outer join       I_PaymentProposalPayment  as d  on  d.PaymentDocument      = a.AccountingDocument
                                                          and d.PayingCompanyCode    = a.CompanyCode
                                                          and d.FinancialAccountType = 'K'
    left outer join       zdt_payment_head          as c  on  c.accountingdoc = a.AccountingDocument
                                                          and c.fiscalyear    = a.FiscalYear
                                                          and c.companycode   = a.CompanyCode
    left outer join       I_HouseBankAccountLinkage as e  on(
       e.CompanyCode          = a.CompanyCode
       and e.HouseBank        = a.HouseBank
       and e.HouseBankAccount = a.HouseBankAccount
     )

{
  key a.AccountingDocument                                           as Accountingdoc,
  key a.FiscalYear                                                   as Fiscalyear,
  key a.CompanyCode                                                  as Companycode,
      d.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( a.AmountInCompanyCodeCurrency )                           as AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a1.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      e.BankAccountNumber,
      cast( c.apprlevel as abap.numc(1) )                            as apprlevel,
      c.appr1comment                                                 as Appr1comment,
      c.appr2comment                                                 as Appr2comment,
      c.status                                                       as Status,
      tstmp_to_dats( a1.timestamp,'INDIA',$session.client,'NULL' )   as Senton,
      tstmp_to_tims( a1.timestamp,'INDIA',$session.client,'NULL' )   as Sentat,
      a1.AccountingDocCreatedByUser                                  as Sentby,
      c.utr                                                          as Utr,
      c.message                                                      as Message,
      c.messagecode                                                  as Messagecode,
      cast( c.approved as abap.char(1) )                             as Approved,
      cast( c.rejected as abap.char(1) )                             as Rejected,
      cast( c.inprocess as abap.char(1) )                            as Inprocess,
      c.appr1                                                        as Appr1,
      c.appr2                                                        as Appr2,
      c.appr3                                                        as Appr3,
      c.reject1                                                      as Reject1,
      c.reject2                                                      as Reject2,
      c.reject3                                                      as Reject3,
      case when c.accountingdoc is not initial then 'X' else 'Y' end as accdoc,
      d.PayeeBankAccount,
      d.PayeeBankKey,
      c.bankname,
      a.AccountingDocumentType
}
where
  (
    a.AccountingDocumentType = 'ZP'
  )
group by
  a.AccountingDocument,
  a.FiscalYear,
  a.CompanyCode,
  d.PaymentRunID,
  a.DocumentDate,
  a.PostingDate,
  a.CompanyCodeCurrency,
  a1.Supplier,
  a.PaymentMethod,
  a.HouseBank,
  a.HouseBankAccount,
  e.BankAccountNumber,
  c.apprlevel,
  c.appr1comment,
  c.appr2comment,
  c.status,
  a1.timestamp,
  a1.AccountingDocCreatedByUser,
  c.utr,
  c.message,
  c.messagecode,
  c.approved,
  c.rejected,
  c.inprocess,
  c.appr1,
  c.appr2,
  c.appr3,
  c.reject1,
  c.reject2,
  c.reject3,
  c.accountingdoc,
  d.PayeeBankAccount,
  d.PayeeBankKey,
  c.bankname,
  a.AccountingDocumentType

union all select distinct from ZV_PAYMENT_HEAD_L2        as a
  inner join                   ZV_PAYMENT_HEAD_L3        as a1 on(
    a1.AccountingDocument = a.AccountingDocument
    and a1.FiscalYear     = a.FiscalYear
    and a1.CompanyCode    = a.CompanyCode
  )
  left outer join              I_BusinessPartnerBank     as d  on  d.BusinessPartner    = a1.Supplier
                                                               and d.BankCountryKey     = 'IN'
                                                               and d.BankIdentification = '0001'
  left outer join              zdt_payment_head          as c  on  c.accountingdoc = a.AccountingDocument
                                                               and c.fiscalyear    = a.FiscalYear
                                                               and c.companycode   = a.CompanyCode
  left outer join              I_HouseBankAccountLinkage as e  on(
     e.CompanyCode          = a.CompanyCode
     and e.HouseBank        = a.HouseBank
     and e.HouseBankAccount = a.HouseBankAccount
   )
   left outer join       I_BusinessPartnerBank     as f  on  f.BusinessPartner = a1.Supplier
                                                          and f.BankCountryKey  = 'IN'
                                                          and f.BankNumber      = d.BankNumber

{
  key a.AccountingDocument                                           as Accountingdoc,
  key a.FiscalYear                                                   as Fiscalyear,
  key a.CompanyCode                                                  as Companycode,
      cast( '' as abap.char(6) )                                     as PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      sum( a.AmountInCompanyCodeCurrency )                           as AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a1.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      e.BankAccountNumber,
      cast( c.apprlevel as abap.numc(1) )                            as apprlevel,
      c.appr1comment                                                 as Appr1comment,
      c.appr2comment                                                 as Appr2comment,
      c.status                                                       as Status,
      tstmp_to_dats( a1.timestamp,'INDIA',$session.client,'NULL' )   as Senton,
      tstmp_to_tims( a1.timestamp,'INDIA',$session.client,'NULL' )   as Sentat,
      a1.AccountingDocCreatedByUser                                  as Sentby,
      c.utr                                                          as Utr,
      c.message                                                      as Message,
      c.messagecode                                                  as Messagecode,
      cast( c.approved as abap.char(1) )                             as Approved,
      cast( c.rejected as abap.char(1) )                             as Rejected,
      cast( c.inprocess as abap.char(1) )                            as Inprocess,
      c.appr1                                                        as Appr1,
      c.appr2                                                        as Appr2,
      c.appr3                                                        as Appr3,
      c.reject1                                                      as Reject1,
      c.reject2                                                      as Reject2,
      c.reject3                                                      as Reject3,
      case when c.accountingdoc is not initial then 'X' else 'Y' end as accdoc,
      d.BankAccount                                                  as PayeeBankAccount,
      d.BankNumber                                                   as PayeeBankKey,
      case when d.BankName <> '' then d.BankName else c.bankname end as bankname,
      a.AccountingDocumentType
}
where
  (
    a.AccountingDocumentType = 'KZ'
  )
group by
  a.AccountingDocument,
  a.FiscalYear,
  a.CompanyCode,
  a.DocumentDate,
  a.PostingDate,
  a.CompanyCodeCurrency,
  a1.Supplier,
  a.PaymentMethod,
  a.HouseBank,
  a.HouseBankAccount,
  e.BankAccountNumber,
  c.apprlevel,
  c.appr1comment,
  c.appr2comment,
  c.status,
  a1.timestamp,
  a1.AccountingDocCreatedByUser,
  c.utr,
  c.message,
  c.messagecode,
  c.approved,
  c.rejected,
  c.inprocess,
  c.appr1,
  c.appr2,
  c.appr3,
  c.reject1,
  c.reject2,
  c.reject3,
  c.accountingdoc,
  d.BankAccount,
  d.BankNumber,
  c.bankname,
  d.BankName,
  a.AccountingDocumentType
