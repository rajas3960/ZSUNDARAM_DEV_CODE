@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Calculation Freight Header'
define view entity ZR_TAXDETAILS1
  as select from ZR_TAXDETAILS
{
    key InvoiceNumber
//    sum(Freight) as Freight
} 
//where FreightRate is not initial
//  group by InvoiceNumber
           
