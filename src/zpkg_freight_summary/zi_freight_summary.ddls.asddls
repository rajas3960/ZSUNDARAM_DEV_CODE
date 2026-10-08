@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View:Freight Summary Rep'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_FREIGHT_SUMMARY
  as select from ZR_FREIGHT_SUMMARY

{
  key    PO,
  key    POItem,
  key    CompanyCode,
  key    GRNNo,
  key    GRNItem,
  key    GRNYear,
  key    GRNDocDate,
  key    GRNPostingDate,
  key    FreightInvoice,
  key    FreightInvoiceItem,
         ////  key ConditionType,
  key    TransporterPO,
         TransporterNamePO,
         ReverseDocument,
         Material,
         Plant,
         UOM,
         GatePassNo,
         TransporterNoGatePass,
         TransporterNameGatePass,
         GRNQty,
         GoodsAmountGRN,
         FreightAmountGRN,
         TaxCode,
         TaxableAmount,
         TotalPayable,
         FreightRatePlanned,
         FreightRateActual
}
