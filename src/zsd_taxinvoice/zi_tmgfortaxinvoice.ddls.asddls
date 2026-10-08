@EndUserText.label: 'TMG for Tax Invoice'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForTaxInvoice
  as select from zdt_invtax
  association to parent ZI_TmgForTaxInvoice_S as _TmgForTaxInvoiceAll on $projection.SingletonID = _TmgForTaxInvoiceAll.SingletonID
{
  key company_code as CompanyCode,
  email as Email,
  contact_no as ContactNo,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForTaxInvoiceAll
  
}
