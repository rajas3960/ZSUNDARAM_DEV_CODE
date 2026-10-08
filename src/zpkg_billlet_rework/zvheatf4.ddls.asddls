@AbapCatalog.sqlViewName: 'ZZVHEAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Heat f4'
@Metadata.ignorePropagatedAnnotations: true
define view ZVHEATF4
  as select distinct from I_StockQuantityCurrentValue_2( P_DisplayCurrency:'INR' )
{
  key Batch,
  key Product,
  key Plant,
  key StorageLocation


}
where
      InventoryStockType           = '01'
  and MatlWrhsStkQtyInMatlBaseUnit > 0

//  and Product                      = '000000000150000021'
