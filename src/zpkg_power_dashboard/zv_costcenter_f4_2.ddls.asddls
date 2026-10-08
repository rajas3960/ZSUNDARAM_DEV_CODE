@AbapCatalog.sqlViewName: 'ZVCOSTF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Center F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_COSTCENTER_F4_2
  as select from    I_CostCenter     as a
    left outer join I_CostCenterText as b on a.CostCenter = b.CostCenter
{
  key  a.CostCenter     as Costcenter,
       b.CostCenterName as Costcentertext,
       a.Plant
       //     COMPANYCODE= 1000 for plant 1006  (Input from create screen),
       //      2000 for plant 2006 (input from create screen)
       //      and COSTCENTERCATEGORY=F to fetch COSTCENTER.
}
where
  a.CostCenterCategory = 'F'
