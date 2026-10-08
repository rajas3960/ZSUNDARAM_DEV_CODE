@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Material Quality'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVMATQUAL_V0 
 as select from I_BillingDocumentItem as a

    inner join   I_ProductText         as b on  b.Product  = a.Material
                                            and b.Language = $session.system_language

{
  key a.BillingDocument,
  key a.BillingDocumentItem,
      a.Material,
      b.ProductName
}
