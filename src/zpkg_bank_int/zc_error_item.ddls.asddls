@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Error Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_ERROR_ITEM
  as projection on ZI_error_item
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Transation ID'
  key Transactionid,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'UTR'
  key Utr,

      @EndUserText.label: 'Error Count'
  key Error_Count,
      @EndUserText.label: 'Error Text'
      Error,
      /* Associations */
      _Head : redirected to parent ZC_TRANSATION_REPORT
}
