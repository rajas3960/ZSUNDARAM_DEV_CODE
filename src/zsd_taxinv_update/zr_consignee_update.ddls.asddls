@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details of consignee'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_CONSIGNEE_UPDATE as select distinct from I_BillingDocument      as a
    left outer join       I_Customer             as c on c.Customer = a.SoldToParty
    left outer join       I_Address_2            as ad on ad.AddressID = c.AddressID
    left outer join       ZI_DetailsForStateCode as b on b.StateName = c.Region
    left outer join       I_RegionText           as d on  d.Country = c.Country
                                                      and d.Region  = c.Region
    left outer join       zdt_state_code1        as e on e.sapstatecode = c.Region
    left outer join       I_BillingDocumentPartner as f on  f.BillingDocument   = a.BillingDocument
    //and e.SalesDocumentItem = d.SalesDocumentItem
                                                      and f.PartnerFunction = 'RE'
    left outer join ZSD_CUS_ADD as g on g.AddressID = f.AddressID
    left outer join       I_RegionText           as h on  h.Country = g.Country
                                                      and h.Region  = g.Region    
{
  key a.BillingDocument,
  key c.Customer,
      concat_with_space(c.BusinessPartnerName1,
      concat_with_space(c.BusinessPartnerName2,
      concat_with_space(c.BusinessPartnerName3,
                        c.BusinessPartnerName4, 1), 1), 1)                                                                   as BusinessPartnerName1,
      c.BPAddrStreetName,
      c.CityName,
      d.RegionName,
      e.gststatecode                                                                                                         as StateCode,
      c.PostalCode,
      c.TaxNumber3,
      c.CustomerName,
      //      concat(concat(c.BPAddrStreetName ,concat(',' , c.CityName )), concat(',' , c.Region)) as FullAddress
//      concat(concat(concat(c.BPAddrStreetName ,concat(',' , c.CityName )), concat(',' , c.Region)),concat(',',c.PostalCode)) as FullAddress
      concat(concat(concat(concat(concat(concat(g.CareOfName ,concat(',',g.StreetName)),concat('',g.StreetPrefixName2)),concat('',g.StreetPrefixName1)),concat(',',g.CityName)),concat(',',h.RegionName)),concat(',',g.PostalCode))     as FullAddress,
      g.PostalCode as postalcode1

}
