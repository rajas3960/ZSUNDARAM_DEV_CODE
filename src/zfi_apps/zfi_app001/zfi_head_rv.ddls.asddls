@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit-Debit Note Header Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZFI_HEAD_RV 
as select from ZFI_HEAD_VIEW
composition [0..*] of ZFI_ITEM_RV as _Item
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    AccountingDocumentType,
    AccountingDocumentTypeName,
    DocumentDate,
    OriginalReferenceDocument,
    PostingDate,
    CompanyCodeCurrency,
    Supplier,
    Plant,
    SupplierName,
    GSTIN,
    PAN,
    CityName,
    PostalCode,
    StreetName,
    Region,
    Country,
    StreetPrefixName1,
    StreetPrefixName2,
    AddressTimeZone,
    formtype,
    attachment,
    filename,
    mimetype,
    createdby,
    createdat,
    _Item
}
