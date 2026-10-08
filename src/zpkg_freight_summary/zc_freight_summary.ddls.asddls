@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View:Freight Summary Rep'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_FREIGHT_SUMMARY 
provider contract transactional_query
as projection on ZI_FREIGHT_SUMMARY

{
    @EndUserText.label: 'Purchase Order'
    key PO,
    @EndUserText.label: 'Purchase Order Item'
    key POItem,
    @EndUserText.label: 'Company Code'
    key CompanyCode,
    @EndUserText.label: 'GRN No'
    key GRNNo,
    @EndUserText.label: 'GRN Item'
    key GRNItem,
    @EndUserText.label: 'GRN Year'
    key GRNYear,
    @EndUserText.label: 'GRN Document Date'
    key GRNDocDate,
    @EndUserText.label: 'GRN Posting Date'
    key GRNPostingDate,
    @EndUserText.label: 'Freight Invoice'
    key FreightInvoice,
    @EndUserText.label: 'Freight Invoice Item'
    key FreightInvoiceItem,
//    @EndUserText.label: 'Condition Type'
//    key ConditionType,
    @EndUserText.label: 'Transporter PO'
    key TransporterPO,
    @EndUserText.label: 'Transporter Name PO'
    TransporterNamePO,
    
    @EndUserText.label: 'Reverse Document'
    ReverseDocument,
    @EndUserText.label: 'Material'
    Material,
    @EndUserText.label: 'Plant'
    Plant,
    @EndUserText.label: 'UOM'
    UOM,
    @EndUserText.label: 'GatePass No'
    GatePassNo,
    @EndUserText.label: 'Transporter No'
    TransporterNoGatePass,
    @EndUserText.label: 'Transporter Name'
    TransporterNameGatePass,
    @EndUserText.label: 'GRN Qty'
    GRNQty,
    @EndUserText.label: 'Goods Amount(GRN)'
    GoodsAmountGRN,
    @EndUserText.label: 'Freight Amount(GRN)'
    FreightAmountGRN,
    @EndUserText.label: 'Tax Code'
    TaxCode,
    @EndUserText.label: 'Taxable Amount'
    TaxableAmount,
    @EndUserText.label: 'Total Payable'
    TotalPayable,
    @EndUserText.label: 'Freight Rate(Planned)'
    FreightRatePlanned,
    @EndUserText.label: 'Freight Rate(Actual)'
    FreightRateActual
}
