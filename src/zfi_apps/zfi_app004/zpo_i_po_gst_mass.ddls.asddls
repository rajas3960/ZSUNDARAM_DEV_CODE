@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO GST Mass Processing'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPO_I_PO_GST_MASS
  as select from zpo_gst_status

{
  key uuid      as Uuid,
      fromdate  as Fromdate,
      todate    as Todate,
      createdby as Createdby,
      createdat as Createdat
}
