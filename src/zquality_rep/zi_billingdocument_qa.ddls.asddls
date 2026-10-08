@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_BillingDocument'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BillingDocument_QA

  as select from I_BillingDocumentItem

{
  key BillingDocument,
  key BillingDocumentItem,
      Plant,
      Division,
      DistributionChannel,
      Product,
      BillingDocumentItemText
}

where
       BillingDocumentType = 'F2'

  and(
       Plant               = '1004'
    or Plant               = '1005'
    or Plant               = '2004'
    or Plant               = '2005'
    or Plant               = '3004'
    or Plant               = '4004'
  )
