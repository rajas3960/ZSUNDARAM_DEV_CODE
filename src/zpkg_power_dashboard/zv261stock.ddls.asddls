@AbapCatalog.sqlViewName: 'ZZVSTOCK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock'
@Metadata.ignorePropagatedAnnotations: true
define view ZV261STOCK
  as select from I_StockQuantityCurrentValue_2( P_DisplayCurrency: 'INR' )
{
  key Product,
  key Plant,
  key StorageLocation,
  key Batch,
  key Supplier,
  key SDDocument,
  key SDDocumentItem,
  key WBSElementInternalID,
  key Customer,
  key SpecialStockIdfgStockOwner,
  key InventoryStockType,
  key InventorySpecialStockType,
  key MaterialBaseUnit,
  key Currency,
      DisplayCurrency,
      ValuationAreaType,
      MatlWrhsStkQtyInMatlBaseUnit,
      StockValueInCCCrcy,
      StockValueInDisplayCurrency,
      ProductGroup,
      ProductType

}
