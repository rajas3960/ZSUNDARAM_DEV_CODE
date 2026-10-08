@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Code for Freight Summary Rep'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_FS_TAXCODE
  as select from I_SuplrInvcItemPurOrdRefAPI01 as si
    inner join   I_TaxCodeText                 as tc on  tc.TaxCode  = si.TaxCode
                                                     and tc.Language = 'E'

{
  si.SupplierInvoice,
  si.FiscalYear,
  si.SupplierInvoiceItem,
  si.TaxCode,
  tc.TaxCodeName
}
