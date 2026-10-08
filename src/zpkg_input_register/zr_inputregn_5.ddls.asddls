@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register_5'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREGN_5
  as select from ZR_INPUTREGN_3 as a
  left outer join ZR_SUPPLIER_VIEW as b on b.CompanyCode = a.CompanyCode
                                        and b.FiscalYear = a.FiscalYear
                                        and b.AccountingDocument = a.AccountingDocument
{
  key a.CompanyCode,
  key a.AccountingDocumentType,
  key a.FiscalYear,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.AccountingDocumentItemType,
  key a.GLAccount,
  
      case
            when ( a.IN_GSTPartner is initial or a.IN_GSTPartner is null ) then b.Supplier
            else a.IN_GSTPartner 
            end as IN_GSTPartner,
//      a.IN_GSTPartner,
      a.IN_HSNOrSACCode,
      a.Material,
      a.IN_GSTPlaceOfSupply,
      a.Plant,
      a.Product,
      a.ProfitCenter,
      a.PurchasingDocument,
      a.PurchasingDocumentItem,
      a.TaxItemAcctgDocItemRef,
      a.TransactionCurrency,
      a.CompanyCodeCurrency,
      a.TaxCode,
      a.TaxCodeName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.SGST * a.SGSTRatio                                   as SGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.CGST * a.CGSTRatio                                   as CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.IGST * a.IGSTRatio                                   as IGST,
      a.Rcmstat,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.RCMSGST * a.SGSTRatio                                as RCMSGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.RCMCGST * a.CGSTRatio                                as RCMCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.RCMIGST * a.IGSTRatio                                as RCMIGST,
      a.TransactionTypeDetermination,
      a.ValuationArea,
      a.DebitCreditCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInTransactionCurrency,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      (
       cast( a.AmountInTransactionCurrency as abap.dec( 23,2) )  +
      coalesce( cast(a.SGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.CGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.IGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.RCMSGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.RCMCGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.RCMIGST as abap.dec( 23,2) ), 0 ) ) as Totalinvval,
      a.Invoiceno,
      a.Invoicenoyr,
      a.DocumentDate,
      a.creationdate,
      a.DocumentReferenceID,
      a.ProductType,
      a.PurchaseOrderDate,
      a.GLAccountLongName,
      case
            when (a.SupplierName is initial or a.SupplierName is null )then b.BPSupplierFullName
            else a.SupplierName end as SupplierName,
            
//      a.SupplierName,
      case
            when (a.TaxNumber3 is initial or a.TaxNumber3 is null )then b.TaxNumber3
            else a.TaxNumber3 end  as TaxNumber3,
//      a.TaxNumber3,
      a.RegionName,
      a.ProductName,
      a.BusinessPlace,
      a.BusinessPlaceDescription,
      a.IN_GSTIdentificationNumber
      
}
