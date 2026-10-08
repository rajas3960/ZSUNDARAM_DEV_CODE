@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Input Register 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREGN_2
  as select from    ZR_INPUTREGN_1            as a
    inner join      I_JournalEntry            as c on  a.CompanyCode        = c.CompanyCode
                                                   and a.FiscalYear         = c.FiscalYear
                                                   and a.AccountingDocument = c.AccountingDocument
                                                   and c.IsReversed         = ''
                                                   and c.IsReversal         = ''
    inner join      I_OperationalAcctgDocItem as b on  a.CompanyCode        = b.CompanyCode
                                                   and a.FiscalYear         = b.FiscalYear
                                                   and a.AccountingDocument = b.AccountingDocument
    left outer join ZR_HousebankText          as d on b.HouseBank = d.HouseBank

{
  key  a.CompanyCode,
  key  c.AccountingDocumentType,
  key  a.FiscalYear,
  key  a.AccountingDocument,
  key  b.AccountingDocumentItem,
       b.AccountingDocumentItemType,
       b.GLAccount,
       b.IN_GSTPartner,
       b.IN_HSNOrSACCode,
       b.Material,
       b.IN_GSTPlaceOfSupply,
       b.Plant,
       b.Product,
       b.ProfitCenter,
       b.CostCenter,
       b.CostElement,
       b.PurchasingDocument,
       b.PurchasingDocumentItem,
       b.TaxItemAcctgDocItemRef,
       b.TransactionCurrency,
       b.CompanyCodeCurrency,
       b.TaxCode,
       b.TransactionTypeDetermination,
       b.ValuationArea,
       b.DebitCreditCode,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       b.TaxBaseAmountInCoCodeCrcy,
       //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       //       cast(b.AmountInTransactionCurrency  as abap.curr( 23,2 ) )           as AmountInTransactionCurrency,
       cast(b.AmountInCompanyCodeCurrency  as abap.dec( 23,2 ) )            as AmountInTransactionCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       b.AmountInCompanyCodeCurrency,
       cast( b.Quantity     as abap.dec(13,3) )                             as Quantity,
       case c.AccountingDocumentType
             when 'RE' then substring(c.OriginalReferenceDocument,1,10) end as Invoiceno,

       case c.AccountingDocumentType
             when 'RE' then substring(c.OriginalReferenceDocument,11,4) end as Invoicenoyr,
       b.DocumentDate,
       //       c.AccountingDocumentCreationDate                                     as creationdate,
       c.PostingDate                                                        as creationdate,
       c.DocumentReferenceID,
       substring(b.TaxCode,1,1)                                             as taxchar1,
       b.BusinessPlace,
       b.HouseBank,
       case when c.AccountingDocumentType = 'SA' and d.HouseBank is not null
                then d.BankName else null end                               as Housebankname

}

//where
//      b.IsBalanceSheetAccount      = ''
//  and b.AccountingDocumentItemType = ''
