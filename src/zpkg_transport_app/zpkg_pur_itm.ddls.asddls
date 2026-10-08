@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPKG_PUR_ITM
  as select from I_PurchaseOrderAPI01     as po
    left outer join       I_PurchaseOrderItemAPI01 as poi on poi.PurchaseOrder = po.PurchaseOrder
    
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
                                                                       
left outer join       I_Supplier                     as Sup1       on price.FreightSupplier = Sup1.Supplier

left outer join       I_Supplier                     as sup        on SPI.InvoicingParty = sup.Supplier

left outer join I_JournalEntryItem                   as JEI        on JEI.ReferenceDocument = Supinvoice.SupplierInvoice
                                                                      and JEI.Ledger = '0L'
                                                                      and JEI.GLAccount = '0000475014'
  
association to parent ZPKG_PUR_HDR as _Hdr
  on  $projection.PurchaseOrder        = _Hdr.Purchase_Order
  and $projection.PurchaseOrderItem    = _Hdr.Purchase_Order_Item
  and $projection.SupplierInvoice      = _Hdr.SupplierInvoice
  and $projection.SupplierInvoiceItem  = _Hdr.SupplierInvoiceItem
                                                                                                               
                                                                       
{
  key poi.PurchaseOrder,
  key poi.PurchaseOrderItem,
//  key price.PricingDocument,
//  key price.PricingDocumentItem,
//  key price.PricingProcedureStep,
//  key price.PricingProcedureCounter,
  key Supinvoice.SupplierInvoice,
  key Supinvoice.SupplierInvoiceItem,
 // key sup.Supplier as Supplier1,
      price.PricingDocument,
      price.PricingDocumentItem,
      price.PricingProcedureStep,
      price.PricingProcedureCounter,
      sup.Supplier as Supplier1,
      poi.CompanyCode,
      poi.PurchaseOrderQuantityUnit,
      price.FreightSupplier,
      price.TransactionCurrency,
      Supinvoice.SuplrInvcDeliveryCostCndnType,
      Supinvoice.SupplierInvoice as SupplierInvoice1,
      Sup1.SupplierName as FreightSupplierName,
      sup.SupplierName as  SupplierName1,
      SPI.InvoicingParty,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SPI.UnplannedDeliveryCost,
      CT.ConditionTypeName,
      ltrim(JEI.GLAccount, '0') as FrghtGLAccount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JEI.AmountInCompanyCodeCurrency,
      _Hdr
      
      
      
}
where (price.ConditionType      = 'ZLC1'
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
                                                                          or price.ConditionType   = 'ZOPC')
