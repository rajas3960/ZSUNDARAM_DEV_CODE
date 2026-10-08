@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header one'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZIN_INVOICE_VIEW 
as select from I_BillingDocument as a 
inner join I_BillingDocumentItem as b on b.BillingDocument = a.BillingDocument
left outer join zdt_header_token as c on c.company = a.CompanyCode
left outer join I_Customer as d on d.Customer = a.SoldToParty
left outer join ZIN_INVOICE_TAX as e on e.BillingDocument = b.BillingDocument
                                    and e.BillingDocumentItem = b.BillingDocumentItem
left outer join I_OutboundDeliveryItem as f on f.OutboundDelivery = b.ReferenceSDDocument
                                    and f.OutboundDeliveryItem = b.ReferenceSDDocumentItem
left outer join I_OutboundDelivery as g on g.OutboundDelivery = f.OutboundDelivery                                                                        
{
    key a.BillingDocument as invoiceno,
    key b.BillingDocumentItem,
        a.BillingDocumentCategory as transtypecode,
        a.CompanyCode as systemcd,
        b.Plant as branchcd,
        a.Division as verticalcd,
        abap.string'A' as resultflag,
        a.BillingDocumentType as invoicetype,
        a.BillingDocumentDate as invoicedt,
        a.Region as pos,
        c.gstin as selfgstin,
        c.clientid,
        d.BPCustomerFullName as Cpgstinname,
        d.TaxNumber3 as cpgstin,
        b.TransactionCurrency,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        b.NetAmount as TaxableValue,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        e.CGSTAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        e.SGSTAmount,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        e.IGSTAmount,
        e.Taxrate,
        @Semantics.amount.currencyCode: 'TransactionCurrency'        
        cast(
              cast( e.NetAmount as abap.dec(15,2)) 
            + cast(coalesce(e.CGSTAmount,0) as abap.dec(15,2))
            + cast(coalesce(e.SGSTAmount,0) as abap.dec(15,2))
            + cast(coalesce(e.IGSTAmount,0) as abap.dec(15,2))
        as abap.dec(15,2)) as invoiceValue,
        
        g.ShippingPoint as PortCode
                
                 
                
}
