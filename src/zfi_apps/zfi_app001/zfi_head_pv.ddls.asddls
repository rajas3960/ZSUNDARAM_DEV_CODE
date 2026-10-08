@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit-Debit Note Header Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZFI_HEAD_PV 
provider contract transactional_query
as projection on ZFI_HEAD_RV
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    @ObjectModel.text.element: [ 'AccountingDocumentTypeName' ]    
    AccountingDocumentType,
    AccountingDocumentTypeName,
    DocumentDate,
    OriginalReferenceDocument,
    PostingDate,
    CompanyCodeCurrency,
    @ObjectModel.text.element: [ 'SupplierName' ]
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
    @Semantics.largeObject: {   mimeType: 'mimetype', 
                                fileName: 'filename', 
                                contentDispositionPreference: #INLINE }
    attachment,
    filename,
    mimetype,
    createdat,
    createdby,
    /* Associations */
    _Item : redirected to composition child ZFI_ITEM_PV
}
