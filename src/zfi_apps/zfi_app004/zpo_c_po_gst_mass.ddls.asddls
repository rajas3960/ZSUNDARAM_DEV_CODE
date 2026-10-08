@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST CONSUMPTION VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPO_C_PO_GST_MASS
  provider contract transactional_query
  as projection on ZPO_I_PO_GST_MASS
{
  key Uuid,
      Fromdate,
      Todate,
      Createdby,
      Createdat
}
