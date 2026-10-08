@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gstrun consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPO_C_GSTRUN 
provider contract transactional_query
  as projection on ZPO_I_GSTRUN
{
  key Runid,
      Companycode,
      Fromdate,
      Todate,
      Status,
      Postedcount,
      Createdby,
      Createdat,
      _Items : redirected to ZPO_C_GST
}
