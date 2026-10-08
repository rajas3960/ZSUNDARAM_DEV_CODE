@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Billet Production - Header'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZR_BILLET_HDR

  as select from zdt_billet_hdr

  composition [0..*] of ZR_BILLET_101 as _101
  composition [0..*] of ZR_BILLET_261 as _261
  composition [0..*] of ZR_BILLET_531 as _531
  composition [0..*] of ZR_BILLET_HTB as _HTB

{
  key id,

      referenceid,
      productionorder,
      plant,
      postingdate,
      material,
      materialdesc,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      orderquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      totalpostquantity,
      activity,

      uom,
      status,

      case  when status = 'Draft'   then 1
         when status = 'Created'   then 2
         when status = 'Checked'   then 2
         when status = 'Confirmed'   then 2
         when status = 'GR Posted'   then 2
         when status = 'GI Posted'   then 2
         when status = 'Completed'   then 3
         else 3 end                               as Criticality,

      cast(case  when status = 'Draft'   then 10
           when status = 'Created'   then 20
           when status = 'Checked'   then 40
           when status = 'Confirmed'   then 50
           when status = 'GR Posted'   then 60
           when status = 'GI Posted'   then 80
           when status = 'Completed'   then 100

                         else 0 end as abap.int4) as Progress,

      cast(100 as abap.int4)                      as Total,
      caster,
      width,
      height,
      density,

      postcheck,
      postcnf,
      post101,
      post261,
      post531,
      getcons,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_hdr.heatquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_hdr.billetquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_hdr.byproductquantity,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      zdt_billet_hdr.balancequantity,
      yieldpercentage,

      noofheats,
      noofbatches,
      dummy,

      _101,
      _531,
      _261,
      _HTB
}
