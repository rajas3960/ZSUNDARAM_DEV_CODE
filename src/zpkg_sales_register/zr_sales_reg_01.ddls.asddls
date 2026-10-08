@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZR_SALES_REG_01
  as select distinct from ZR_SALES_REG
{
      @EndUserText.label: 'Invoice No'
  key BillingDocument,
      @EndUserText.label: 'Invoice Item'
  key BillingDocumentItem,
      @EndUserText.label: 'Invoice Type'
      billtype,
      @EndUserText.label: 'Invoice Date'
      BillingDocumentDate,
      @EndUserText.label: 'Sales Document'
      SalesDocument,
      @EndUserText.label: 'Sales Doc. Item'
      OrderItem,
      @EndUserText.label: 'Sales Doc. Date'
      SalesDocumentDate,
      @EndUserText.label: 'Delivery No'
      DeliveryNo,
      @EndUserText.label: 'Delivery Item'
      DeliveryItem,
      @EndUserText.label: 'Delivery Date'
      deliverydate,
      @EndUserText.label: 'Sales Contract'
      salescontract,
      @EndUserText.label: 'Sales Organization'
      SalesOrganization,
      @EndUserText.label: 'Distribution Channel'
      DistributionChannel,
      @EndUserText.label: 'Division'
      Division,
      @EndUserText.label: 'Customer ID'
      SoldToParty,
      @EndUserText.label: 'Customer Name'
      SoldToPartyName,
      @EndUserText.label: 'Customer GSTIN'
      soldtogstin,
      @EndUserText.label: 'Ship To Party'
      ShipToParty,
      @EndUserText.label: 'Ship To Name'
      ShipToPartyName,
      @EndUserText.label: 'Ship To GSTIN'
      ShipToGSTIN,
      @EndUserText.label: 'Broker'
      Broker,
      @EndUserText.label: 'Broker Name'
      Brokername,
      @EndUserText.label: 'HSN Code'
      HSNCode,
      @EndUserText.label: 'Product Code(SAP)'
      Product,
      @EndUserText.label: 'Product Type'
      ProductType,
      @EndUserText.label: 'Product Description'
      BillingDocumentItemText,
      @EndUserText.label: 'UOM'
      uom,
      @EndUserText.label: 'Billing Quantity'
      //         @Semantics.quantity.unitOfMeasure: 'UOM'
      //            case
      //            when BillingQuantity = 0 then ''
      //            else cast (BillingQuantity as abap.char( 30 ))
      //            end as
      BillingQuantity,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Rate/MT'
      Rate,

      amtuom,
      @EndUserText.label: 'Taxable Value'
      taxablevalue,
      @EndUserText.label: 'IGST Rate'
      IGSTRATE,
      @EndUserText.label: 'IGST Value'
      IGSTvalue,
      @EndUserText.label: 'CGST Rate'
      CGSTRATE,
      @EndUserText.label: 'CGST Value'
      cGSTvalue,
      @EndUserText.label: 'SGST Rate'
      SGSTRATE,
      @EndUserText.label: 'SGST Value'
      sGSTvalue,
      @EndUserText.label: 'UTGST Rate'
      UTGSTRATE,
      @EndUserText.label: 'UTGST Value'
      utGSTvalue,
      @EndUserText.label: 'Cess'
      compcessamt,
      @EndUserText.label: 'Total Tax'
      ( coalesce(IGSTvalue,0) + coalesce(sGSTvalue,0) + coalesce(cGSTvalue,0) + coalesce(utGSTvalue,0) + coalesce(compcessamt,0) )                                                                             as totaltax,
      @EndUserText.label: 'TCS Rate'
      tcsrate,
      @EndUserText.label: 'TCS Value'
      Tcsvalue,
      @EndUserText.label: 'Rounding Off ' // ++ new COLUMN added on 14.08.25 SP
      RoundingOff,
      @EndUserText.label: 'Invoice Value'
      //  ( coalesce(Tcsvalue,0) + coalesce(taxablevalue,0) + coalesce(IGSTvalue,0) + coalesce(SGSTvalue,0) + coalesce(CGSTvalue,0) + coalesce(UTGSTvalue,0) + coalesce(compcessamt,0)  ) as invval, // -- 14.08.25 SP
      ( coalesce(Tcsvalue,0) + coalesce(taxablevalue,0) + coalesce(IGSTvalue,0) + coalesce(sGSTvalue,0) + coalesce(cGSTvalue,0) + coalesce(utGSTvalue,0) + coalesce(compcessamt,0) + coalesce(RoundingOff,0) ) as invval, // ++ 14.08.25 SP
      @EndUserText.label: 'Gatepass Number' // ++ 0n 18.08.25
      gatepassnumber, // ++ 18.08.25
      @EndUserText.label: 'Transporter Name'
      transportername,
      @EndUserText.label: 'Transporter GSTIN'
      transportergstin,
      @EndUserText.label: 'Vehicle Number'
      vehiclenumber,
      @EndUserText.label: 'LR No'
      Lrrrno,
      @EndUserText.label: 'LR Date'
      Lrrrdate,
      @EndUserText.label: 'IRN No.'
      irn,
      @EndUserText.label: 'EWay No.'
      eway,
      @EndUserText.label: 'EWB Cancellation Date'
      ewaycanceldate,
      CompanyCode,
      @EndUserText.label: 'Reference Invoice No.'
      Orginalinvno,
      @EndUserText.label: 'Reference Invoice Dt.'
      Orginalinvdate,
      @EndUserText.label: 'Billing Doc Type'
      BillingDocumentType,
      @EndUserText.label: 'Billing Doc Cancelled'
      BillingDocumentIsCancelled,
      @EndUserText.label: 'Cancelled Billing Doc.'
      CancelledBillingDocument,
      @EndUserText.label: 'shipping condition'
      ShippingCondition,
      @EndUserText.label: 'Order Reason'
      Orderreason,
      @EndUserText.label: 'Billing Status'
      BillingStatus,
      @EndUserText.label: 'EINV Cancellation Date'
      EINVCancellationDate

}
