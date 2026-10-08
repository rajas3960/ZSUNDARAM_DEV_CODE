@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register-JEI'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_PUR_REG
  as select distinct from I_MaterialDocumentItem_2      as matdocitem
    left outer join       I_SuplrInvcItemPurOrdRefAPI01 as suppinvoice on  suppinvoice.PurchaseOrder               = matdocitem.PurchaseOrder
                                                                       and suppinvoice.PurchaseOrderItem           = matdocitem.PurchaseOrderItem
                                                                       and suppinvoice.ReferenceDocumentFiscalYear = matdocitem.MaterialDocumentYear
                                                                       and suppinvoice.ReferenceDocument           = matdocitem.InvtryMgmtReferenceDocument
                                                                       and suppinvoice.ReferenceDocumentItem       = matdocitem.MaterialDocumentItem
                                                                       and suppinvoice.ReferenceDocumentFiscalYear = matdocitem.ReferenceDocumentFiscalYear


    left outer join       I_JournalEntryItem            as JEI         on  JEI.PurchasingDocument           = suppinvoice.PurchaseOrder
                                                                       and JEI.PurchasingDocumentItem       = suppinvoice.PurchaseOrderItem
                                                                       and JEI.ReferenceDocument            = suppinvoice.ReferenceDocument
                                                                       and JEI.Ledger                       = '0L'
                                                                       and JEI.TransactionTypeDetermination = 'EIN'
{


  key  matdocitem.MaterialDocument     as Material_Document,
  key  matdocitem.MaterialDocumentYear as Material_Document_Year,
  key  matdocitem.MaterialDocumentItem as Material_Document_Item,
  key  matdocitem.PurchaseOrder        as Purchase_Order,
  key  suppinvoice.SupplierInvoice     as SupplierInvoice,
  key  suppinvoice.SupplierInvoiceItem as SupplierInvoiceItem,
  key  suppinvoice.FiscalYear          as Material_DocumentYear,
  key  matdocitem.PurchaseOrderItem    as Purchase_OrderItem,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       JEI.AmountInCompanyCodeCurrency,
       JEI.CompanyCodeCurrency

}
