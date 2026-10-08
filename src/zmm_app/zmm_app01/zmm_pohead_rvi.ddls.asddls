@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Headar Interface'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_POHEAD_RVI 
  as select from zmm_po_head_db
  association to parent ZMM_GATEHEAD_RVI as _Head on $projection.Id = _Head.Id
{
  key id            as Id,
  key item          as item,
      purchaseorder as Purchaseorder,
      supplier      as Supplier,
      supliername   as Supliername,
      salesorder    as Salesorder,
      supplyingplant as supplyplant,
      billingreference,
      eway,
      invoiceno,
      invoicedate,
      //            _Head.Materialprocess as materialprocess,
      _Head
}
