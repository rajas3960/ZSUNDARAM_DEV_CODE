@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservation Approval Header'
define root view entity ZR_RESVTTPH
  as select from    I_ReservationDocumentHeader
    left outer join ZR_RESVAPProvalttp as b on(
      I_ReservationDocumentHeader.Reservation = b.Resvno
    )
    left outer join zreservation_h     as c on(
      I_ReservationDocumentHeader.Reservation = c.reservation
    )
  //    inner join ZR_RESVAPPR1( id: $session.user ) on(
  //      I_ReservationDocumentHeader.GoodsRecipientName = ZR_RESVAPPR1.DeptCode
  //    )
  composition [0..*] of ZR_RESVITEMS as _Item
{

  key I_ReservationDocumentHeader.Reservation,
      I_ReservationDocumentHeader.ReservationCreationCode,
      I_ReservationDocumentHeader.ReservationOrigin,
      I_ReservationDocumentHeader.OrderID,
      I_ReservationDocumentHeader.GoodsMovementType,
      I_ReservationDocumentHeader.CostCenter,
      I_ReservationDocumentHeader.ProfitCenter,
      I_ReservationDocumentHeader.GoodsRecipientName,
      I_ReservationDocumentHeader.ReservationDate,
      I_ReservationDocumentHeader.Customer,
      cast( I_ReservationDocumentHeader.WBSElementInternalID as abap.char( 40 ) ) as WBSElementInternalID,
      I_ReservationDocumentHeader.NetworkNumberForAcctAssgmt,
      I_ReservationDocumentHeader.IssuingOrReceivingPlant,
      I_ReservationDocumentHeader.IssuingOrReceivingStorageLoc,
      I_ReservationDocumentHeader.ResvnVerificationCompanyCode,
      I_ReservationDocumentHeader.UserID,
      I_ReservationDocumentHeader.CreationDateTime,
      I_ReservationDocumentHeader.LastChangedByUser,
      I_ReservationDocumentHeader.LastChangeDateTime,
      case when b.Resvno is null
          then 'Created'
          when b.approved is not null
          then 'Approved'
          else 'Rejected'
          end                                                                     as status,
      cast( case  when b.Resvno is null then 2
                  else   3
                  end  as   abap.int1 )                                           as Criticality,
      ''                                                                          as tprint,
      @Semantics.largeObject: { mimeType: 'Mimetype', fileName: 'Filename', contentDispositionPreference: #INLINE }
      c.attachment                                                                as Attachment,
      @Semantics.mimeType: true
      c.mimetype                                                                  as Mimetype,
      c.filename                                                                  as Filename,
      _Item
}
