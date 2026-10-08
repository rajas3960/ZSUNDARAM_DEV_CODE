@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZR_POWER_HEADER
  as select from zdt_power_header
  composition [0..*] of ZR_POWER_GENERATION as _POW
  composition [0..*] of ZR_CONSUMED_MAT     as _MAT
  composition [0..*] of ZR_POWER_CONS       as _CONS



{
  key id              as Id,
      referenceid     as Referenceid,
      plant           as Plant,
      productionorder as Productionorder,
      postingdate     as Postingdate,
      status          as Status,
      activity        as Activity,
      noofturbine     as NoOfTurbine,
      consistency     as Consistency,
      postcnf         as Postcnf,
      postgen         as Postgen,
      postcons        as postcons,
      power           as Power,
      transfer,
      getcons         as getcons,
      material,
      materialdesc,      
      _POW,
      _MAT,
      _CONS

}
