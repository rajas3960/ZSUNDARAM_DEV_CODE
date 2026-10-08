@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Print 2 item level'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_qal_print_itm3
  as select distinct from zi_qal_print_itm2
{
  key   id,
  key   batch,
        max( quantity )  as quantity,
        max(  C_Res)     as c_res,
        max(    MN_res ) as MN_res,
        max(   SI_res )  as SI_res,
        max(  S_res )    as S_res,
        max(  P_res )    as P_res,
        max(   S_P_res ) as S_P_res,
        max(   CE_res )  as CE_res
}

group by
  id,
  batch
