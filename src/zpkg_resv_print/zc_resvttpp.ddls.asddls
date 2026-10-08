@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption For Reservation Print Header'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity zc_resvttpp
  provider contract transactional_query
  as projection on ZR_RESVTTPH
{

      @EndUserText.label: 'Reservation'
  key Reservation,
      @EndUserText.label: 'Order Id'
      OrderID,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Movement Type'
      GoodsMovementType,
      @EndUserText.label: 'Cost Center'
      CostCenter,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Goods Recipient Name'
      GoodsRecipientName,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'WBS ElementInternal ID'
      WBSElementInternalID,
      @EndUserText.label: 'Issuing Or Receiving Plant'
      IssuingOrReceivingPlant,
      @EndUserText.label: 'Issuing Or Receiving StorageLoc'
      IssuingOrReceivingStorageLoc,
      @EndUserText.label: 'Resvn Verification Company Code'
      ResvnVerificationCompanyCode,
      @EndUserText.label: 'User ID'
      UserID,
      @EndUserText.label: 'Creation Date Time'
      CreationDateTime,
      @EndUserText.label: 'Last Changed By User'
      LastChangedByUser,
      @EndUserText.label: 'Last Change Date Time'
      LastChangeDateTime,
      @EndUserText.label: 'Status'
      status,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'print'
      tprint,
      @EndUserText.label: 'print'
      Attachment,
      @Semantics.mimeType: true
      @EndUserText.label: 'Mime Type'
      Mimetype,
      @EndUserText.label: 'File Name'
      Filename,

      /* Associations */
      _Item : redirected to composition child zc_resvitems
}
where
  OrderID is initial
