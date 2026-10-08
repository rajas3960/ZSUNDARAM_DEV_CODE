@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TRANS_API
  as select from zdt_trans_api


{
  key transactionid     as Transactionid,
  key utr               as Utr,
      remittername      as Remittername,
      fromaccountnumber as Fromaccountnumber,
      frombankname      as Frombankname,
      remitterifsc      as Remitterifsc,
      virtualaccount    as Virtualaccount,
      @Semantics.amount.currencyCode: 'WAERS'
      amount            as Amount,
      mmid              as Mmid,
      valuedate         as Valuedate,
      transfermode      as Transfermode,
      creditdate        as Creditdate,
      credittime        as Credittime,
      chequeno          as Chequeno,
      narration         as Narration,
      accountingdoc     as Accountingdoc,
      companycode       as Companycode,
      fiscalyear        as Fiscalyear,
      waers             as Waers,
      createdon         as Createdon,
      createdat         as Createdat
}
