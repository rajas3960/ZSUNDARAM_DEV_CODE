@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transation Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TRANSATION_REPORT
  as select from zdt_trans_api
  composition [0..*] of ZI_error_item as _Item
{
  key transactionid                                 as Transactionid,
  key utr                                           as Utr, //fltr
      remittername                                  as Remittername,
      fromaccountnumber                             as Fromaccountnumber,
      frombankname                                  as Frombankname,
      remitterifsc                                  as Remitterifsc,
      virtualaccount                                as Virtualaccount, //fltr
      @Semantics.amount.currencyCode: 'WAERS'
      amount                                        as Amount,
      mmid                                          as Mmid,
      valuedate                                     as Valuedate,
      transfermode                                  as Transfermode,
      creditdate                                    as Creditdate, //fltr
      credittime                                    as Credittime,
      chequeno                                      as Chequeno,
      narration                                     as Narration,
      accountingdoc                                 as Accountingdoc,
      companycode                                   as Companycode,
      fiscalyear                                    as Fiscalyear,
      waers                                         as Waers,
      status                                        as Status, //fltr
      error_count                                   as error_count,
      createdon                                     as Createdon,
      createdat                                     as Createdat,
      mailsent                                      as mailsent,
      mailsentat                                    as mailsentat,
      mailsenton                                    as mailsenton,
      post                                          as post,
      case  when status = 'New'   then 2
           when status = 'Processed'   then 3
           when status = 'Failed'   then 1
           else 3 end                               as Criticality,

      cast( case  when status = 'New'   then 50
            when status = 'Processed'   then 100
            when status = 'Failed'   then 0

                          else 0 end as abap.int4 ) as Progress,
      cast( 100 as abap.int4 )                      as Total,
      _Item
}
