@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payer Partner Function'
define view entity ZR_PAYER
  as select from  I_BillingDocument as a
  inner join      I_BillingDocumentPartner as b on a.BillingDocument = b.BillingDocument
                                               and b.PartnerFunction = 'RG' 
{
    key a.BillingDocument,
        b.Customer
}
