@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer phone'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTOMER_PHN as select from zdt_buspartnrphn
//                   (
//                   input_mandt : $session.client
//                   )
{
  key businesspartner,
      emailaddress,
      completetelephonenumber 
}
