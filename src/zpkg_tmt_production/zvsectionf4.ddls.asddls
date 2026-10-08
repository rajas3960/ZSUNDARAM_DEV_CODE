@AbapCatalog.sqlViewName: 'ZZVVSECTIONF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Section f4'
@Metadata.ignorePropagatedAnnotations: true
define view ZVSECTIONF4
  as select distinct from I_ClfnClass           as a
    inner join            I_ClfnClassCharcBasic as b on b.ClassInternalID = a.ClassInternalID
    inner join            I_ClfnCharacteristic  as c on  c.Characteristic  = 'SECTION'
                                                     and c.CharcInternalID = b.CharcInternalID
    inner join            I_ClfnCharcValue      as d on d.CharcInternalID = c.CharcInternalID
{
  key cast( cast( d.CharcFromDecimalValue as abap.dec( 25 ,0 ) ) as abap.char(30) ) as Tsection
}
where
      a.Class     = 'ZTMT'
  and a.ClassType = '023'
