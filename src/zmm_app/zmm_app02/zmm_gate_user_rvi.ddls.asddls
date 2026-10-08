@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass User Validation RV'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_GATE_USER_RVI
  as select from zmm_user_db
  association [1..1] to I_BusinessUserBasic as Cname on $projection.Createdby = Cname.UserID
{
  key userid        as Userid,
  key ccode         as Ccode,
      usrname       as Usrname,
      ccname        as Ccname,
      signername    as Signername,
      
      @Semantics.user.createdBy: true      
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true      
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true      
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true      
      lastchangedat as Lastchangedat,
      Cname.PersonFullName as createdname
}
