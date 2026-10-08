@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Receiver Consignee data'
define view entity ZR_REC_CON
  as select distinct from I_BillingDocumentItem as a
  left outer join         I_BillingDocument     as b on a.BillingDocument = b.BillingDocument
  left outer join         I_SalesDocumentPartner as c on c.SalesDocument = a.SalesDocument
                                                     and c.PartnerFunction = 'WE'
  left outer join         I_SalesDocumentPartner as d on d.SalesDocument = a.SalesDocument
                                                     and d.PartnerFunction = 'AG'
{
  key a.BillingDocument as BillingDocument,
      b.SoldToParty     as Consignee,
      c.Customer        as Receiver,
      c.AddressID       as RAddressid,
      d.Customer        as SoldToParty,
      d.AddressID       as CAddressid
      
}
