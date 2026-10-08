@AbapCatalog.sqlViewName: 'ZSQ_PAYITM3'
@AccessControl.authorizationCheck: #CHECK
define view ZCDS_PAYMENT_ITEM3
  as select from I_OperationalAcctgDocItem
{
  AccountingDocument,
  FiscalYear,
  CompanyCode
}
