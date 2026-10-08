@EndUserText.label: 'Print Item'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZI_QAL_PRINTITM'
define view ZI_QAL_PRINT_ITM
  as select from ZTBL_FCTN_ITEM
                 (
                 client : $session.client
                 )
{
  key id               as Id,
  key item             as Item,
      billingdoc       as Billingdoc,
      billingitem      as Billingitem,
      charname         as CharName,
      chardesc         as CharDesc,
      batch            as batch,
      quantity         as quantity,
      maxlimit         as MaxLimit,
      minlimit         as MinLimit,
      results          as Results,
      remarks          as Remarks,
      uom              as Uom,
      uomname          as Uomname,
      test_method_text as TestMethodText,
      test_range       as test_range
}
