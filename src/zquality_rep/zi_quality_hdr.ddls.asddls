@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Approval Header'
define root view entity ZI_QUALITY_HDR
  as select from zdt_quality
  composition [0..*] of ZI_QUALITY_ITM as _Item
{

  key id                 as Id,
      billingdoc         as Billingdoc,
      billingitem        as billingitem,
      vehicleno,
       case tdelete
      when 'X' then 'Deleted'
      else 'Created' end as status,
      case tdelete
      when 'X' then 1
      else 3 end as Criticality,
      plant              as Plant,
      material,
      thickness,
      width,
      quantity,
      batch,
      grade,
      customer,
      treatment,
      coatside,
      filmtype,
      pono,
      deliveryno         as Deliveryno,
      deliveryitem       as Deliveryitem,
      salesord           as Salesord,
      salesitem          as Salesitem,
      invdate            as Invdate,
      testcertprnt       as Testcertprnt,
      textbox            as textbox,
      inspecplan,
      inspecplangroup,
      remarks,
      qc_cert_no,
      tprint,
      tdelete,
      prod_name,
      prod_group,
      chem_metal,
      tgroup,
      @Semantics.largeObject: { mimeType: 'Mimetype', fileName: 'Filename', contentDispositionPreference: #INLINE }
      attachment         as Attachment,
      @Semantics.mimeType: true
      mimetype           as Mimetype,
      filename           as Filename,
      _Item
}
