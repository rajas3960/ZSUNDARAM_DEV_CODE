@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TMT Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TMT_HEAD
  as select from zdt_tmt_head
  composition [0..*] of ZI_TMT_PROD    as _item
  composition [0..*] of ZI_TMT_BYPROD  as _item1
  composition [0..*] of ZI_CONSUMED    as _item2
  composition [0..*] of ZI_METAL_BAL   as _item3
  composition [0..*] of ZI_BUNDLE_GEN  as _item4
  composition [0..*] of ZI_CONS_BUNDLE as _item5

{
  key id                                          as Id,
      referenceid                                 as Referenceid,
      productionorder                             as Productionorder,
      plant                                       as Plant,
      postingdate                                 as Postingdate,
      material                                    as Material,
      materialdesc                                as Materialdesc,
      status                                      as Status,

      case  when status = 'Draft'   then 1
       when status = 'Created'   then 2
       when status = 'Item Fetched'   then 2
       when status = 'Checked'   then 2
       when status = 'Confirmed'   then 2
       when status = 'GR Posted'   then 2
       when status = 'GI Posted'   then 2
       when status = 'Completed'   then 3
       else 3 end                                 as Criticality,

      cast(case  when status = 'Draft'   then 10
           when status = 'Created'   then 20
           when status = 'Item Fetched'   then 30
           when status = 'Checked'   then 40
           when status = 'Confirmed'   then 50
           when status = 'GR Posted'   then 60
           when status = 'GI Posted'   then 80
           when status = 'Completed'   then 100

                         else 0 end as abap.int4) as Progress,

      cast(100 as abap.int4)                      as Total,
      department,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      avlquantity                                 as Avlquantity,
      uom                                         as Uom,
      conscheck,
      postcnf,
      post101,
      post261,
      post531,
      noofbatch,
      'X'                                         as getcons,
      activity,

      _item,
      _item1,
      _item2,
      _item3,
      _item4,
      _item5 // Make association public
}
