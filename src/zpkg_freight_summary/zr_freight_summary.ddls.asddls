@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Summary Report Final CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_FREIGHT_SUMMARY
  as select distinct from I_MaterialDocumentItem_2       as MDI
    inner join            I_MaterialDocumentHeader_2     as MDH    on  MDH.MaterialDocument     = MDI.MaterialDocument
                                                                   and MDH.MaterialDocumentYear = MDI.MaterialDocumentYear

  //    left outer join I_SupplierInvoiceAPI01         as SI  on  SI.SupplierInvoice = MDI.Supplier
  //                                                          and SI.FiscalYear      = MDI.MaterialDocumentYear

    left outer join       ZI_GATEHEAD                    as GP     on  GP.gatepassno        = MDI.YY1_GATEPASS_MMI
                                                                   and MDI.YY1_GATEPASS_MMI is not initial

    left outer join       I_PurOrdItmPricingElementAPI01 as FS     on  FS.PurchaseOrder     = MDI.PurchaseOrder
                                                                   and FS.PurchaseOrderItem = MDI.PurchaseOrderItem
                                                                   and FS.FreightSupplier   is not initial
                                                                   and MDI.PurchaseOrder    is not initial

    left outer join       I_Supplier                     as S      on  S.Supplier         = FS.FreightSupplier
                                                                   and FS.FreightSupplier is not initial

    left outer join       ZR_FS_JOURNALENTRY             as JE_WRX on  JE_WRX.MaterialDocument             = MDI.MaterialDocument
                                                                   and JE_WRX.MaterialDocumentYear         = MDI.MaterialDocumentYear
                                                                   and JE_WRX.ReferenceDocument            = MDI.MaterialDocument
                                                                   and JE_WRX.ReferenceDocumentItem        = MDI.MaterialDocumentItem
                                                                   and JE_WRX.TransactionTypeDetermination = 'WRX'

    left outer join       ZR_FS_JOURNALENTRY             as JE_FR1 on  JE_FR1.MaterialDocument             = MDI.MaterialDocument
                                                                   and JE_FR1.MaterialDocumentYear         = MDI.MaterialDocumentYear
                                                                   and JE_FR1.ReferenceDocument            = MDI.MaterialDocument
                                                                   and JE_FR1.ReferenceDocumentItem        = MDI.MaterialDocumentItem
                                                                   and JE_FR1.TransactionTypeDetermination = 'FR1'

{
  key      MDI.PurchaseOrder                                as PO,
  key      MDI.PurchaseOrderItem                            as POItem,
  key      MDI.CompanyCode                                  as CompanyCode,
  key      MDI.MaterialDocument                             as GRNNo,
  key      MDI.MaterialDocumentItem                         as GRNItem,
  key      MDI.MaterialDocumentYear                         as GRNYear,
  key      MDI.DocumentDate                                 as GRNDocDate,
  key      MDI.PostingDate                                  as GRNPostingDate,
           //  key   SI.SupplierInvoice as FreightInvoice,
           //  key   SupplierInvoiceItem as FreightInvoiceItem,
  key      ''                                               as FreightInvoice,
  key      ''                                               as FreightInvoiceItem,
           ////  key   FS.ConditionType,
  key      FS.FreightSupplier                               as TransporterPO,
           S.BPSupplierFullName                             as TransporterNamePO,
           //      SI.ReverseDocument as ReverseDocument,
           ''                                               as ReverseDocument,
           MDI.Material                                     as Material,
           MDI.Plant                                        as Plant,
           MDI.MaterialBaseUnit                             as UOM,
           MDI.YY1_GATEPASS_MMI                             as GatePassNo,
           GP.Trasporterno                                  as TransporterNoGatePass,
           GP.Transportername                               as TransporterNameGatePass,

           cast(MDI.QuantityInEntryUnit as abap.dec(13,3) ) as GRNQty,
           JE_WRX.Amt                                       as GoodsAmountGRN,
           cast(coalesce(JE_FR1.Amt,0) as abap.dec(23,2))   as FreightAmountGRN,
           //        cast(cast(coalesce(JE_FR1.Amt,0) as abap.dec(23,2)) as abap.char(30)) as FreightAmountGRN,
           ''                                               as TaxCode,
           ''                                               as TaxableAmount,
           ''                                               as TotalPayable,
           //        cast(SI.InvoiceGrossAmount as abap.dec(13,2))    as TotalPayable,
           //        ''                                               as FreightRatePlanned,
           case when MDI.QuantityInEntryUnit is not initial and MDI.QuantityInEntryUnit is not null
           //             then cast( $projection.FreightAmountGRN / MDI.QuantityInEntryUnit as abap.dec(15,3))
                then cast( cast(coalesce(JE_FR1.Amt,0) as abap.dec(23,2)) / MDI.QuantityInEntryUnit as abap.dec(15,3))
                else cast(0 as abap.dec(15,3))
           end                                              as FreightRatePlanned,
           ''                                               as FreightRateActual

}
where
       MDH.AccountingDocumentType = 'WE'
  and(
       MDI.GoodsMovementType      = '101'
    or MDI.GoodsMovementType      = '102'
    or MDI.GoodsMovementType      = '103'
    or MDI.GoodsMovementType      = '105'
    or MDI.GoodsMovementType      = '121'
    or MDI.GoodsMovementType      = '122'
    or MDI.GoodsMovementType      = '161'
    or MDI.GoodsMovementType      = '162'
  )
  and(
       FS.ConditionType           = 'ZEF1'
    or FS.ConditionType           = 'ZEF2'
  )
