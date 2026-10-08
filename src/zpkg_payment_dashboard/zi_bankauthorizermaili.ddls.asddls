@EndUserText.label: 'Bank Authorizer Mail ID'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_BankAuthorizerMailI
  as select from ZTMGBANKAUTHMAIL
  association to parent ZI_BankAuthorizerMailI_S as _BankAuthorizerMaAll on $projection.SingletonID = _BankAuthorizerMaAll.SingletonID
{
  key EMAIL as Email,
  @Consumption.hidden: true
  1 as SingletonID,
  _BankAuthorizerMaAll
}
