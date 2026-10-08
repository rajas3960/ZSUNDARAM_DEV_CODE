@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Run Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPO_I_GSTRUN
  as select from zpo_gstrun_db
  association [0..*] to ZPO_I_GST as _Items on  // _Items.CompanyCode  = $projection.Companycode
                                                _Items.DocumentDate >= $projection.Fromdate
                                            and _Items.DocumentDate <= $projection.Todate
{
  key runid       as Runid,
      companycode as Companycode,
      fromdate    as Fromdate,
      todate      as Todate,
      status      as Status,
      postedcount as Postedcount,
      createdby   as Createdby,
      createdat   as Createdat,
      _Items
}
