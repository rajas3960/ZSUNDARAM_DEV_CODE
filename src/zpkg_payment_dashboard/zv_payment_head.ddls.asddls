@AbapCatalog.sqlViewName: 'ZVPAYMENTHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass:#MIXED
@Analytics.dataCategory: #CUBE
define view ZV_PAYMENT_HEAD
  as select from    ZV_PAYMENT_HEAD_L1  as a
    left outer join I_BusinessUserBasic as b on(
      b.UserID = a.Sentby
    )
{
  key a.Accountingdoc,
  key a.Fiscalyear                            as Fiscalyear,
  key a.Companycode                           as Companycode,
      a.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      a.BankAccountNumber,
      a.PayeeBankAccount,
      a.PayeeBankKey,
      a.BankName,
      a.apprlevel,
      a.Appr1comment                          as Appr1comment,
      a.Appr2comment                          as Appr2comment,
      cast ( 'In Approval' as abap.char(20) ) as Status,
      a.Senton                                as Senton,
      a.Sentat                                as Sentat,
      a.Sentby                                as Sentby,
      b.PersonFullName,
      a.Utr                                   as Utr,
      a.Message                               as Message,
      a.Messagecode                           as Messagecode,
      a.Approved                              as Approved,
      a.Rejected                              as Rejected,
      a.Inprocess                             as Inprocess,
      a.Appr1                                 as Appr1,
      a.Appr2                                 as Appr2,
      a.Appr3                                 as Appr3,
      a.Reject1                               as Reject1,
      a.Reject2                               as Reject2,
      a.Reject3                               as Reject3

}
where
  (
        a.accdoc       =  'Y'
    and a.PayeeBankKey <> ''
    and a.PostingDate >= '20250911'
    and a.HouseBank like 'HDF%'
  )

////union all select distinct from zdt_payment_head    as c
////  inner join                   ztmg_appr_matrix    as b  on  b.companycode = c.companycode
////                                                         and b.userid      = $session.user
////                                                         and b.apprlevel   = '2'
////                                                         and b.final       = 'X'
////  inner join                   ZV_PAYMENT_HEAD_L2  as a  on  a.AccountingDocument = c.accountingdoc
////                                                         and a.FiscalYear         = c.fiscalyear
////                                                         and a.CompanyCode        = c.companycode
////  left outer join              ZI_APPR_LOG         as d  on(
////     d.accountingdoc   = a.AccountingDocument
////     and d.Fiscalyear  = a.FiscalYear
////     and d.Companycode = a.CompanyCode
////     and d.Apprlevel   = '1'
////   )
////  left outer join              I_BusinessUserBasic as b1 on(
////    b1.UserID = d.Actionedby
////  )
////{
////  key a.AccountingDocument                as Accountingdoc,
////  key a.FiscalYear                        as Fiscalyear,
////  key a.CompanyCode                       as Companycode,
////      c.paymentrunid                      as PaymentRunID,
////      a.DocumentDate,
////      a.PostingDate,
////      a.AmountInCompanyCodeCurrency       as AmountInCompanyCodeCurrency,
////      a.CompanyCodeCurrency,
////      c.supplier,
////      a.PaymentMethod,
////      a.HouseBank,
////      a.HouseBankAccount,
////      c.bankaccountnumber                 as BankAccountNumber,
////      c.payeebankaccount                  as PayeeBankAccount,
////      c.payeebankkey                      as PayeeBankKey,
////      c.bankname                          as BankName,
////      cast( c.apprlevel as abap.numc(1) ) as apprlevel,
////      c.appr1comment                      as Appr1comment,
////      c.appr2comment                      as Appr2comment,
////      c.status                            as Status,
////      d.Actionedon                        as Senton,
////      d.Actionedat                        as Sentat,
////      d.Actionedby                        as Sentby,
////      b1.PersonFullName,
////      c.utr                               as Utr,
////      c.message                           as Message,
////      c.messagecode                       as Messagecode,
////      cast( c.approved as abap.char(1) )  as Approved,
////      cast( c.rejected as abap.char(1) )  as Rejected,
////      cast( c.inprocess as abap.char(1) ) as Inprocess,
////      c.appr1                             as Appr1,
////      c.appr2                             as Appr2,
////      c.appr3                             as Appr3,
////      c.reject1                           as Reject1,
////      c.reject2                           as Reject2,
////      c.reject3                           as Reject3
////}
////where
////  (
////        a.AccountingDocumentType =  'KZ'
////  )
////  and(
////        c.appr1                  is not initial
////    and c.appr2                  is initial
////  )
////  and(
////        c.inprocess              =  'X'
////  )
////  and(
////        c.rejected               <> 'X'
////    and c.approved               <> 'X'
////  )
////  and(
////        c.payeebankkey           <> ''
////  )
////  and ( a.PostingDate >= '20250911' )
////  and a.HouseBank like 'HDF%'
//  group by a.AccountingDocument,a.FiscalYear,a.CompanyCode,c.paymentrunid,a.DocumentDate,a.PostingDate,a.CompanyCodeCurrency,
//      c.supplier,
//      a.PaymentMethod,
//      a.HouseBank,
//      a.HouseBankAccount,
//      c.bankaccountnumber,c.apprlevel,c.appr1comment,c.appr2comment,c.status,c.senton,c.sentat,c.sentby,c.utr,c.message,
//      c.messagecode,c.approved,c.rejected,c.inprocess,c.appr1,c.appr2,c.appr3,c.reject1,c.reject2,c.reject3,c.accountingdoc,
//      c.payeebankaccount,c.payeebankkey

//union all
//select distinct from I_OperationalAcctgDocItem as a
//  inner join         ztmg_appr_matrix          as b on  a.CompanyCode = b.companycode
//                                                    and b.userid      = $session.user
//                                                    and b.apprlevel   = '2'
//                                                    and b.final       = 'X'
//  left outer join    I_PaymentProposalPayment  as d on  d.PaymentDocument      = a.AccountingDocument
//                                                    and d.PayingCompanyCode    = a.CompanyCode
//                                                    and d.FinancialAccountType = 'K'
//  left outer join    zdt_payment_head          as c on  c.accountingdoc = a.AccountingDocument
//                                                    and c.fiscalyear    = a.FiscalYear
//                                                    and c.companycode   = a.CompanyCode
//  left outer join    I_HouseBankAccountLinkage as e on(
//    e.CompanyCode          = a.CompanyCode
//    and e.HouseBank        = a.HouseBank
//    and e.HouseBankAccount = a.HouseBankAccount
//  )
//
//{
//  key a.AccountingDocument as Accountingdoc,
//  key a.FiscalYear         as Fiscalyear,
//  key a.CompanyCode        as Companycode,
//
//      d.PaymentRunID,
//      a.DocumentDate,
//      a.PostingDate,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      a.AmountInCompanyCodeCurrency,
//      a.CompanyCodeCurrency,
//      a.Supplier,
//      a.PaymentMethod,
//      a.HouseBank,
//      a.HouseBankAccount,
//      e.BankAccountNumber,
//      d.PayeeBankAccount,
//      d.PayeeBankKey,
//      c.apprlevel,
//      c.appr1comment       as Appr1comment,
//      c.appr2comment       as Appr2comment,
//      c.status             as Status,
//      c.senton             as Senton,
//      c.sentat             as Sentat,
//      c.sentby             as Sentby,
//      c.utr                as Utr,
//      c.message            as Message,
//      c.messagecode        as Messagecode,
//      c.approved           as Approved,
//      c.rejected           as Rejected,
//      c.inprocess          as Inprocess,
//      c.appr1              as Appr1,
//      c.appr2              as Appr2,
//      c.appr3              as Appr3,
//      c.reject1            as Reject1,
//      c.reject2            as Reject2,
//      c.reject3            as Reject3
//}
//where
//          c.appr1  is not initial and c.appr2 is initial
//  and(
//          ( a.AccountingDocumentType = 'KZ' )
//    and   a.Supplier               is not initial
//    and   c.inprocess              =  'X'
//    and(
//          c.rejected               <> 'X'
//      and c.approved               <> 'X'
//    )
//  )

//union all
//
//select distinct from I_OperationalAcctgDocItem as a
//  inner join         ztmg_appr_matrix          as b on  a.CompanyCode = b.companycode
//                                                    and b.userid      = $session.user
//                                                    and b.apprlevel   = '3'
//  left outer join    I_PaymentProposalPayment  as d on  d.PaymentDocument      = a.AccountingDocument
//                                                    and d.PayingCompanyCode    = a.CompanyCode
//                                                    and d.FinancialAccountType = 'K'
//  left outer join    zdt_payment_head          as c on  c.accountingdoc = a.AccountingDocument
//                                                    and c.fiscalyear    = a.FiscalYear
//                                                    and c.companycode   = a.CompanyCode
//  left outer join    I_HouseBankAccountLinkage as e on(
//    e.CompanyCode          = a.CompanyCode
//    and e.HouseBank        = a.HouseBank
//    and e.HouseBankAccount = a.HouseBankAccount
//  )
//
//{
//  key a.AccountingDocument as Accountingdoc,
//  key a.FiscalYear         as Fiscalyear,
//  key a.CompanyCode        as Companycode,
//
//      d.PaymentRunID,
//      a.DocumentDate,
//      a.PostingDate,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      a.AmountInCompanyCodeCurrency,
//      a.CompanyCodeCurrency,
//      a.Supplier,
//      a.PaymentMethod,
//      a.HouseBank,
//      a.HouseBankAccount,
//      e.BankAccountNumber,
//      d.PayeeBankAccount,
//      d.PayeeBankKey,
//      c.apprlevel          as Apprlevel,
//      c.appr1comment       as Appr1comment,
//      c.appr2comment       as Appr2comment,
//      c.status             as Status,
//      c.senton             as Senton,
//      c.sentat             as Sentat,
//      c.sentby             as Sentby,
//      c.utr                as Utr,
//      c.message            as Message,
//      c.messagecode        as Messagecode,
//      c.approved           as Approved,
//      c.rejected           as Rejected,
//      c.inprocess          as Inprocess,
//      c.appr1              as Appr1,
//      c.appr2              as Appr2,
//      c.appr3              as Appr3,
//      c.reject1            as Reject1,
//      c.reject2            as Reject2,
//      c.reject3            as Reject3
//}
//where
//          c.appr1                  is not initial
//  and     c.appr2                  is not initial
//  and     c.appr3                  is initial
//  and(
//          ( a.AccountingDocumentType = 'ZP' or a.AccountingDocumentType = 'KZ' )
//    and   a.Supplier               is not initial
//    and   c.inprocess              =  'X'
//    and(
//          c.rejected               <> 'X'
//      and c.approved               <> 'X'
//    )
//  )
