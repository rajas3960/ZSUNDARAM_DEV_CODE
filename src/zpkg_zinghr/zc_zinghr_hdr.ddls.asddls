@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View:ZingHR Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_ZINGHR_HDR 
provider contract transactional_query
as projection on ZI_ZINGHR_HDR
{
    key     Companycode,
    key Payrollrunid,
    key Payrollrundate,
    Payrollrunremarks,
    LastChangedAt,
    /* Associations */
    _Item : redirected to composition child ZC_ZINGHR_ITM
}
