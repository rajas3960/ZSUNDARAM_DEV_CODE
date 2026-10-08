@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KR Document Total Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_KR_TOTAMT 
as select from ZR_KR_BASE_AMT as a
left outer join ZV_RE_TAX as b on a.AccountingDocument = b.AccountingDocument
and a.FiscalYear = b.FiscalYear
and a.CompanyCode = b.CompanyCode
{
   key a.AccountingDocument,
    key a.CompanyCode,
    key a.FiscalYear,
    ( coalesce(cast(a.baseamt as abap.dec( 23, 2 )) , 0) + coalesce( cast(b.baseamt as abap.dec( 23, 2 )) , 0 ) ) as baseamt
}
