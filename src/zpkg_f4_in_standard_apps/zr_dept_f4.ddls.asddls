@EndUserText.label: 'Interface View For Departemnt F4'
@ObjectModel.representativeKey: 'dept_name'
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #X
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE,#CDS_MODELING_DATA_SOURCE,#CDS_MODELING_ASSOCIATION_TARGET,#LANGUAGE_DEPENDENT_TEXT]
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DEPT_F4'
define custom entity ZR_DEPT_F4

{
      @Search   : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
  key dept_name : abap.char(30);

}
