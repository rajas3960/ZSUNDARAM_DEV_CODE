@AbapCatalog.sqlViewName: 'ZVPRDTEXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product text f4'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_PRODUCTTEXT_F4
  as select from I_ProductText
{
  key Product,
  key ProductName
}
where
  Language = $session.system_language
