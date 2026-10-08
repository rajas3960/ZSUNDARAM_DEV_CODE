@AbapCatalog.sqlViewName: 'ZZVGRADE02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '02'
@Metadata.ignorePropagatedAnnotations: true
define view ZVgrade02
  as select from    ZVgrade01             as a
    left outer join I_ClfnClassCharcBasic as b on b.ClassInternalID = a.ClassInternalID
{
  key b.CharcInternalID
}
