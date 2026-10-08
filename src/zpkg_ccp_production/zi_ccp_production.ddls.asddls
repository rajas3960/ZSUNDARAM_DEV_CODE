@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CCP Production'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_CCP_PRODUCTION
  with parameters
    @EndUserText.label: 'From Date'
    p_from_date : datum,
    @EndUserText.label: 'To Date'
    p_to_date   : datum,
    @EndUserText.label: 'Plant'
    p_plant     : werks_d
  as select from    ZI_PLANT_DATE                                                                                                               as aa
    left outer join ZR_TG1( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )             as a on  a.PostingDate = aa.CalendarDate
                                                                                                                                                     and a.Plant       = $parameters.p_plant
    left outer join ZR_TG2( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )             as b on  b.PostingDate = aa.CalendarDate
                                                                                                                                                     and b.Plant       = $parameters.p_plant
    left outer join ZR_CAPTIVEPOWERDRI( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                               as c on  c.PostingDate = aa.CalendarDate
                                                                                                                                                     and c.plant       = $parameters.p_plant
    left outer join ZR_CAPTIVEPOWERSMS( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                               as d on  d.PostingDate = aa.CalendarDate
                                                                                                                                                     and d.plant       = $parameters.p_plant
    left outer join ZR_CAPTIVEPOWERROLL( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                              as e on  e.PostingDate = aa.CalendarDate
                                                                                                                                                     and e.plant       = $parameters.p_plant
    left outer join ZR_Auxiliarycons( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                                 as f on  f.PostingDate = aa.CalendarDate
                                                                                                                                                     and f.Plant       = $parameters.p_plant
    left outer join ZR_GRIDPOWCONS_SMS( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                               as g on  g.PostingDate = aa.CalendarDate
                                                                                                                                                     and g.plant       = $parameters.p_plant
    left outer join ZR_GRIDPOWCONS_DRI( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                               as h on  h.PostingDate = aa.CalendarDate
                                                                                                                                                     and h.plant       = $parameters.p_plant
    left outer join ZR_GRIDPOWCONS_ROLL( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                              as i on  i.PostingDate = aa.CalendarDate
                                                                                                                                                     and i.plant       = $parameters.p_plant
    left outer join ZR_GRIDPOWCONS_CPP( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date )                               as j on  j.PostingDate = aa.CalendarDate
                                                                                                                                                     and j.Plant       = $parameters.p_plant

    left outer join ZR_STEAM_WHRB( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )      as k on  k.PostingDate = aa.CalendarDate
                                                                                                                                                     and k.WorkCenter  = 'WHRB1'
    left outer join ZR_STEAM_WHRB( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )      as l on  l.PostingDate = aa.CalendarDate
                                                                                                                                                     and l.WorkCenter  = 'WHRB2'
    left outer join ZR_STEAM_WHRB( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )      as m on  m.PostingDate = aa.CalendarDate
                                                                                                                                                     and m.WorkCenter  = 'WHRB3'
    left outer join ZR_STEAM_WHRB( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )      as n on  n.PostingDate = aa.CalendarDate
                                                                                                                                                     and n.WorkCenter  = 'WHRB4'
    left outer join ZR_STEAM_WHRB( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant )      as o on  o.PostingDate = aa.CalendarDate
                                                                                                                                                     and o.WorkCenter  = 'AFBC'
    left outer join ZR_CONSUMED_FIELDS( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant ) as p on  p.PostingDate = aa.CalendarDate
                                                                                                                                                     and p.Material    = '000000000150000023'
    left outer join ZR_CONSUMED_FIELDS( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant ) as q on  q.PostingDate = aa.CalendarDate
                                                                                                                                                     and q.Material    = '000000000940000012'
    left outer join ZR_CONSUMED_FIELDS( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant ) as r on  r.PostingDate = aa.CalendarDate
                                                                                                                                                     and r.Material    = '000000000100000063'
    left outer join ZR_CONSUMED_FIELDS( p_from_date: $parameters.p_from_date , p_to_date: $parameters.p_to_date, p_plant: $parameters.p_plant ) as s on  s.PostingDate = aa.CalendarDate
                                                                                                                                                     and s.Material    = '000000000940000006'
{
      @EndUserText.label: 'Date'
  key aa.CalendarDate,

      @EndUserText.label: 'Plant'
  key aa.Plant,

      @UI.hidden: true
      a.ProductionUnit,
      @EndUserText.label: 'Captive power Generated (TG1)'
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      a.tg1                                                                                                 as TG1,

      @UI.hidden: true
      b.ProductionUnit                                                                                      as bProductionUnit,
      @Semantics.quantity.unitOfMeasure: 'bProductionUnit'
      @EndUserText.label: 'Captive power Generated (TG2)'
      b.tg2                                                                                                 as TG2,

      @EndUserText.label: 'Total power Generated'
      case when ( a.tg1 is not null and a.tg1 is not initial ) and ( b.tg2 is not null and b.tg2 is not initial )
           then cast(a.tg1 + b.tg2 as abap.dec(14,3) )
           when ( a.tg1 is not null and a.tg1 is not initial ) and ( b.tg2 is null or b.tg2 is initial )
           then cast(a.tg1 as abap.dec(14,3) )
           when ( a.tg1 is null or a.tg1 is initial ) and ( b.tg2 is not null and b.tg2 is not initial )
           then cast( b.tg2 as abap.dec(14,3) )
           else cast('0' as abap.dec(14,3) )
           end                                                                                              as totalpowergen,

      @UI.hidden: true
      c.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @EndUserText.label: 'Captive power consumed (DRI)'
      c.TotalGdsMvtQtyInBaseUnit                                                                            as cpcdri,

      @UI.hidden: true
      d.MaterialBaseUnit                                                                                    as dMaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'dMaterialBaseUnit'
      @EndUserText.label: 'Captive power consumed (SMS)'
      d.TotalGdsMvtQtyInBaseUnit                                                                            as cpcsms,

      @UI.hidden: true
      e.MaterialBaseUnit                                                                                    as eMaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'eMaterialBaseUnit'
      @EndUserText.label: 'Captive power consumed (Rolling Mill)'
      e.TotalGdsMvtQtyInBaseUnit                                                                            as cpcroll,

      @UI.hidden: true
      f.MaterialBaseUnit                                                                                    as fMaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'eMaterialBaseUnit'
      @EndUserText.label: 'Auxiliary consumption'
      f.TotalGdsMvtQtyInBaseUnit                                                                            as axucons,

      @UI.hidden: true
      case when ( c.TotalGdsMvtQtyInBaseUnit is not null and c.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is not null and d.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is not null and f.TotalGdsMvtQtyInBaseUnit is not initial )
           then cast((c.TotalGdsMvtQtyInBaseUnit + d.TotalGdsMvtQtyInBaseUnit + f.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           when ( c.TotalGdsMvtQtyInBaseUnit is not null and c.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is not null and d.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is null or f.TotalGdsMvtQtyInBaseUnit is initial )
           then cast((c.TotalGdsMvtQtyInBaseUnit + d.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           when ( c.TotalGdsMvtQtyInBaseUnit is not null and c.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is null or d.TotalGdsMvtQtyInBaseUnit is initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is not null and f.TotalGdsMvtQtyInBaseUnit is not initial )
           then cast((c.TotalGdsMvtQtyInBaseUnit + f.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           when ( c.TotalGdsMvtQtyInBaseUnit is null or c.TotalGdsMvtQtyInBaseUnit is initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is not null and d.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is not null and f.TotalGdsMvtQtyInBaseUnit is not initial )
           then cast(( d.TotalGdsMvtQtyInBaseUnit + f.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           when ( c.TotalGdsMvtQtyInBaseUnit is not null and c.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is null or d.TotalGdsMvtQtyInBaseUnit is initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is null or f.TotalGdsMvtQtyInBaseUnit is initial )
           then cast((c.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           when ( c.TotalGdsMvtQtyInBaseUnit is null or c.TotalGdsMvtQtyInBaseUnit is initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is null or d.TotalGdsMvtQtyInBaseUnit is initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is not null and f.TotalGdsMvtQtyInBaseUnit is not initial )
           then cast(( f.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           when ( c.TotalGdsMvtQtyInBaseUnit is null or c.TotalGdsMvtQtyInBaseUnit is initial )
            and ( d.TotalGdsMvtQtyInBaseUnit is not null and d.TotalGdsMvtQtyInBaseUnit is not initial )
            and ( f.TotalGdsMvtQtyInBaseUnit is null or f.TotalGdsMvtQtyInBaseUnit is initial )
           then cast(( d.TotalGdsMvtQtyInBaseUnit ) as abap.dec(31,14))
           else cast('0' as abap.dec(31,14) )
           end                                                                                              as tempval,


      @EndUserText.label: 'Balance'
      cast( $projection.totalpowergen as abap.dec(31,14)) - $projection.tempval                             as balance,

      @EndUserText.label: 'Grid power consumed (SMS)'
      ( g.OPCONFIRMEDWORKQUANTITY2 / 1000 )                                                                 as GridPowConsSMS,
      @EndUserText.label: 'Grid power consumed (DRI)'
      ( h.OPCONFIRMEDWORKQUANTITY2 / 1000 )                                                                 as GridPowConsDRI,
      @EndUserText.label: 'Grid power consumed (ROLLINGMILL)'
      ( i.OPCONFIRMEDWORKQUANTITY2 / 1000 )                                                                 as GridPowConsROLL,
      @EndUserText.label: 'Grid power consumed (CPP)'
      ( j.OPCONFIRMEDWORKQUANTITY5 / 1000 )                                                                 as GridPowConsCPP,

      @EndUserText.label: 'Steam (WHRB1)'
      k.Qty                                                                                                 as SteamWHRB1,
      @EndUserText.label: 'Steam (WHRB2)'
      l.Qty                                                                                                 as SteamWHRB2,
      @EndUserText.label: 'Steam (WHRB3)'
      m.Qty                                                                                                 as SteamWHRB3,
      @EndUserText.label: 'Steam (WHRB4)'
      n.Qty                                                                                                 as SteamWHRB4,
      @EndUserText.label: 'Steam (AFBC)'
      o.Qty                                                                                                 as SteamAFBC,

      @UI.hidden: true
      case when k.Qty is not null or k.Qty is not initial
           then cast(k.Qty as abap.dec(31,14))
           else cast('0' as abap.dec(31,14) )
           end                                                                                              as temp1,
      @UI.hidden: true
      case when l.Qty is not null or l.Qty is not initial
      then cast(l.Qty as abap.dec(31,14))
      else cast('0' as abap.dec(31,14) )
      end                                                                                                   as temp2,
      @UI.hidden: true
      case when m.Qty is not null or m.Qty is not initial
      then cast(m.Qty as abap.dec(31,14))
      else cast('0' as abap.dec(31,14) )
      end                                                                                                   as temp3,
      @UI.hidden: true
      case when n.Qty is not null or n.Qty is not initial
      then cast(n.Qty as abap.dec(31,14))
      else cast('0' as abap.dec(31,14) )
      end                                                                                                   as temp4,
      @UI.hidden: true
      case when o.Qty is not null or o.Qty is not initial
      then cast(o.Qty as abap.dec(31,14))
      else cast('0' as abap.dec(31,14) )
      end                                                                                                   as temp5,


      @EndUserText.label: 'Total steam (Generated)'
      ( $projection.temp1 + $projection.temp2 + $projection.temp3 + $projection.temp4 + $projection.temp5 ) as TotalSteamGen,

      @EndUserText.label: 'Steam (Consumed)'
      p.TOTALGDSMVTQTYINBASEUNIT                                                                            as SteamConsumed,
      @EndUserText.label: 'Steam (Vented)'
      case when ( p.TOTALGDSMVTQTYINBASEUNIT is not null and p.TOTALGDSMVTQTYINBASEUNIT is not initial )
           then ( $projection.TotalSteamGen - p.TOTALGDSMVTQTYINBASEUNIT )
           else   $projection.TotalSteamGen
           end                                                                                              as SteamVented,

      @EndUserText.label: 'Dolochar consumed'
      q.TOTALGDSMVTQTYINBASEUNIT                                                                            as DolocharConsumed,
      @EndUserText.label: 'Coal consumed'
      r.TOTALGDSMVTQTYINBASEUNIT                                                                            as CoalConsumed,
      @EndUserText.label: 'Flue gas consumed'
      s.TOTALGDSMVTQTYINBASEUNIT                                                                            as FuelGasConsumed
}
where
      aa.CalendarDate >= $parameters.p_from_date
  and aa.CalendarDate <= $parameters.p_to_date
  and aa.Plant        = $parameters.p_plant
