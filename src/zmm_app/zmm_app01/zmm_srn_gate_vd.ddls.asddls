@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SRN Validation Purpose for Gatepass'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_SRN_GATE_VD 
as select from zmm_gatehead_db as GPH
inner join zmm_po_head_db as POH on POH.id = GPH.id
{
key GPH.id as Id,
GPH.gatepassno as Gatepassno,
GPH.movementtype as Movementtype,
GPH.materialprocess as Materialprocess,
GPH.companycode as Companycode,
POH.purchaseorder

}
