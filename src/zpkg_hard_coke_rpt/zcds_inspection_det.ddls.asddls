@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Inspection Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INSPECTION_DET
  as select from I_InspectionLot            as a
    inner join   I_InspectionCharacteristic as b on  b.InspectionLot           = a.InspectionLot
                                                 and b.InspectionSpecification = 'ITEMASH%'
    inner join   I_InspectionResult         as c on  c.InspectionLot            = b.InspectionLot
                                                 and c.InspectionCharacteristic = b.InspectionCharacteristic
{
  a.MaterialDocument,
  a.MaterialDocumentItem,
  a.MaterialDocumentYear,
  b.InspectionSpecification,
  case when c.InspectionResultMeanValue is not initial
       then cast( c.InspectionResultMeanValue as abap.dec( 13, 3 ) )
       else cast( 0 as abap.dec( 13, 3 ) ) end as InspectionResultOriginalValue
}
where a.MaterialDocument is not initial
group by
  a.MaterialDocument,
  a.MaterialDocumentItem,
  a.MaterialDocumentYear,
  b.InspectionSpecification,
  c.InspectionResultMeanValue
union
select from I_InspectionLot            as a
    inner join   I_InspectionCharacteristic as b on  b.InspectionLot           = a.InspectionLot
                                                 and b.InspectionSpecification = 'MOISTURE'
    inner join   I_InspectionResult         as c on  c.InspectionLot            = b.InspectionLot
                                                 and c.InspectionCharacteristic = b.InspectionCharacteristic
{
  a.MaterialDocument,
  a.MaterialDocumentItem,
  a.MaterialDocumentYear,
  b.InspectionSpecification,
  case when c.InspectionResultMeanValue is not initial
       then cast( c.InspectionResultMeanValue as abap.dec( 13, 3 ) )
       else cast( 0 as abap.dec( 13, 3 ) ) end as InspectionResultOriginalValue
}
where a.MaterialDocument is not initial
group by
  a.MaterialDocument,
  a.MaterialDocumentItem,
  a.MaterialDocumentYear,
  b.InspectionSpecification,
  c.InspectionResultMeanValue  
