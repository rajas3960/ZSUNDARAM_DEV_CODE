@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption ~ Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_POWER_HEADER
  provider contract transactional_query
  as projection on ZR_POWER_HEADER
{
  key Id,
      @EndUserText.label: 'Reference Id'
      Referenceid,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Production Order'
      Productionorder,
      @EndUserText.label: 'Posting Date'
      Postingdate,
      @EndUserText.label: 'Material'
      material,
      @EndUserText.label: 'Material Desc.'
      materialdesc,      
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Activity(Grid Power)'
      Activity,
      @EndUserText.label: 'Number Of Turbine'
      NoOfTurbine,
      @EndUserText.label: 'Consistency Check'
      Consistency,
      @EndUserText.label: 'Post Confirmation'
      Postcnf,
      @EndUserText.label: 'Post Generation'
      Postgen,
      @EndUserText.label: 'Post Consumption'
      postcons,
      @EndUserText.label: 'Power Consumption'
      Power,
      @EndUserText.label: 'Fetch Consumption'
      getcons,
      @EndUserText.label: 'Transfer'
      transfer,      
      /* Associations */
      _POW  : redirected to composition child ZC_POWER_GENERATION,
      _MAT  : redirected to composition child ZC_CONSUMED_MAT,
      _CONS : redirected to composition child ZC_POWER_CONS
}
