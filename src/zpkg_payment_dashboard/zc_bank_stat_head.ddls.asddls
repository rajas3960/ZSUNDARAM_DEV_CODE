@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Head consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define root view entity ZC_bank_stat_head as projection on ZI_bank_stat_head
{
          @Search.defaultSearchElement: true
          @EndUserText.label: 'Payment Doc Number'
  key     Accountingdoc,
          @EndUserText.label: 'Fiscal Year'
  key     Fiscalyear,
          @EndUserText.label: 'Company Code'
  key     Companycode,
          @EndUserText.label: 'Payment Run ID'
          Paymentrunid,
          @EndUserText.label: 'Document Date'
          Documentdate,
          @EndUserText.label: 'Posting Date'
          Postingdate,
          @EndUserText.label: 'Supplier'
          Supplier,
          @EndUserText.label: 'Supplier Name'
          SupplierName,
          @EndUserText.label: 'Payment Amount'
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          Amountincompanycodecurrency,
          @EndUserText.label: 'Currency'
          Companycodecurrency,
          @EndUserText.label: 'Payment Method'
          PaymentMethod,
          @EndUserText.label: 'House Bank'
          Housebank,
          @EndUserText.label: 'House Bank Account'
          Housebankaccount,
          @EndUserText.label: 'Own Bank Account Number'
          Bankaccountnumber,
          @EndUserText.label: 'Vendor Bank Account'
          Payeebankaccount,
          @EndUserText.label: 'Vendor IFSC'
          Payeebankkey,
          @EndUserText.label: 'Vendor Bank Name'
          BankName,
          @EndUserText.label: 'Currency Key'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PAY_HEAD'
  virtual UOM          : waers,
          @Semantics.amount.currencyCode: 'UOM'
          @EndUserText.label: 'Amount'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PAY_HEAD'
  virtual amount       : dmbtr,
//          @EndUserText.label: 'Supplier Name'
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PAY_HEAD'
//  virtual suppliername : abap.char(50),
          @EndUserText.label: 'Approval Level'
          Apprlevel,
          @EndUserText.label: 'Level 1 Approver Remarks'
          Appr1comment,
          @EndUserText.label: 'Bank Initial Status Response'
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
          _item  : redirected to composition child ZC_bank_stat_item,
          _item1 : redirected to composition child zc_bank_stat_log
}
