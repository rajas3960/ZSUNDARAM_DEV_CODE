@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass User Validation PV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_GATE_USER_PVC
  provider contract transactional_query
  as projection on ZMM_GATE_USER_RVI
{
      @ObjectModel.text.element: [ 'Usrname' ]
      @EndUserText.label: 'User ID'
  key Userid,
      @ObjectModel.text.element: [ 'Ccname' ]  
  key Ccode,
      Usrname,
      Ccname,
      Signername,
      @ObjectModel.text.element: [ 'Createdname' ]      
      Createdby,
      createdname,
      Createdat,
      Lastchangedby,
      Lastchangedat
}
