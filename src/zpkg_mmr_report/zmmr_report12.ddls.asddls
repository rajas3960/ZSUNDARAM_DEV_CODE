@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MMR REPORT 12'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMMR_REPORT12
  with parameters
    @EndUserText.label: 'From Date'
    p_from_date : datum,
    @EndUserText.label: 'To Date'
    p_to_date   : datum,
    @Consumption.valueHelpDefinition: [{ entity : { name: 'I_PlantStdVH' , element: 'Plant' }, useForValidation: true }]
    p_plant     : werks_d
  as select from ZMMR_REPORT(p_from_date : $parameters.p_from_date , p_to_date : $parameters.p_to_date , p_plant : $parameters.p_plant) as A
{
      @EndUserText.label: 'Material'
  key A.Material,
      @EndUserText.label: 'Plant'
  key A.Plant,
      @EndUserText.label: 'Material Type'
      A.MaterialType,
      @EndUserText.label: 'Material Decription'
      A.MaterialDescription,
      @EndUserText.label: 'Base Unit Of Measure'
      A.BaseUom,
      @EndUserText.label: 'Material Group'
      A.MaterialGroup,
      @EndUserText.label: 'Valuation Class'
      A.ValuationClass,
      @EndUserText.label: 'Currency'
      A.Currency,
      @EndUserText.label: 'Profit Center'
      A.ProfitCenter,
      A.PeriodFrom,
      A.PeriodTo,
      A.MaterialBaseUnit,
      @EndUserText.label: 'Opening Qty'
      //     @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.OpeningQty,
      @EndUserText.label: 'Closing Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.ClosingQty,
      @EndUserText.label: 'Production Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.ProductionQty,

      A.CompanyCodeCurrency,
      //       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Production Value'
      A.ProductionValue,
      @EndUserText.label: 'Purchase Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.PurchaseQty,
      @EndUserText.label: 'Purchase Value'
      //       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.PurchaseValue,
      @EndUserText.label: 'Return Quantity'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.ReturnQty,
      @EndUserText.label: 'Return Value'
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.ReturnValue,
      @EndUserText.label: 'Issue to Order Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.IssueToOrderQty,
      @EndUserText.label: 'Issue to Order Value'
      //     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.IssueToOrderValue,
      @EndUserText.label: 'Issue to Asset Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.IssueToAssetsQty,
      @EndUserText.label: 'Issue to Asset Value'
      //     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.IssueToAssetsValue,
      @EndUserText.label: 'Sale Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.SaleQty,
      @EndUserText.label: 'Sale Value'
      //     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.SaleValue,
      @EndUserText.label: 'Scrap Qty'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.ScrapQty,
      @EndUserText.label: 'Scrap Value'
      //     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.ScrapValue,
      @EndUserText.label: 'Physical adjustment Qty'
      //    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.PhysicalAdjustmentQty,
      @EndUserText.label: 'Physical Adjutment Value'
      //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.PhysicalDifferenceValue,
      @EndUserText.label: 'Sub Contr Cons Qty'
      //    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      A.SubContractConsQty,
      @EndUserText.label: 'Sub Cont Cons Val'
      //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.SubContractConsValue,

      @EndUserText.label: 'General Consumption Qty'
      A.GenConsumpQty,
      @EndUserText.label: 'General Consumption Value'
      A.GenConsumpValue,

      @EndUserText.label: 'Goods Issue to Project Qty'
      A.GItoPrjQty,
      @EndUserText.label: 'Goods Issue to Project Value'
      A.GItoPrjValue,
      @EndUserText.label: 'Goods Issue Transfer Out Qty'
      A.GITransferOutQty,
      @EndUserText.label: 'Goods Issue Transfer Out Value'
      A.GITransferOutValue,
      @EndUserText.label: 'Goods Issue Transfer In Qty'
      A.GITransferInQty,
      @EndUserText.label: 'Goods Issue Transfer In Value'
      A.GITransferInValue,
      @EndUserText.label: 'Goods At Subcontract Qty'
      A.GoodsAtSubcontractQty,
      @EndUserText.label: 'Goods At Subcontract Value'
      A.GoodsAtSubcontractValue,
      @EndUserText.label: 'Goods Issue Transfer Qty'
      A.GITransferQty,
      @EndUserText.label: 'Goods Issue Transfer Value'
      A.GITransferValue,
      @EndUserText.label: 'Goods Return Qty'
      A.GRReturnQty,
      @EndUserText.label: 'Goods Return Value'
      A.GRReturnValue,

      @EndUserText.label: 'Opening Value'
      A.OpeningValue,
      @EndUserText.label: 'Closing Value'
      A.ClosingValue
}
