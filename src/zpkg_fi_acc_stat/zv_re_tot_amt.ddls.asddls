@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_RE_TOT_AMT as select from ZV_RE_BASE as a
left outer join ZV_RE_TAX as b on a.AccountingDocument = b.AccountingDocument
and a.FiscalYear = b.FiscalYear
and a.CompanyCode = b.CompanyCode
{
    key a.AccountingDocument,
    key a.CompanyCode,
    key a.FiscalYear,
    ( coalesce(cast(a.baseamt as abap.dec( 23, 2 )) , 0) + coalesce( cast(b.baseamt as abap.dec( 23, 2 )) , 0 ) ) as amt
}
