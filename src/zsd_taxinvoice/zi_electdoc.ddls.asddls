@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_IN_ElectronicDocInvoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_electdoc
  as select from I_IN_ElectronicDocInvoice
{

  key ElectronicDocSourceKey as IN_EDocEInvcExtNmbr,
      max(ElectronicDocUUID) as ElectronicDocUUID

}
group by
  ElectronicDocSourceKey
