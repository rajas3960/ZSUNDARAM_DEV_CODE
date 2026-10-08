@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier of Payment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_HEAD_L3  as select distinct from I_OperationalAcctgDocItem as a
inner join I_JournalEntry as b
on ( b.AccountingDocument = a.AccountingDocument and b.FiscalYear = a.FiscalYear 
     and b.CompanyCode = a.CompanyCode )
{
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.CompanyCode,
  max( a.Supplier ) as Supplier,
  b.CreationTime,
  b.AccountingDocCreatedByUser,
  b.AccountingDocumentCreationDate,
  cast( concat( b.AccountingDocumentCreationDate,b.CreationTime ) as abap.dec(15,0) ) as timestamp
}
  where
  (
    (
         a.AccountingDocumentType =  'ZP'
      or a.AccountingDocumentType =  'KZ'
    )
    and  a.Supplier               is not initial
    and  a.ClearingIsReversed     <> 'X'
    and  a.FinancialAccountType   =  'K'
    and  ( b.IsReversed           = '' and b.IsReversal = '' )
    and  a.FiscalYear >= '2025'
  )

group by a.AccountingDocument,a.FiscalYear,a.CompanyCode,b.CreationTime,b.AccountingDocCreatedByUser,
         b.AccountingDocumentCreationDate

