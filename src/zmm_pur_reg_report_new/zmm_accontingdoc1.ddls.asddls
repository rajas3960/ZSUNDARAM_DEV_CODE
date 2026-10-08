@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accounting Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_ACCONTINGDOC1

  as select from ZMM_ACCONTINGDOC    as JE

    inner join   I_JournalEntryItem as JEI on  JEI.AccountingDocument             = JE.AccountingDocument
                                           and JEI.FiscalYear                     = JE.FiscalYear
                                           and JEI.CompanyCode                    = JE.CompanyCode
                                           and JEI.Ledger                         = '0L'
                                           and (
                                              JEI.TransactionTypeDetermination    = 'JCI'
                                              or JEI.TransactionTypeDetermination = 'JTI'
                                              or JEI.TransactionTypeDetermination = 'WIT'
                                               )
  
{

  key JEI.AccountingDocument,
  key JEI.FiscalYear,
  key JEI.CompanyCode,
      JE.suppplierinv,
      JE.supfiscalyear,
      sum( cast( JEI.AmountInCompanyCodeCurrency as abap.dec( 31,2 ) ) ) as CompensationCess

}

group by
  JEI.AccountingDocument,
  JEI.FiscalYear,
  JEI.CompanyCode,
  JE.suppplierinv,
  JE.supfiscalyear
