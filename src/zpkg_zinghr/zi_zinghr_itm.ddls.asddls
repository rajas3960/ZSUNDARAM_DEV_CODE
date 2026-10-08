@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View:ZingHR Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ZINGHR_ITM
  as select from zdt_zinghr_itm
  association to parent ZI_ZINGHR_HDR as _Head on  $projection.Companycode    = _Head.Companycode
                                               and $projection.Payrollrunid   = _Head.payrollrunid
                                               and $projection.Payrollrundate = _Head.payrollrundate
{
  key       companycode    as Companycode,
  key       payrollrunid   as Payrollrunid,
  key       payrollrundate as Payrollrundate,
  key       glid           as Glid,
  key       costcenter     as Costcenter,
  key       profitcenter   as Profitcenter,
            glname         as Glname,
            amt            as Amt,
            costcenterdesc as Costcenterdesc,

            _Head
}
