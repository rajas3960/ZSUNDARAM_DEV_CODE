@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details of Consignee'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_CONSIGNEE
  as select distinct from I_BillingDocument        as a
    left outer join       I_Customer               as c  on c.Customer = a.SoldToParty
  // Changed by Sreeram on 18.02.26
  //    left outer join       I_Address_2              as ad on ad.AddressID = c.AddressID
  // Changed by Sreeram on 18.02.26
    left outer join       I_BillingDocumentPartner as f  on  f.BillingDocument = a.BillingDocument
    //and e.SalesDocumentItem = d.SalesDocumentItem
                                                         and f.PartnerFunction = 'RE'
  // Changed by Sreeram on 18.02.26
    left outer join       I_Address_2              as ad on ad.AddressID = f.AddressID
    left outer join       ZI_DetailsForStateCode   as b  on b.StateName = ad.Region
    left outer join       I_RegionText             as d  on  d.Country = ad.Country
                                                         and d.Region  = ad.Region
    left outer join       zdt_state_code1          as e  on e.sapstatecode = ad.Region
  // Changed by Sreeram on 18.02.26
  // Changed by Sreeram on 18.02.26
  // Changes By Deepti
  //    left outer join       ZSD_CUS_ADD              as g  on g.AddressID = f.AddressID
  //    left outer join       I_RegionText             as h  on  h.Country = g.Country
  //                                                         and h.Region  = g.Region
  // Changes By Deepti
  // Changed by Sreeram on 18.02.26
{
  key a.BillingDocument,
  key c.Customer,
      //      concat_with_space(c.BusinessPartnerName1,
      //      concat_with_space(c.BusinessPartnerName2,
      //      concat_with_space(c.BusinessPartnerName3,
      //                        c.BusinessPartnerName4, 1), 1), 1)                                                                   as BusinessPartnerName1,
      ad.AddresseeFullName                                                                                                                                                                                as BusinessPartnerName1,
      ad.StreetName                                                                                                                                                                                       as BPAddrStreetName,
      ad.CityName,
      d.RegionName,
      e.gststatecode                                                                                                                                                                                      as StateCode,
      ad.PostalCode,
      c.TaxNumber3,
      c.CustomerName,
      //      concat(concat(c.BPAddrStreetName ,concat(',' , c.CityName )), concat(',' , c.Region)) as FullAddress
      //      concat(concat(concat(c.BPAddrStreetName ,concat(',' , c.CityName )), concat(',' , c.Region)),concat(',',c.PostalCode)) as FullAddress

      // Changed by Sreeram on 18.02.26
      // Changes By Deepti
      //      concat(concat(concat(concat(concat(concat(g.CareOfName ,concat(',',g.StreetName)),concat('',g.StreetPrefixName2)),concat('',g.StreetPrefixName1)),concat(',',g.CityName)),concat(',',h.RegionName)),concat(',',g.PostalCode)) as FullAddress,
      // Changes By Deepti
      concat(concat(concat(concat(concat(ad.StreetName ,concat(',',ad.StreetPrefixName1)),concat(',',ad.StreetPrefixName2)),concat(',',ad.CityName)),concat(',',d.RegionName)),concat(',',ad.PostalCode)) as FullAddress,
      // Changed by Sreeram on 18.02.26

      c.PostalCode                                                                                                                                                                                        as postalcode1

}
