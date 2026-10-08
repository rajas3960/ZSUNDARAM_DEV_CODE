@ObjectModel.query.implementedBy: 'ABAP:ZCL_RES_BO_IMPL'
@EndUserText.label: 'Quality Print'
define custom entity ZI_RES_HEADPRINT
{
  key Reservation                  : abap.char(30);
      OrderID                      : abap.char(10);
      GoodsMovementType            : abap.char(3);
      CostCenter                   : abap.char(10);
      ProfitCenter                 : abap.char(4);
      GoodsRecipientName           : abap.char(50);
      Customer                     : abap.char(80);
      WBSElementInternalID         : abap.char(24);
      IssuingOrReceivingPlant      : abap.char(4);
      IssuingOrReceivingStorageLoc : abap.char(4);
      ResvnVerificationCompanyCode : abap.char(6);
      UserID                       : abap.char(12);
      UserName                     : abap.char(80);
      CreationDateTime             : abap.char(30);
      LastChangedByUser            : abap.char(12);
      LastChangeDateTime           : abap.char(30);
      status                       : abap.char(30);
      departmentname               : abap.char( 50 );
      companycode                  : abap.char( 4 );
      address                      : abap.char( 200 );
      receivingplant               : abap.char(4);
      issuingplant                 : abap.char( 4 );
      @ObjectModel.filter.enabled  : false
      _item                        : association [1..*] to ZI_RES_ITMPRINT1 on $projection.Reservation = _item.Reservation;
}
