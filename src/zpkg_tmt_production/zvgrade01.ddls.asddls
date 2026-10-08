@AbapCatalog.sqlViewName: 'ZZVGRADE01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '01'
@Metadata.ignorePropagatedAnnotations: true
define view ZVgrade01
  as select distinct from I_ClfnClass
{
  key ClassInternalID
}
where
      Class     = 'ZTMT'
  and ClassType = '023'
