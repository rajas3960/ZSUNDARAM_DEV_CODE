//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_SERV_ITEM
  as select from zdt_serv_item
{
  key reservation                    as Reservation,
  key reservationitem                as Reservationitem,
      product                        as Product,
      productdescription             as Productdescription,
      entryunit                      as Entryunit,
      resvnitmrequiredqtyinentryunit as Resvnitmrequiredqtyinentryunit,
      goodsrecipientname             as Goodsrecipientname,
      reservationitemtext            as Reservationitemtext
}
