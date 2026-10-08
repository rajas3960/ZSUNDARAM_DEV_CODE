@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Item View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_ITEM
  as select from    I_OperationalAcctgDocItem                      as a
    inner join      I_JournalEntry                                 as b on(
      b.AccountingDocument = a.ClearingJournalEntry
      and b.FiscalYear     = a.ClearingJournalEntryFiscalYear
      and b.CompanyCode    = a.CompanyCode
    )
    inner join      I_JournalEntry                                 as d on(
      d.AccountingDocument = a.AccountingDocument
      and d.FiscalYear     = a.FiscalYear
      and d.CompanyCode    = a.CompanyCode
    )
//    left outer join I_AccountingDocumentJournal( P_Language: 'E' ) as e on(
//      e.AccountingDocument     = a.AccountingDocument
//      and e.FiscalYear         = a.FiscalYear
//      and e.CompanyCode        = a.CompanyCode
//      and e.Ledger             = '0L'
//      and e.PurchasingDocument is not initial
//    )
    left outer join YFI_PAY_PURCH as e on 
    ( e.AccountingDocument = a.AccountingDocument and e.CompanyCode = a.CompanyCode 
      and e.FiscalYear = a.FiscalYear )

{
  key a.CompanyCode,
  key a.ClearingJournalEntry                 as AccountingDocument,
  key a.ClearingJournalEntryFiscalYear,
  key a.FiscalYear,
  key left( a.OriginalReferenceDocument,10 ) as SupplierInvoice,
  key a.AccountingDocumentItem,
  key a.AccountingDocument                   as FI_Invoice,
      b.AccountingDocumentType,
      a.SpecialGLCode,
      a.DocumentDate,
      d.PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.NetDueDate,
      a.PaymentTerms,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.WithholdingTaxAmount,
      a.DebitCreditCode,
      case
      when a.PurchasingDocument is initial then e.PurchasingDocument
      else a.PurchasingDocument
      end                                    as PurchasingDocument,
      d.DocumentReferenceID                  as SupplierInvoiceReference,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //(a.AmountInCompanyCodeCurrency - a.WithholdingTaxAmount) as NetAmountInCompanyCodeCurrency
      //a.AmountInCompanyCodeCurrency          as NetAmountInCompanyCodeCurrency --++AK09092025
      case
      when a.DebitCreditCode = 'S' 
      then ( a.AmountInCompanyCodeCurrency - a.WithholdingTaxAmount )
      else a.AmountInCompanyCodeCurrency
      end                                    as NetAmountInCompanyCodeCurrency --++AK 11092025

}
where
      a.FinancialAccountType   =  'K'
  and(
      b.AccountingDocumentType =  'ZP'
  )
  and a.AccountingDocumentType <> 'ZP'

union all select from I_OperationalAcctgDocItem as a
  inner join          I_JournalEntry            as b on(
    b.AccountingDocument = a.AccountingDocument
    and b.FiscalYear     = a.FiscalYear
    and b.CompanyCode    = a.CompanyCode
  )

  left outer join     ZCDS_SUPP_INV1_KZ         as c on(
    c.ClearingJournalEntry               = a.AccountingDocument
    and c.ClearingJournalEntryFiscalYear = a.FiscalYear
    and c.CompanyCode                    = a.CompanyCode
  )
  left outer join     ZV_INVOICE_KZ             as d on(
    d.AccountingDocument = a.AccountingDocument
    and d.CompanyCode    = a.CompanyCode
    and d.FiscalYear     = a.FiscalYear
  )

  left outer join     ZCDS_PAYMENT_ITEM2        as e on(
    b.AccountingDocument         = e.ClearingJournalEntry
    and b.FiscalYear             = e.FiscalYear
    and b.CompanyCode            = e.CompanyCode
    and e.DebitCreditCode        = 'H'
    and e.AccountingDocumentType = 'RE'
  )
  left outer join     I_Withholdingtaxitem      as f on(
    c.AccountingDocument = f.AccountingDocument
    and b.CompanyCode    = f.CompanyCode
    and b.FiscalYear     = f.FiscalYear
  )
  left outer join     zcds_suppref              as g on(
    g.ClearingJournalEntry       = b.AccountingDocument
    and g.FiscalYear             = b.FiscalYear
    and g.CompanyCode            = b.CompanyCode
    and g.AccountingDocumentType = 'RE'
  )
  left outer join     zcds_suppref1             as h on( 
    h.AccountingDocument = g.AccountingDocument
    and h.FiscalYear     = g.FiscalYear
    and h.CompanyCode    = g.CompanyCode
  )

{
  key a.CompanyCode,
  key a.AccountingDocument                 as AccountingDocument,
  key a.FiscalYear                         as ClearingJournalEntryFiscalYear,
  key case when d.SupplierFiscalYear <> '' then d.SupplierFiscalYear
           when b.DocumentReferenceID <> '' then right( b.DocumentReferenceID,4 )
           when a.InvoiceReferenceFiscalYear <> '0000' then a.InvoiceReferenceFiscalYear
           else a.FiscalYear end           as FiscalYear,
  key case when d.SupplierInvoice <> '' then d.SupplierInvoice
           when b.DocumentReferenceID <> '' then left( b.DocumentReferenceID,10 )
           else a.InvoiceReference end     as SupplierInvoice,
  key a.AccountingDocumentItem,
  key c.AccountingDocument                 as FI_Invoice,
      a.AccountingDocumentType,
      a.SpecialGLCode,
      a.DocumentDate,
      h.PostingDate,
      case when c.InvoiceGrossAmount <> 0 then c.InvoiceGrossAmount
           else a.AmountInCompanyCodeCurrency end as AmountInCompanyCodeCurrency, //a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.NetDueDate,
      a.PaymentTerms,
      case when e.WithholdingTaxAmount = 0 then f.WhldgTaxAmtInCoCodeCrcy
           else e.WithholdingTaxAmount end as WithholdingTaxAmount,
      a.DebitCreditCode,
      a.PurchasingDocument,
      h.DocumentReferenceID                as SupplierInvoiceReference,
      a.AmountInCompanyCodeCurrency        as NetAmountInCompanyCodeCurrency
}
where
  //a.FinancialAccountType   = 'K' commented by AK 02/05/2025
    a.DebitCreditCode        = 'H' --++ ak 02/05/2025
  and(
    b.AccountingDocumentType = 'KZ'
  )
    and a.SpecialGLCode is initial
