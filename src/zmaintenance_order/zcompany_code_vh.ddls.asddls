@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Code Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCOMPANY_CODE_VH 
as select from I_MaintenanceOrderBasic

{
    key MaintenanceOrder,
    I_MaintenanceOrderBasic.CompanyCode
}
