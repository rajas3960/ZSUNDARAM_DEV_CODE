@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Head Print'
define view entity ZCDS_RES_HEAD
  as select from I_ReservationDocumentHeader as a
  inner join I_BusinessUserBasic as b on b.UserID = a.UserID 
{
  key a.Reservation,
      a.ReservationCreationCode,
      a.ReservationOrigin,
      a.OrderID,
      a.GoodsMovementType,
      a.CostCenter,
      a.ProfitCenter,
      a.ControllingArea,
      a.GoodsRecipientName,
      a.ReservationDate,
      a.IsCheckedAgainstFactoryCal,
      a.Customer,
      a.WBSElementInternalID,
      a.SalesOrder,
      a.SalesOrderItem,
      a.SalesOrderScheduleLine,
      a.AssetNumber,
      a.AssetSubNumber,
      a.NetworkNumberForAcctAssgmt,
      a.IssuingOrReceivingPlant,
      a.IssuingOrReceivingStorageLoc,
      a.ResvnVerificationCompanyCode,
      a.UserID,
      a.CreationDateTime,
      a.LastChangedByUser,
      a.LastChangeDateTime,
      b.PersonFullName
      

}
