@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'DRI Production Material Maintainace'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZDTDRI_PRD_01'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_DTDRI_PRD_01
  provider contract transactional_query
  as projection on ZR_DTDRI_PRD_01
  association [1..1] to ZR_DTDRI_PRD_01 as _BaseEntity on $projection.Material = _BaseEntity.Material and $projection.Plant = _BaseEntity.Plant
{
  key Material,
  key Plant,
  Materialdesc,
  percentrecovery,
  @UI.hidden: true
  @Semantics: {
    user.lastChangedBy: true
  }
  Changedby,
  @UI.hidden: true
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  Lastchangetstmpl,
  @UI.hidden: true
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  Changetstmpl,
  @Semantics: {
    user.createdBy: true
  }
  Createdby,
  @UI.hidden: true
  _BaseEntity
}
