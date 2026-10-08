@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass User F4 Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZGATE_USER_VH
  as select from ZMM_GATE_USER_RVI
{

      @EndUserText.label: 'Company Code'
  key Ccode as companycode ,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Createdby'
  key Userid as useridcb ,
      @EndUserText.label: 'Createdby Name'
      Usrname,
      @EndUserText.label: 'Company Name'
      Ccname

}
