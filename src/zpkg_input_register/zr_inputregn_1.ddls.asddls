@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREGN_1
  as select distinct from I_OperationalAcctgDocTaxItem as a
    inner join            I_OperationalAcctgDocItem    as b on  a.CompanyCode        = b.CompanyCode
                                                            and a.FiscalYear         = b.FiscalYear
                                                            and a.AccountingDocument = b.AccountingDocument

{
  key  a.CompanyCode,
  key  a.FiscalYear,
  key  a.AccountingDocument
}
where
  b.TaxType = 'V'
group by
  a.CompanyCode,
  a.FiscalYear,
  a.AccountingDocument
