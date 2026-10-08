@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register Final'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_INPUTREGN_FINAL
  as select distinct from ZR_INPUTREGN_5 as a
  inner join zdt_user_auth as user on a.CompanyCode = user.companycode
                                   and user.cbuser = $session.user
{
  key a.CompanyCode,
  key a.AccountingDocumentType,
  key a.FiscalYear,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.AccountingDocumentItemType,
  key a.GLAccount,
      a.IN_GSTPartner,
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
      a.SGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.IGST,
      a.Rcmstat,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.RCMSGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.RCMCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.RCMIGST,
      a.TransactionTypeDetermination,
      a.ValuationArea,
      a.DebitCreditCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInTransactionCurrency,
      (
       cast( a.AmountInTransactionCurrency as abap.dec( 23,2) )  +
      coalesce( cast(a.SGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.CGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.IGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.RCMSGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.RCMCGST as abap.dec( 23,2) ), 0 ) +
      coalesce( cast(a.RCMIGST as abap.dec( 23,2) ), 0 ) ) as ttlinvvalue,
      a.Invoiceno,
      a.Invoicenoyr,
      a.DocumentDate as Invoicedate,
      a.DocumentDate,
      a.creationdate,
      a.DocumentReferenceID,
      a.ProductType,
      a.PurchaseOrderDate,
      a.GLAccountLongName,
      a.SupplierName,
      a.TaxNumber3,
      a.RegionName,
      a.ProductName,
      a.BusinessPlace,
      a.BusinessPlaceDescription,
      a.IN_GSTIdentificationNumber
}
where       a.AccountingDocumentType <> 'DR' 
        and a.AccountingDocumentType <> 'DG' 
        and a.AccountingDocumentType <> 'DA' 
        and a.AccountingDocumentType <> 'DZ'
        and a.AccountingDocumentType <> 'RV' 

