@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Advice Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define root view entity ZC_PAYADV_HEAD
provider contract transactional_query
as projection on ZI_PAYADV_HEAD
{   
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Payment Doc Number'
    key Accountingdoc,
    @EndUserText.label: 'Fiscal Year'
    key Fiscalyear,
    @EndUserText.label: 'Company Code'
    key Companycode,
    @EndUserText.label: 'Run ID'
    Paymentrunid,
    @EndUserText.label: 'Document Date'
    Documentdate,
    @EndUserText.label: 'Posting Date'
    Postingdate,
    @EndUserText.label: 'Value Date'
    ValueDate,
    @EndUserText.label: 'Supplier'
    Supplier,
    @EndUserText.label: 'Supplier Name'
    suppliername,
    @EndUserText.label: 'Street Name'
    StreetName,
    @EndUserText.label: 'City Name'
    CityName,
    @EndUserText.label: 'District Name'
    DistrictName,
    @EndUserText.label: 'Phone No'
    PhoneNumber1,
    @EndUserText.label: 'Phone No'
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_EMAIL'
    Email,
    @EndUserText.label: 'GSTIN'
    TaxNumber3,
    @EndUserText.label: 'Payment Amount'
    @Semantics.amount.currencyCode: 'Companycodecurrency'
    Amountincompanycodecurrency,
    @EndUserText.label: 'Currency'
    Companycodecurrency,
    @EndUserText.label: 'Payment Method'
    Paymentmethod,
    @EndUserText.label: 'House Bank'
    Housebank,
    @EndUserText.label: 'House Bank Account'
    Housebankaccount,
    @EndUserText.label: 'Bank Name'
    BankName,
    @EndUserText.label: 'Bank Account Number'
    Bankaccountnumber,
    @EndUserText.label: 'Payee Bank Account'
    Payeebankaccount,
    @EndUserText.label: 'Payee IFSC'
    Payeebankkey,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'UTR'
    Utr,
    /* Associations */
    _item : redirected to composition child ZC_PAYADV_ITEM
}
