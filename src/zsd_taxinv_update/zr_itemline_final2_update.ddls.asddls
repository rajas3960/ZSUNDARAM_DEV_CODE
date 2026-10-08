@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final View For Tax Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ITEMLINE_FINAL2_UPDATE
  as select distinct from I_BillingDocumentItem          as a
    inner join            I_Product                      as b on b.Product = a.Product
    inner join            I_SerialNumberDeliveryDocument as c on  c.DeliveryDocument     = a.ReferenceSDDocument
                                                              and c.DeliveryDocumentItem = a.ReferenceSDDocumentItem

{
  key a.BillingDocument,
  key c.Equipment               as BillingDocumentItem,
      a.BillingDocumentItemText as MaterialDesc,
      c.SerialNumber

}
where
  //  (
  //       a.Plant       = '1002'
  //    or a.Plant       = '1004'
  //    or a.Plant       = '1001'
  //    or a.Plant       = '1003'
  //  )
  //  and
  //  (
  //       a.Division    = '30'
  //    or a.Division    = '40'
  //    or a.Division    = '50'
  //  )
  // and
  b.ProductType = 'ZFGP'
