@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register PV for header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZPUR_REG_HPV
  provider contract transactional_query as projection on ZPUR_REG_HRE
{
    key Uuid,
    PurchaseOrder,
    Status,
    Fromdate,
    Todate,
    @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdon,
    /* Associations */
    _Items : redirected to composition child ZPUR_REG_IPV
}
