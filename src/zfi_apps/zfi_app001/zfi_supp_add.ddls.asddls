@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Address Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_SUPP_ADD
  as select from I_Supplier  as Sup
    inner join   I_Address_2 as ADD on  ADD.AddressID = Sup.AddressID
                                    and ADD.Region    = Sup.Region
{
  key Sup.Supplier,
  key ADD.AddressID,
      Sup._EmailAddress.EmailAddress
}
group by Sup.Supplier,
    	 ADD.AddressID,
		 Sup._EmailAddress.EmailAddress
