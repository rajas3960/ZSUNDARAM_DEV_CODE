@AbapCatalog.sqlViewName: 'ZVTMTBATCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMT Batch'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_TMTBATCH

  as select distinct from I_StockQuantityCurrentValue_2( P_DisplayCurrency: 'INR' )

{
  key Product,
  key Plant,
  key Batch

}
where
  //      Product                      = '000000000200000023'
      ProductType                  =    'ZFIN'
  and Plant                        =    '2008'
  and Batch                        like 'T%'
  and InventoryStockType           =    '01'
  and MatlWrhsStkQtyInMatlBaseUnit >    0
