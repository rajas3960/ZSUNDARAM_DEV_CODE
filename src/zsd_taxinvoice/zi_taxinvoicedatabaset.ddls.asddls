@EndUserText.label: 'Tax invoice database table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TaxInvoiceDatabaseT
  as select from zdt_taxinvoice
  association to parent ZI_TaxInvoiceDatabaseT_S as _TaxInvoiceDatabaAll on $projection.SingletonID = _TaxInvoiceDatabaAll.SingletonID
{
  key company_code as CompanyCode,
  email as Email,
  contact_no as ContactNo,
  @Consumption.hidden: true
  1 as SingletonID,
  _TaxInvoiceDatabaAll
  
}
