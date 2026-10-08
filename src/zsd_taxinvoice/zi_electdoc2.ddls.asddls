@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ELE DOC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ELECTDOC2
  as select from zi_electdoc               as a
    inner join   I_IN_ElectronicDocInvoice as b on  b.ElectronicDocSourceKey = a.IN_EDocEInvcExtNmbr
                                                and b.ElectronicDocUUID      = a.ElectronicDocUUID
{
  a.IN_EDocEInvcExtNmbr,
  a.ElectronicDocUUID,
  b.IN_ElectronicDocInvcRefNmbr,
  b.IN_ElectronicDocAcknDate,
  b.IN_ElectronicDocQRCodeTxt,
  b.IN_ElectronicDocAcknTime,
  b.IN_EDocEInvcEWbillNmbr
}
