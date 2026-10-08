@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PAYADV_HEAD
  as select from    zdt_payment_head          as a
    left outer join I_Supplier                as b on(
      b.Supplier = a.supplier
    )
    left outer join I_JournalEntryItem        as c on(
      c.AccountingDocument = a.accountingdoc
      and c.FiscalYear     = a.fiscalyear
      and c.CompanyCode    = a.companycode
    )
    left outer join I_HouseBankAccountLinkage as d on(
      d.HouseBank            = a.housebank
      and d.HouseBankAccount = a.housebankaccount
      and d.CompanyCode      = a.companycode
    )
  composition [0..*] of ZI_PAYADV_ITEM as _item
{
  key a.accountingdoc               as Accountingdoc,
  key a.fiscalyear                  as Fiscalyear,
  key a.companycode                 as Companycode,
      a.paymentrunid                as Paymentrunid,
      a.documentdate                as Documentdate,
      a.postingdate                 as Postingdate,
      c.ValueDate,
      a.supplier                    as Supplier,
      a.suppliername,
      b.StreetName,
      b.CityName,
      b.DistrictName,
      b.PhoneNumber1,
      b.TaxNumber3,
      cast( ''  as abap.char(40))   as Email,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.amountincompanycodecurrency as Amountincompanycodecurrency,
      a.companycodecurrency         as Companycodecurrency,
      a.paymentmethod               as Paymentmethod,
      a.housebank                   as Housebank,
      a.housebankaccount            as Housebankaccount,
      d.BankName,
      a.bankaccountnumber           as Bankaccountnumber,
      a.payeebankaccount            as Payeebankaccount, //Bene Acc
      a.payeebankkey                as Payeebankkey, //Bene IFSC
      a.status                      as Status,
      a.utr                         as Utr,
      _item
}
where
      a.status    <> 'In Approval'
  and c.Ledger    =  '0L'
  and c.Supplier  is initial
  and c.HouseBank is not initial
