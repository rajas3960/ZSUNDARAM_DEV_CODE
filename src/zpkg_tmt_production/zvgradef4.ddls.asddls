@AbapCatalog.sqlViewName: 'ZZVVGRADEF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grade f4'
@Metadata.ignorePropagatedAnnotations: true
define view ZVGRADEF4
  as select distinct from I_ClfnClass           as a
    inner join            I_ClfnClassCharcBasic as b on b.ClassInternalID = a.ClassInternalID
    inner join            I_ClfnCharacteristic  as c on  c.Characteristic  = 'GRADE'
                                                     and c.CharcInternalID = b.CharcInternalID
    inner join            I_ClfnCharcValue      as d on d.CharcInternalID = c.CharcInternalID
{
  key cast(  d.CharcValue  as abap.char(20) ) as GARDE
}
where
      a.Class      = 'ZTMT'
  and a.ClassType  = '023'
  and d.CharcValue is not initial
