@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZIN_HEAD_VIEW 
as select from I_BillingDocument as BOH
left outer join zdt_header_token as Comgst on Comgst.company = BOH.CompanyCode
left outer join I_Customer as Cus on Cus.Customer = BOH.SoldToParty

{
    key BOH.BillingDocument as Invoiceno,
        BOH.BillingDocumentDate as Invoicedt,
        BOH.CompanyCode,
        Comgst.gstin as Selfgstin,
        Comgst.clientid,
        Cus.BPCustomerFullName as Cpgstinname,
        Cus.TaxNumber3 as cpgstin   
}
