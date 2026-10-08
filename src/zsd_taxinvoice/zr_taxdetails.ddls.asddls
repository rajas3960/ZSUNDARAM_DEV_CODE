@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details for Tax'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_TAXDETAILS
  as select from I_BillingDocumentItem          as A
    inner join   I_BillingDocumentItemPrcgElmnt as J on  J.BillingDocument     = A.BillingDocument
                                                     and J.BillingDocumentItem = A.BillingDocumentItem

{
  key A.BillingDocument                       as InvoiceNumber,
  key A.BillingDocumentItem                   as BillingdocItem,
      //      J.ConditionType,
      case
      when J.ConditionType = 'JOCG'
       then cast( J.ConditionAmount as abap.dec(23,2))
       else
       cast( 0 as abap.dec(23,2))
        end                                   as CGST,
      case
      when J.ConditionType = 'JOSG'
       then cast( J.ConditionAmount as abap.dec(23,2))
       else cast( 0 as abap.dec(23,2))
       end                                    as SGST,
      case
      when J.ConditionType = 'JOIG'
       then cast( J.ConditionAmount as abap.dec(23,2))
       else cast( 0 as abap.dec(23,2))
        end                                   as IGST,
      case
      when J.ConditionType = 'JOUG'
       then cast( J.ConditionAmount as abap.dec(23,2))
       else cast( 0 as abap.dec(23,2))
        end                                   as UTGST,
      case
      when J.ConditionType = 'JTC1'
        then cast( J.ConditionAmount as abap.dec(23,2))
       when J.ConditionType = 'JTC2'
        then cast( J.ConditionAmount as abap.dec(23,2))
        else cast ( 0 as abap.dec(23,2) ) end as TCS,
      //SOC on 04.08.25 for roundoff
      case
      when J.ConditionType = 'DRD1'
      then cast( J.ConditionAmount as abap.dec(23,2))
      else cast( 0 as abap.dec(23,2))
      end                                     as ROUNDOFF,
      // EOC
      case
      when J.ConditionType = 'JOCG'
       then cast( J.ConditionRateValue as abap.dec(23,2))
       else cast( 0 as abap.dec(23,2))  end   as CGSTRate,
      case
      when J.ConditionType = 'JOSG'
      then cast( J.ConditionRateValue as abap.dec(23,2))
      else cast( 0 as abap.dec(23,2))  end    as SGSTRate,
      case
      when J.ConditionType =  'JOIG'
       then cast( J.ConditionRateValue as abap.dec(23,2))
       else cast( 0 as abap.dec(23,2)) end    as IGSTRate,
      case
      when J.ConditionType =  'JOUG'
       then cast( J.ConditionRateValue as abap.dec(23,2))
       else cast( 0 as abap.dec(23,2)) end    as UTGSTRate
      //      case
      //      when J.ConditionType = 'ZFRT'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Freight,
      //      case
      //      when J.ConditionType = 'ZFRT'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as FreightRate,
      //      case
      //      when J.ConditionType = 'ZFR1'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Freight1,
      //      case
      //      when J.ConditionType = 'ZFR1'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as FreightRate1,
      //      case
      //      when J.ConditionType = 'ZVOL'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Discount1,
      //      case
      //      when J.ConditionType = 'ZVOL'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as DiscountRate1,
      //      case
      //      when J.ConditionType = 'ZCSH'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Discount2,
      //      case
      //      when J.ConditionType = 'ZCSH'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as DiscountRate2,
      //      case
      //      when J.ConditionType = 'ZSPL'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Discount3,
      //      case
      //      when J.ConditionType = 'ZSPL'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as DiscountRate3,
      //      case
      //      when J.ConditionType = 'ZADV'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Discount4,
      //      case
      //      when J.ConditionType = 'ZADV'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as DiscountRate4,
      //      case
      //      when J.ConditionType = 'ZFIT'
      //       then cast( J.ConditionAmount as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2))
      //        end as Discount5,
      //      case
      //      when J.ConditionType = 'ZFIT'
      //       then cast( J.ConditionRateValue as abap.dec(23,2))
      //       else cast( 0 as abap.dec(23,2)) end as DiscountRate5
}
