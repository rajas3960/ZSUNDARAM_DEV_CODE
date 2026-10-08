@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details of Receiver'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_RECEIVER
  as select distinct from ZR_RECEIVER1           as a
    left outer join       I_BillingDocumentItem  as d  on  d.BillingDocument     = a.BillingDocument
                                                       and d.BillingDocumentItem = a.BillingDocumentItem
    left outer join       I_SalesDocumentPartner as e  on  e.SalesDocument   = d.SalesDocument
    //and e.SalesDocumentItem = d.SalesDocumentItem
                                                       and e.PartnerFunction = 'WE'
    left outer join       I_Customer             as b  on b.Customer = e.Customer
  // left outer join       I_BillingDocItemPartner as BP on BP.BillingDocument = a.BillingDocument

  // Changed by Sreeram on 18.02.26
  //    left outer join       I_Address_2            as ad on ad.AddressID = b.AddressID
    left outer join       I_Address_2            as ad on ad.AddressID = e.AddressID
  // Changed by Sreeram on 18.02.26

    left outer join       ZI_DetailsForStateCode as c  on c.StateName = ad.Region
    left outer join       I_RegionText           as g  on  g.Country = ad.Country
                                                       and g.Region  = ad.Region
    left outer join       zdt_state_code1        as f  on f.sapstatecode = ad.Region

  // Changed by Sreeram on 18.02.26
  // This is for Ship to Party  Changes By Deepti
  //    left outer join       ZSD_CUS_ADD            as h  on h.AddressID = e.AddressID
  //    left outer join       I_RegionText           as i  on  i.Country = h.Country
  //                                                       and i.Region  = h.Region
  // This is for Ship to Party  Changes By Deepti 
  // Changed by Sreeram on 18.02.26
{
  key a.BillingDocument,
      // Commentted  by Sreeram on 18.02.26
      //      concat_with_space(b.BusinessPartnerName1,
      //      concat_with_space(b.BusinessPartnerName2,
      //      concat_with_space(b.BusinessPartnerName3,
      //                        b.BusinessPartnerName4, 1), 1), 1)                                                                                                                                                                                            as BusinessPartnerName1,
      //      b.BPAddrStreetName,
      //      b.CityName,
      //      g.RegionName,
      //
      ad.AddresseeFullName                                                                                                                                                                                as BusinessPartnerName1,
      ad.StreetName                                                                                                                                                                                       as BPAddrStreetName,
      ad.CityName,
      g.RegionName,

      // Changed by Sreeram on 18.02.26
      f.gststatecode                                                                                                                                                                                      as statecode,
      // Changed by Sreeram on 18.02.26                                                                                                                                                                                                               as StateCode,
      ad.PostalCode,
      // Changed by Sreeram on 18.02.26
      b.TaxNumber3,
      //      concat(concat(b.BPAddrStreetName ,concat(',' , b.CityName )), concat(',' , b.Region)) as FullAddress
      //      concat(concat(concat(b.BPAddrStreetName ,concat(',' , b.CityName )), concat(',' , b.Region)),concat(',',b.PostalCode)) as FullAddress,

      // Changed by Sreeram on 18.02.26
      // This is for Ship to Party  Changes By Deepti
      //      concat(concat(concat(concat(concat(concat(b.BPAddrStreetName ,concat(',',ad.StreetPrefixName1)),concat(',',ad.StreetPrefixName2)),concat(',',ad.StreetSuffixName1)),concat(',',b.CityName)),concat(',',g.RegionName)),concat(',',b.PostalCode))     as FullAddress,
      //      concat(concat(concat(concat(concat(concat(h.CareOfName ,concat(',',h.StreetName)),concat('',h.StreetPrefixName2)),concat('',h.StreetSuffixName1)),concat(',',h.CityName)),concat(',',i.RegionName)),concat(',',h.PostalCode)) as FullAddress,
      // This is for Ship to Party  Changes By Deepti
      //      concat(concat(concat(concat(concat(concat(b.BPAddrStreetName ,concat(',',ad.StreetPrefixName1)),concat(',',ad.StreetPrefixName2)),concat(',',ad.StreetSuffixName1)),concat(',',b.CityName)),concat(',',g.RegionName)),concat(',',b.PostalCode)) as FullAddress,
      concat(concat(concat(concat(concat(ad.StreetName ,concat(',',ad.StreetPrefixName1)),concat(',',ad.StreetPrefixName2)),concat(',',ad.CityName)),concat(',',g.RegionName)),concat(',',ad.PostalCode)) as FullAddress,
      // Changed by Sreeram on 18.02.26

      ad.StreetPrefixName1,
      ad.StreetPrefixName2,
      ad.StreetSuffixName1,
      ad.StreetSuffixName2,

      b.PostalCode                                                                                                                                                                                        as PostalCode11,
      e.AddressID                                                                                                                                                                                         as AddressIDsales

}
