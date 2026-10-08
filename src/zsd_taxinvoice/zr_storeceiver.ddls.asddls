@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'STO Receiver Address'
define view entity ZR_STORECEIVER
  as select distinct from ZR_RECEIVER1 as a
  left outer join I_BillingDocumentItem as d on d.BillingDocument = a.BillingDocument
                                            and d.BillingDocumentItem = a.BillingDocumentItem
  left outer join I_DeliveryDocument as e on e.DeliveryDocument = d.ReferenceSDDocument
  left outer join I_Customer as b on b.Customer = e.ShipToParty
  left outer join I_Address_2 as ad on ad.AddressID = b.AddressID
   left outer join ZI_DetailsForStateCode as c on c.StateName = b.Region
   left outer join zdt_state_code1 as f on f.sapstatecode = b.Region
{
    key a.BillingDocument,
      concat_with_space(b.BusinessPartnerName1,
      concat_with_space(b.BusinessPartnerName2,
      concat_with_space(b.BusinessPartnerName3,
                        b.BusinessPartnerName4, 1), 1), 1) as BusinessPartnerName1,
      b.BPAddrStreetName,
      b.CityName,
      b.Region,
      f.gststatecode as StateCode,
      b.PostalCode,
      b.TaxNumber3,
//      concat(concat(b.BPAddrStreetName ,concat(',' , b.CityName )), concat(',' , b.Region)) as FullAddress
      concat(concat(concat(concat(concat(concat(b.BPAddrStreetName ,concat(',',ad.StreetPrefixName1)),concat(',',ad.StreetPrefixName2)),concat(',',ad.StreetSuffixName1)),concat(',',b.CityName)),concat(',',b.Region)),concat(',',b.PostalCode))     as FullAddress
}
