@EndUserText.label: 'Status Read'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYSTATUS
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDMN_PAYSTATUS' )
{
         //  key domain_name,
         //  key value_position,
         //      @Semantics.language: true
         //  key language,
  key    value_low as status,
         @Semantics.text: true
         text
}
