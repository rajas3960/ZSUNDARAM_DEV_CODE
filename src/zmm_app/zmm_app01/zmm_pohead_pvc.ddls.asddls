@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Headar Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMM_POHEAD_PVC 
as projection on ZMM_POHEAD_RVI
{
          @EndUserText.label: 'ID'
  key     Id,
          @EndUserText.label: 'Item'
  key     item,
          @EndUserText.label: 'Purchase Order'
          Purchaseorder,
          @EndUserText.label: 'Supplier/Customer'
          Supplier,
          @EndUserText.label: 'Supplier/Customer Name'
          Supliername,
          @EndUserText.label: 'Sales Order'
          Salesorder,
          @EndUserText.label: 'Supplying Plant'
          supplyplant,
          @EndUserText.label: 'Billing Reference'
          billingreference,
          @EndUserText.label: 'E-Way Bill'
          eway,
          @EndUserText.label: 'Invoice Number'
          invoiceno,
          @EndUserText.label: 'Invoice Date'
          invoicedate,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATE_INOUT'
  virtual Showpo :abap_boolean,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GATE_INOUT'
  virtual Showso :abap_boolean,

          //          materialprocess,
          /* Associations */
          _Head : redirected to parent ZMM_GATEHEAD_PVC
}
