@AbapCatalog.sqlViewName: 'ZZBRE01'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billet Rework batch haet'
@Metadata.ignorePropagatedAnnotations: true
define view ZVBREBATCH01
  as select from I_ManufacturingOrder
{
  key ManufacturingOrder,
      Product,
      dats_add_days( CreationDate, 30, 'INITIAL' )  as FutureDate,
      dats_add_days( CreationDate, -30, 'INITIAL' ) as PrevDate

}

where
     ManufacturingOrderType = 'ZBIL'
  or ManufacturingOrderType = 'ZREW'
