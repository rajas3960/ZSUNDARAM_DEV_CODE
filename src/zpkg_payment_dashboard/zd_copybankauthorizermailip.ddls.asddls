@EndUserText.label: 'Copy Bank Authorizer Mail ID'
define abstract entity ZD_CopyBankAuthorizerMailIP
{
  @EndUserText.label: 'New Email'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Email' )
  Email : ZEMAIL;
  
}
