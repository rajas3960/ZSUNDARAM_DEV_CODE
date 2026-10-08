@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption For Reservation Print Header'
@Metadata.allowExtensions: true
//@Search.searchable: true
define root view entity ZC_QUALITY_HDR
  as projection on ZI_QUALITY_HDR
{
  key Id,

      @EndUserText.quickInfo: 'Invoice No'
      @EndUserText.label: 'Invoice No'
      Billingdoc,

      @EndUserText.quickInfo: 'Invoice Item'
      @EndUserText.label: 'Invoice Item'
      billingitem,

      @EndUserText.label: 'Vehicle No.'
      vehicleno,

      @EndUserText.quickInfo: 'Plant'
      @EndUserText.label: 'Plant'
      Plant,

      @EndUserText.quickInfo: 'Material'
      @EndUserText.label: 'Material'
      material,

      @EndUserText.quickInfo: 'Thickness'
      @EndUserText.label: 'Thickness'
      thickness,

      @EndUserText.quickInfo: 'Width'
      @EndUserText.label: 'Width'
      width,

      @EndUserText.quickInfo: 'Quantity'
      @EndUserText.label: 'Quantity'
      quantity,

      @EndUserText.quickInfo: 'Batch'
      @EndUserText.label: 'Batch'
      batch,

      @EndUserText.quickInfo: 'Grade'
      @EndUserText.label: 'Grade'
      grade,

      @EndUserText.quickInfo: 'Customer Name'
      @EndUserText.label: 'Customer Name'
      customer,

      @EndUserText.quickInfo: 'Film Type'
      @EndUserText.label: 'Film Type'
      filmtype,

      @EndUserText.quickInfo: 'PO No'
      @EndUserText.label: 'PO No'
      pono,

      @EndUserText.quickInfo: 'Delivery'
      @EndUserText.label: 'Delivery'
      Deliveryno,

      @EndUserText.quickInfo: 'Delivery Item'
      @EndUserText.label: 'Delivery Item'
      Deliveryitem,

      @EndUserText.quickInfo: 'Sales Order'
      @EndUserText.label: 'Sales Order'
      Salesord,

      @EndUserText.quickInfo: 'Sales Order Item'
      @EndUserText.label: 'Sales Order Item'
      Salesitem,

      @Semantics.systemDateTime.createdAt: true
      @EndUserText.quickInfo: 'Invoice Creation Date'
      @EndUserText.label: 'Inv. Creation Date'
      Invdate,

      @EndUserText.quickInfo: 'Test Certificate Print'
      @EndUserText.label: 'Test Certificate Print'
      Testcertprnt,

      @EndUserText.quickInfo: 'Text Box'
      @EndUserText.label: 'Text Box'
      textbox,

      @EndUserText.quickInfo: 'Inpection Plan'
      @EndUserText.label: 'Inpection Plan'
      inspecplan,

      @EndUserText.quickInfo: 'Inpection Plan Grp'
      @EndUserText.label: 'Inpection Plan Grp'
      inspecplangroup,

      @EndUserText.quickInfo: 'Remarks'
      @EndUserText.label: 'Remarks'
      remarks,
      @EndUserText.quickInfo: 'Quality Crtificate Number'
      @EndUserText.label: 'Quality Crtificate Number'
      qc_cert_no,

      @EndUserText.quickInfo: 'Print'
      @EndUserText.label: 'Print'
      tprint,

      @EndUserText.quickInfo: 'Delete'
      @EndUserText.label: 'Delete'
      tdelete,

      @EndUserText.quickInfo: 'Product Name'
      @EndUserText.label: 'Product Name'
      prod_name,

      @EndUserText.quickInfo: 'Product Group'
      @EndUserText.label: 'Product Group'
      prod_group,

      @EndUserText.quickInfo: 'Metal Side'
      @EndUserText.label: 'Metal Side'
      chem_metal,

      @EndUserText.quickInfo: 'Chemical Side'
      @EndUserText.label: 'Chemical Side'
      treatment,

      @EndUserText.quickInfo: 'Corona Side'
      @EndUserText.label: 'Corona Side'
      coatside,

      @EndUserText.quickInfo: 'Inpection Plan Selection'
      @EndUserText.label: 'Inpection Plan Selection'
      tgroup,
      //   @EndUserText.label: 'Attachment'
      @EndUserText.label: 'Attachment'
      Attachment,
      @EndUserText.label: 'Mime Type'
      @Semantics.mimeType: true
      Mimetype,
      @EndUserText.label: 'File Name'

      //    @EndUserText.label: 'File Name'
      Filename,
      @EndUserText.quickInfo: 'Status'
      @EndUserText.label: 'Status'
      status,
      @EndUserText.quickInfo: 'Criticality'
      @EndUserText.label: 'Criticality'
      Criticality,
      //    @EndUserText.label: 'Mime Type'



      /* Associations */
      _Item : redirected to composition child ZC_QUALITY_ITM
}
