@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPUR_REG_HRE as select from zpur_reg_hdr
composition [0..*] of ZPUR_REG_IRE as _Items
{
    key uuid as Uuid,
    purchase_order as PurchaseOrder,
    status as Status,
    fromdate as Fromdate,
    todate as Todate,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdon as Createdon,
    _Items
}
