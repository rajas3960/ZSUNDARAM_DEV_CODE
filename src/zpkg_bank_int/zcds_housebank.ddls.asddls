@AbapCatalog.sqlViewName: 'ZVHOUSEBANK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HOUSEBANK'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_HOUSEBANK
  as select from I_HouseBankAccountLinkage
{
  key CompanyCode,
  key HouseBank,
  key HouseBankAccount,
      BankAccountInternalID,
      BankInternalID,
      BankCountry,
      CompanyCodeName,
      SWIFTCode,
      BankName,
      BankNumber,
      BankAccount,
      BankAccountAlternative,
      ReferenceInfo,
      BankControlKey,
      BankAccountCurrency,
      IBAN,
      BankAccountDescription,
      GLAccount,
      BankAccountHolderName,
      BankAccountNumber

}
