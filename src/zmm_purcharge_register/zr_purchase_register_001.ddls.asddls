@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZR_PURCHASE_REGISTER_001
  as select distinct from ZPURCHASE_REGISTER as a
{
       @EndUserText.label: 'GRN'
  key  a.Material_Document,
       @EndUserText.label: 'GR Year'
  key  a.Material_Document_Year,
       @EndUserText.label: 'GR Item'
  key  a.Material_Document_Item,
       @EndUserText.label: 'PO NO'
  key  a.Purchase_Order,
 
       
       @EndUserText.label: 'Freight Miro Doc no.'
  key  case when a.SupplierInvoice is null
   then 'No Invoice Posted'
   else a.SupplierInvoice end                                                                                                                                               as SupplierInvoice,
       @EndUserText.label: 'Supplier Invoice Item'
  key  case when a.SupplierInvoiceItem is null
   then 'No Item' else
   cast(a.SupplierInvoiceItem as abap.char( 10 ) ) end                                                                                                                      as SupplierInvoiceItem,
       @EndUserText.label: 'Supplier Invoice Year'
  key  case when a.Material_DocumentYear is null
  then '0000' else
  cast(a.Material_DocumentYear as abap.char(10) ) end                                                                                                                       as Material_DocumentYear,
       @EndUserText.label: 'Purchase Order Item'
       a.Purchase_OrderItem,
       @EndUserText.label: 'Supplier Code Goods'
       a.Supplier,
       @EndUserText.label: 'Supplier Code Goods Name'
       a.SupplierName,
       @EndUserText.label: 'PO Date'
       a.PO_Creation_Date,
        @EndUserText.label: 'Material Code'
       a.Material,   
       @EndUserText.label: 'Material Name'
       a.PoItemText,
       @EndUserText.label: 'GRN Date'
       a.documentdate,
       @EndUserText.label: 'Delivery Cost Accounting Document Number'
       a.Supplierinvoice1,
       @EndUserText.label: 'Transporter Plnned Code'
       a.FreightSupplier,
       @EndUserText.label: 'Transporter Planned Name'
       a.FreightSupplierName,
       @EndUserText.label: 'TPT Code -Act.'
       a.INVOICINGPARTY,
       @EndUserText.label: 'TPT Name -Act.'
       a.Supplier_name,
       a.STransactionCurrency as TransactionCurrency,
//       @Semantics.amount.currencyCode: 'TransactionCurrency'
//       @EndUserText.label: 'Freight Differintial Amount (Rs) On Actual Posting'
//       a.SUPPLIERINVOICEITEMAMOUNT,
       @EndUserText.label: 'Accounting Doc No for GRN'
       a.AccountingDocument,
       @EndUserText.label: 'Frt GL Code'
       a.GLAccount,
       @EndUserText.label: 'Freight GL NAME'
       a.GLAccountName,
//       @EndUserText.label: 'Diff. FRT GL (Diff amount Posted)'
//       @Semantics.amount.currencyCode: 'TransactionCurrency'
//       a.UnplannedDeliveryCost,
        @EndUserText.label: 'Movement Types'
       a.Movement_type,
        @EndUserText.label: 'Description'
       a.MovementTypeName,
       a.CompanyCode,
       a.MaterialBaseUnit,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        @EndUserText.label: 'GRN QTY'
       a.quantity,
       @EndUserText.label: 'Vehicle No'
       a.MaterialDocumentHeaderText,
       @EndUserText.label: 'Po freight condition type'
       a.ConditionTypeName,
       @EndUserText.label: 'Freight amount(Cond)'
       a.Freightamount,
       @EndUserText.label: 'Freight MIRO Status'
       a.FreightMiroStatus,
       @EndUserText.label: 'Unplanned Frt. Amt'
       a.AmountInCompanyCodeCurrency,
       @EndUserText.label: 'Unplanned Frt. GLcode'
       a.FrghtGLAccount,
       @EndUserText.label: 'Total Frt GRN QTY'
       a.TotalQuantity,
       @EndUserText.label: 'posting date'
       a.PODate
}
