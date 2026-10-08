@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.sqlViewName: 'ZZVCASTERF4'

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Caster F4 for Billet Production'

@Metadata.ignorePropagatedAnnotations: true

define view ZVCASTERF4
  as select distinct from I_ClfnClass       as a

    inner join            I_ClfnObjectClass as b on a.ClassInternalID = b.ClassInternalID

{
  key substring(b.ClfnObjectID, 5, 86) as Caster,
  key substring(b.ClfnObjectID, 1, 4)  as Plant
}

where a.Class     = 'ZCASTER'
  and a.ClassType = '019'
