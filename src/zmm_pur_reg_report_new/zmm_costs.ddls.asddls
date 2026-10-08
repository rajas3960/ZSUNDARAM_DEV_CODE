@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for Total Material & Delivery Costs'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_COSTS
  as select distinct from I_JournalEntry     as JE
    inner join            I_JournalEntryItem as JEI on  JEI.AccountingDocument = JE.AccountingDocument
                                                    and JEI.FiscalYear         = JE.FiscalYear
                                                    and JEI.CompanyCode        = JE.CompanyCode
                                                    and JEI.Ledger             = '0L'


{
  key JE.OriginalReferenceDocument,
  key JEI.TransactionTypeDetermination,
  key JEI.PurchasingDocument,
  key JEI.PurchasingDocumentItem,
  key JEI.ReferenceDocument,
  key cast( substring( JEI.ReferenceDocumentItem , 3,4 ) as abap.numc( 4 ) ) as ReferenceDocumentItem,
  key   substring(JE.OriginalReferenceDocument, 11, 4 ) as matfiscalyear,
      cast( sum(JEI.AmountInCompanyCodeCurrency) as abap.dec(23,2)) as Amt
      //      cast( JEI.AmountInCompanyCodeCurrency as abap.dec(23,2)) as Amt
}

where
  (
        JE.OriginalReferenceDocument is not null
    and JE.OriginalReferenceDocument is not initial
  )
//  and(
//        JEI.TransactionTypeDetermination = 'WRX'
//    or  JEI.TransactionTypeDetermination = 'FR1'
//  )
group by
  JE.OriginalReferenceDocument,
  JEI.TransactionTypeDetermination,
  JEI.PurchasingDocument,
  JEI.PurchasingDocumentItem,
  JEI.ReferenceDocument,
  JEI.ReferenceDocumentItem

having
  (
       JEI.TransactionTypeDetermination = 'WRX'
    or JEI.TransactionTypeDetermination = 'FR1'
    or JEI.TransactionTypeDetermination = 'JCI'
  )
