@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VIEW FOR SALES ORDER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALES_ORDER
  as select distinct from I_BillingDocumentItem  as A
    left outer join       I_DeliveryDocumentItem as B on A.ReferenceSDDocument = B.DeliveryDocument
{
  key A.BillingDocument,
      A.ReferenceSDDocument,
      case 
      when A.ReferenceSDDocumentCategory = 'C'  or 
      A.ReferenceSDDocumentCategory = 'L' or 
      A.ReferenceSDDocumentCategory = 'K' 
      then A.ReferenceSDDocument
      
   //   when 'C'
    //  then  A.ReferenceSDDocument
      else  B.ReferenceSDDocument end as SalesOrder

}
