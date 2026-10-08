@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Approval'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RESVAPProvalttp
  as select from zmm_tt_resv_appr
{
  key resvno      as Resvno,
      material    as Material,
      approved    as approved,
      approvedby  as Approvedby,
      approvedate as Approvedate,
      approvetime as Approvetime
}
