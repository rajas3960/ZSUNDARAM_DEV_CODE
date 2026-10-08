@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FISCAL YEAR'
define view entity ZR_FISCALYEAR
  as select distinct from I_FiscalYear
{
  key FiscalYear,
      FiscalYearStartDate,
      FiscalYearEndDate
}
where
      FiscalYearStartDate <= $session.system_date
  and FiscalYearEndDate   >= $session.system_date
  and FiscalYearVariant   = 'V3'
