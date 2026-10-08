@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View:ZingHR Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_ZINGHR_ITM 
as projection on ZI_ZINGHR_ITM
{
    key Companycode,
    key Payrollrunid,
    key Payrollrundate,
    key Glid,
    key Costcenter,
    key Profitcenter,
    Glname,
    Amt,
    Costcenterdesc,
    /* Associations */
    _Head : redirected to parent ZC_ZINGHR_HDR
}
