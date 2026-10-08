@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'User Authorization'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZDTUSER_AUTH'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_DTUSER_AUTH
  provider contract transactional_query
  as projection on ZR_DTUSER_AUTH
  association [1..1] to ZR_DTUSER_AUTH as _BaseEntity on $projection.ID = _BaseEntity.ID
{
  key ID,
  @EndUserText.label: 'User ID'
  Cbuser,
  Companycode,
  @Semantics: {
    user.lastChangedBy: true
  }
  Changedby,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  Lastchangetstmpl,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  Changetstmpl,
  @Semantics: {
    user.createdBy: true
  }
  Createdby,
  _BaseEntity
  
  
}
