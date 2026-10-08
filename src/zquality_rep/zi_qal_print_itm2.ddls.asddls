@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Print 2 item level'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_qal_print_itm2
  as select distinct from zbatch_print2   as a
    left outer join       zdt_quality_itm as b on  b.batch    = a.batch
                                               and b.charname = '%C'
                                               and b.id       = a.id

    left outer join       zdt_quality_itm as c on  c.batch    = a.batch
                                               and c.charname = '%MN'
                                               and c.id       = a.id

    left outer join       zdt_quality_itm as d on  d.batch    = a.batch
                                               and d.charname = '%SI'
                                               and d.id       = a.id

    left outer join       zdt_quality_itm as s on  s.batch    = a.batch
                                               and s.charname = '%S'
                                               and s.id       = a.id

    left outer join       zdt_quality_itm as e on  e.batch    = a.batch
                                               and e.charname = '%P'
                                               and e.id       = a.id

    left outer join       zdt_quality_itm as f on  f.batch    = a.batch
                                               and f.charname = '%(S+P)'
                                               and f.id       = a.id

    left outer join       zdt_quality_itm as g on  g.batch    = a.batch
                                               and g.charname = 'CE'
                                               and g.id       = a.id
{
  key   a.id,
  key   a.batch,
        b.quantity,
        b.results as C_Res,
        c.results as MN_res,
        d.results as SI_res,
        s.results as S_res,
        e.results as P_res,
        f.results as S_P_res,
        g.results as CE_res
}
