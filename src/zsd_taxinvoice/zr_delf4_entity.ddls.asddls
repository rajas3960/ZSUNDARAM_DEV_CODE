@EndUserText.label: 'F4 Help for Delivery '
@ObjectModel.representativeKey: 'value_low'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DEL_F4'
@UI.presentationVariant: [{ sortOrder: [{ by: 'value_low', direction: #DESC }] }]
define root custom entity ZR_DELF4_ENTITY
{
     @Search       : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
  key value_low     : abap.char(20);
      Text           : abap.char(30);
}
