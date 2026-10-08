@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_address

as select from    I_BillingDocumentBasic        as bdb
    left outer join      I_CompanyCode                 as cc      on  cc.CompanyCode = bdb.CompanyCode
                                                             and cc.Language    = $session.system_language
    left outer join I_Customer                    as pyr     on pyr.Customer = bdb.PayerParty                                                         
{
    
      key bdb.CompanyCode                             as ccode,
  key bdb.BillingDocument                         as billdoc,
      bdb.BillingDocumentType                     as billtyp,
      bdb.SalesOrganization                       as sorg,
      bdb.DistributionChannel                     as distchn,
      bdb.Division                                as divsn,
      bdb.BillingDocumentDate                     as billdate,
      bdb.DocumentReferenceID                     as refdoc,
      bdb.InvoiceListType                         as invlstyp,
      bdb.ShippingCondition                       as shpcond,
      bdb.IncotermsClassification                 as incotyp,
      bdb.IncotermsLocation1                      as incoloc1,
      bdb.CustomerPaymentTerms                    as payterms,
      bdb.PayerParty                              as payer,
      bdb.SoldToParty                             as customer,
      bdb.OverallSDProcessStatus                  as sddocsts,
      bdb.OverallBillingStatus                    as billsts,
      bdb.AccountingPostingStatus,
      bdb.AccountingTransferStatus,
      bdb.TransactionCurrency                     as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      bdb.TotalNetAmount                          as Netamt,
      @Semantics.amount.currencyCode: 'Curky'
      bdb.TotalTaxAmount                          as Taxamt,
      @Semantics.amount.currencyCode: 'Curky'
      ( bdb.TotalNetAmount + bdb.TotalTaxAmount ) as Totamt,
      bdb.AccountingDocument                      as accdoc,
      bdb.InvoiceClearingStatus                   as clrsts,
      pyr.Customer                                as Payerid,
      pyr.AddressID                               as Pyraddrid,
      pyr.BPCustomerFullName                      as payertxt,
      pyr.TaxNumber3                              as BilltoGSTIN,
      pyr.Country                                 as BilltoCountry,
      pyr.StreetName                              as BilltoStreetName,
      pyr.Region                                  as BilltoRegion,
      pyr.PostalCode                              as Billtopostalcode,
      pyr.TaxNumber3                              as payergst
    
}
