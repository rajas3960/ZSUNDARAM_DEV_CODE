@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection ~ Payment Header'
@ObjectModel.usageType.sizeCategory: #XXL
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.dataClass:#MIXED
@Analytics.dataCategory: #CUBE
define root view entity ZC_PAY_HEADER
  //provider contract transactional_query
  as projection on ZI_PAYMENT_HEAD
{
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Payment Doc Number'
  key     Accountingdoc,
          @EndUserText.label: 'Fiscal Year'
  key     Fiscalyear,
          @EndUserText.label: 'Company Code'
  key     Companycode,
          @EndUserText.label: 'Payment Run ID'
          PaymentRunID,
          @EndUserText.label: 'Document Date'
          DocumentDate,
          @EndUserText.label: 'Posting Date'
          PostingDate,
          @EndUserText.label: 'Supplier'
          Supplier,
          @EndUserText.label: 'Supplier Name'
          SupplierName,
          @EndUserText.label: 'Payment Amount'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          //@DefaultAggregation: #SUM
          AmountInCompanyCodeCurrency,
          @EndUserText.label: 'Currency'
          CompanyCodeCurrency,
          @EndUserText.label: 'Payment Method'
          PaymentMethod,
          @EndUserText.label: 'House Bank'
          HouseBank,
          @EndUserText.label: 'House Bank Account'
          HouseBankAccount,
          @EndUserText.label: 'Own Bank Account Number'
          BankAccountNumber,
          @EndUserText.label: 'Vendor Bank Account'
          PayeeBankAccount,
          @EndUserText.label: 'Vendor IFSC'
          PayeeBankKey,
          @EndUserText.label: 'Vendor Bank Name'
          BankName,
          //          @EndUserText.label: 'Currency Key'
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PAY_HEAD'
          //  virtual UOM    : waers,
          //          @Semantics.amount.currencyCode: 'UOM'
          //          @EndUserText.label: 'Amount'
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PAY_HEAD'
          //  virtual amount : dmbtr,
          //          @EndUserText.label: 'Supplier Name'
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PAY_HEAD'
          //  virtual suppliername : abap.char(50),
          @EndUserText.label: 'Approval Level'
          apprlevel,
          @EndUserText.label: 'Level 1 Approver Remarks'
          Appr1comment,
          @EndUserText.label: 'Level 2 Approver Remarks'
          Appr2comment,
          @EndUserText.label: 'Status'
          Status,
          @EndUserText.label: 'Criticality'
          Criticality,
          @EndUserText.label: 'Sent on'
          Senton,
          @EndUserText.label: 'Sent At'
          Sentat,
          @EndUserText.label: 'Sent By'
          Sentby,
          @EndUserText.label: 'Sent By Full Name'
          PersonFullName,
          @EndUserText.label: 'UTR'
          Utr,
          @EndUserText.label: 'Message'
          Message,
          @EndUserText.label: 'Message Code'
          Messagecode,
          @EndUserText.label: 'Approved'
          Approved,
          @EndUserText.label: 'Rejected'
          Rejected,
          @EndUserText.label: 'In Progress'
          Inprocess,
          @EndUserText.label: 'Approve'
          Appr1,
          @EndUserText.label: 'Approve'
          Appr2,
          @EndUserText.label: 'Approve'
          Appr3,
          @EndUserText.label: 'Reject'
          Reject1,
          @EndUserText.label: 'Reject'
          Reject2,
          @EndUserText.label: 'Reject'
          Reject3,

          /* Associations */
          _item  : redirected to composition child ZC_INVOICE_ITEM,
          _item1 : redirected to composition child ZC_APPR_LOG
}
