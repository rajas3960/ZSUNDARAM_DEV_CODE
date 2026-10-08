@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption ~ sales register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_RALES_REG
  as select distinct from ZR_SALES_REG_02
{
  key BillingDocument,
  key BillingDocumentItem,
      billtype,
      BillingDocumentDate,
      SalesDocument,
      OrderItem,
      SalesDocumentDate,
      DeliveryNo,
      DeliveryItem,
      deliverydate,
      salescontract,
      SalesOrganization,
      DistributionChannel,
      Division,
      SoldToParty,
      SoldToPartyName,
      soldtogstin,
      ShipToParty,
      ShipToPartyName,
      ShipToGSTIN,
      Broker,
      Brokername,
      HSNCode,
      Product,
      ProductType,
      BillingDocumentItemText,
      uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      BillingQuantity,
      Plant,
      ProfitCenter,
      Batch,
      Rate,
      amtuom,
      taxablevalue,
      IGSTRATE,
      IGSTvalue,
      CGSTRATE,
      CGSTvalue,
      SGSTRATE,
      SGSTvalue,
      UTGSTRATE,
      UTGSTvalue,
      compcessamt,
      ( coalesce(IGSTvalue,0) + coalesce(SGSTvalue,0) + coalesce(CGSTvalue,0) + coalesce(UTGSTvalue,0) + coalesce(compcessamt,0) )                                                   as totaltax,
      tcsrate,
      Tcsvalue,
      ( coalesce(Tcsvalue,0) + coalesce(taxablevalue,0) + coalesce(IGSTvalue,0) + coalesce(SGSTvalue,0) + coalesce(CGSTvalue,0) + coalesce(UTGSTvalue,0) + coalesce(compcessamt,0) ) as invval
 
      


}
