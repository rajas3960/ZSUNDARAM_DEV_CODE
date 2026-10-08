@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BIlling Quality'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_BILLQUALITY

  as select from I_BillingDocument as a

    inner join   I_CompanyCode     as b on b.CompanyCode = a.CompanyCode
{
  key a.BillingDocument,
      a.CompanyCode,
      b.CompanyCodeName
}
