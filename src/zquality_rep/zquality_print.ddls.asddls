@EndUserText.label: 'CDS View for Delivery Check Print'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZQUALITY_PRINT 
 as select from ZI_QUALITY_HDR

  association [1..*] to ZI_QUALITY_ITM as _items on _items.Billingdoc = $projection.Billingdoc

{
  key Billingdoc      as Billingdoc,
      billingitem     as Billingitem,
      Plant           as Plant,
      material        as Material,
      Deliveryno      as Deliveryno,
      Deliveryitem    as Deliveryitem,
      Salesord        as Salesord,
      Salesitem       as Salesitem,
      Invdate         as Invdate,
      Testcertprnt    as Testcertprnt,
      textbox         as Textbox,
      inspecplangroup as Inspecplangroup,
      inspecplan      as Inspecplan,
      _items

}
