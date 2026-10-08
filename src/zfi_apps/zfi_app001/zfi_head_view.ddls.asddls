@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit and Debit Note Header View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_HEAD_VIEW 
as select from I_JournalEntry as JOH 
left outer join I_JournalEntryItem as JOI on JOI.AccountingDocument = JOH.AccountingDocument
                                           and JOI.FiscalYear = JOH.FiscalYear
                                           and JOI.CompanyCode = JOH.CompanyCode
                                           and JOI.Ledger = '0L'
                                           and JOI.LedgerGLLineItem = '000001'
left outer join ZSUPPLIER_ADD as SupAdd on SupAdd.Supplier = JOI.Supplier
left outer join I_AccountingDocumentTypeText as Acctext on Acctext.AccountingDocumentType = JOH.AccountingDocumentType
                                            and Acctext.Language = $session.system_language
left outer join zfi_form_db as Form on Form.accountingdocument = JOH.AccountingDocument
                                     and Form.companycode = JOH.CompanyCode
                                     and Form.fiscalyear = JOH.FiscalYear
{
    key JOH.AccountingDocument,
    key JOH.FiscalYear,
    key JOH.CompanyCode,
        JOH.AccountingDocumentType,
        Acctext.AccountingDocumentTypeName,
        JOH.DocumentDate,
        JOH.OriginalReferenceDocument,
        JOH.PostingDate,
        JOH.CompanyCodeCurrency,
        JOH.TransactionCode,
        JOH.DocumentReferenceID,
        JOI.Supplier,
        JOI.Plant,
        JOI.ReferenceDocument as MiroNo,
        SupAdd.SupplierName,
        SupAdd.GSTIN,
        SupAdd.PAN,
//        SupAdd.EmailAddress,
        SupAdd.CityName,
        SupAdd.PostalCode,
        SupAdd.StreetName,
        SupAdd.Region,
        SupAdd.Country,
        SupAdd.StreetPrefixName1,
        SupAdd.StreetPrefixName2,
        SupAdd.AddressTimeZone,
        Form.formtype,
        Form.attachment,
        Form.filename,
        Form.mimetype,
        Form.createdby,
        Form.createdat
}
where JOH.AccountingDocumentType = 'KG' or 
      JOH.AccountingDocumentType = 'KR' or
      JOH.AccountingDocumentType = 'RE';
