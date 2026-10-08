@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PURCHASE REGISTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPURCHASE_REG_002
  as select distinct from I_PurchaseOrderAPI01           as po
    left outer join       I_PurchaseOrderItemAPI01       as poi        on poi.PurchaseOrder = po.PurchaseOrder

  // ---- Product Master ----
    left outer join       I_Product                      as prod       on  prod.Product     = poi.Material
                                                                       and prod.ProductType = poi.MaterialType



  // ---- Pricing (Filtered to avoid duplicates) ----

    left outer join       I_PurOrdItmPricingElementAPI01 as price      on  price.PurchaseOrder     = poi.PurchaseOrder
                                                                       and price.PurchaseOrderItem = poi.PurchaseOrderItem
                                                                       and (
                                                                          price.ConditionType      = 'ZLC1'
                                                                          or price.ConditionType   = 'ZLC2'
                                                                          or price.ConditionType   = 'ZUC1'
                                                                          or price.ConditionType   = 'ZUC2'
                                                                          or price.ConditionType   = 'ZEF1'
                                                                          or price.ConditionType   = 'ZEF2'
                                                                          or price.ConditionType   = 'ZIF1'
                                                                          or price.ConditionType   = 'ZIF2'
                                                                          or price.ConditionType   = 'ZPF1'
                                                                          or price.ConditionType   = 'ZPF2'
                                                                          or price.ConditionType   = 'ZPF3'
                                                                          or price.ConditionType   = 'ZIS1'
                                                                          or price.ConditionType   = 'ZIS2'
                                                                          or price.ConditionType   = 'ZIS3'
                                                                          or price.ConditionType   = 'ZOT1'
                                                                          or price.ConditionType   = 'ZOT2'
                                                                          or price.ConditionType   = 'ZOT3'
                                                                          or price.ConditionType   = 'ZESC'
                                                                          or price.ConditionType   = 'ZMTC'
                                                                          or price.ConditionType   = 'ZOPC'
                                                                          //                                                                          or price.ConditionType       = 'PMP0'
                                                                          //                                                                          or price.ConditionType       = 'ZABD'
                                                                          //                                                                          or price.ConditionType       = 'ZADV'
                                                                          //                                                                          or price.ConditionType       = 'ZDPQ'

                                                                        )
                                                                       and price.ConditionAmount   is not initial

    left outer join       I_SuplrInvcItemPurOrdRefAPI01  as Supinvoice on  price.PurchaseOrder     = Supinvoice.PurchaseOrder
                                                                       and price.ConditionType     = Supinvoice.SuplrInvcDeliveryCostCndnType
                                                                       and price.PurchaseOrderItem = Supinvoice.PurchaseOrderItem
    left outer join       I_ConditionTypeText            as CT         on CT.ConditionType = price.ConditionType

    left outer join       I_SupplierInvoiceAPI01         as SPI        on SPI.SupplierInvoice = Supinvoice.SupplierInvoice

    left outer join       I_Supplier                     as sup        on SPI.InvoicingParty = sup.Supplier

    left outer join       I_Supplier                     as Sup1       on price.FreightSupplier = Sup1.Supplier





  // Select only Base Price → no duplicates
{
      // ===== KEY FIELDS =====
  key poi.PurchaseOrder,
  key poi.PurchaseOrderItem,
  key price.PricingDocument,
  key price.PricingDocumentItem,
  key price.PricingProcedureStep,
  key price.PricingProcedureCounter,
  key Supinvoice.SupplierInvoice,
  key Supinvoice.SupplierInvoiceItem,
  key sup.Supplier                      as Supplier1,
      Supinvoice.SuplrInvcDeliveryCostCndnType,
      // ===== BASIC PO DATA =====
      poi.PurchaseRequisition,
      poi.PurchaseRequisitionItem,
      po.PurchaseOrderType,

      poi.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      poi.GrossAmount,
      poi.CompanyCode,

      poi.Material,
      poi.MaterialGroup,
      poi.MaterialType,
      poi.PurchaseOrderItemText,
      poi.PurchaseOrderQuantityUnit,

      // ===== PRODUCT MASTER (I_Product) =====
      prod.Product,
      prod.ProductType,
      prod.BaseUnit,
      prod.ProductExternalID,
      prod.ProductCategory,
      prod.ProductOldID,
      prod.CountryOfOrigin,
      // prod.NetWeight,
      // prod.GrossWeight,

      // ===== PRICING (I_PurOrdItmPricingElementAPI01) =====
      price.ConditionType,
      price.ConditionRateValue,
      price.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      price.ConditionAmount,
      price.ConditionScaleBasisValue,
      price.ConditionBaseValue,
      price.FreightSupplier,
      //    price.CalculationType,
      //    price.PricingDate
      sup.SupplierName                  as SupplierName1,
      Sup1.SupplierName                 as FreightSupplierName,
      Supinvoice.SuplrInvcDeliveryCostCndnCount,
      Supinvoice.SupplierInvoice        as Supplierinvoice1,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Supinvoice.SupplierInvoiceItemAmount,
      SPI.SupplierInvoiceIDByInvcgParty as InvoiceID,
      SPI.InvoicingParty,
      CT.ConditionTypeName,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SPI.UnplannedDeliveryCost

}

where //Supinvoice.SupplierInvoice is not initial and
  (
       price.ConditionType = 'ZLC1'
    or price.ConditionType = 'ZLC2'
    or price.ConditionType = 'ZUC1'
    or price.ConditionType = 'ZUC2'
    or price.ConditionType = 'ZEF1'
    or price.ConditionType = 'ZEF2'
    or price.ConditionType = 'ZIF1'
    or price.ConditionType = 'ZIF2'
    or price.ConditionType = 'ZPF1'
    or price.ConditionType = 'ZPF2'
    or price.ConditionType = 'ZPF3'
    or price.ConditionType = 'ZIS1'
    or price.ConditionType = 'ZIS2'
    or price.ConditionType = 'ZIS3'
    or price.ConditionType = 'ZOT1'
    or price.ConditionType = 'ZOT2'
    or price.ConditionType = 'ZOT3'
    or price.ConditionType = 'ZESC'
    or price.ConditionType = 'ZMTC'
    or price.ConditionType = 'ZOPC'
  )
