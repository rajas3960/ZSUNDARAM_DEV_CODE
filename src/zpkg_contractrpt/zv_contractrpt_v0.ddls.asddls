@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Report'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZV_CONTRACTRPT_V0
 
  as select distinct from I_SalesContract              as a
    inner join            zdt_user_auth                as user on  user.companycode = a.BillingCompanyCode
                                                               and user.cbuser      = $session.user

    inner join            I_SalesContractItem          as c    on c.SalesContract = a.SalesContract
  //

  //  inner join      I_SalesDocumentItem as i on  a.SalesContract = i.ReferenceSDDocument        // ++ 27.08.25
    left outer join       ZV_CONTRACTREP_V00           as i    on i.SalesContract = a.SalesContract

    inner join            I_SlsContrItemPricingElement as f    on  f.SalesContract     = c.SalesContract
                                                               and f.SalesContractItem = c.SalesContractItem
                                                               and f.ConditionType     = 'ZPR0'

    left outer join       ZI_SALESITEMGROSSPRICE       as j    on  j.SalesDocument     = a.SalesContract
                                                               and j.SalesDocumentItem = c.SalesContractItem

    inner join            I_Customer                   as g    on g.Customer = a.SoldToParty

    left outer join       I_SalesContractPartner       as b    on  b.SalesContract   = a.SalesContract
                                                               and b.PartnerFunction = 'ZB'


    left outer join       ZV_CONTRACTRPT_V1            as d    on  d.SalesContract     = c.SalesContract
                                                               and d.SalesContractItem = c.SalesContractItem

    left outer join       ZV_CONTRACTRPT_V5            as e    on e.Customer = a.SoldToParty

    left outer join       ZV_CONTRACTRPT_V7            as h    on h.Customer = a.SoldToParty
    left outer join       ZV_CONTRACTRPT_C2            as c2   on c2.Customer = a.SoldToParty
    left outer join       ZV_CONTRACTRPT_V9            as o    on  o.Customer    = a.SoldToParty
                                                               and o.CompanyCode = a.BillingCompanyCode
  //                                                               and o.BillingDocument = d.BillingDocument
  //      left outer join       ZV_CONTRACTRPT_C             as cl   on  cl.SalesDocument     = c.SalesContract
  //                                                                 and cl.SalesDocumentItem = c.SalesContractItem
  //                                                                 and cl.AccountingDocumentItem = o.AccountingDocumentItem
  //                                                                 and cl.ClearingJournalEntry   = o.ClearingJournalEntry
  //                                                                 and cl.Customer               = a.SoldToParty
  //                                                                 and cl.CompanyCode            = a.BillingCompanyCode
    left outer join       ZV_CONTRACTRPT_V11           as r    on  r.SalesContract     = c.SalesContract
                                                               and r.SalesContractItem = c.SalesContractItem
    left outer join       ZV_CONTRACTRPT_V8            as p    on  p.SalesContract     = c.SalesContract
                                                               and p.SalesContractItem = c.SalesContractItem
    inner join            I_PaymentTermsText           as pt   on pt.PaymentTerms = a.CustomerPaymentTerms // ++ 11.09.25
{

  key a.SalesContract,
  key c.SalesContractItem,

      a.SalesOrganization,
      a.DistributionChannel,
      a.OrganizationDivision,
      b.Partner                                                                                                                   as Broker,
      b.FullName                                                                                                                  as BrokerName,
      a.SalesContractDate,
      a.SalesContractValidityEndDate,
      a.SoldToParty,
      g.CustomerFullName,
      f.TransactionCurrency,
      cast( f.ConditionRateValue as abap.dec( 21,2 ) )                                                                            as ConditionValue,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      f.ConditionAmount,
      c.RequestedQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      c.RequestedQuantity                                                                                                         as ContractQty,
      //      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      //      d.BillingQuantity                                                                                                           as InvoicedQty,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      p.BillingQuantity                                                                                                           as InvoicedQty,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      //      case when d.BillingQuantity > 0 then c.RequestedQuantity - d.BillingQuantity
      //      else c.RequestedQuantity end                                                                                                as PendingQty,
      case when p.BillingQuantity > 0 then c.RequestedQuantity - p.BillingQuantity
      else c.RequestedQuantity end                                                                                                as PendingQty,
      e.CompanyCodeCurrency                                                                                                       as CreditSegmentCurrency,
      @Semantics.amount.currencyCode: 'CreditSegmentCurrency'
      cast( e.AmountInCompanyCodeCurrency * -1 as  abap.dec( 21,2 )) - cast(c2.AmountInCompanyCodeCurrency  as  abap.dec( 21,2 )) as EffectiveTotalCreditLimitAmt,
      //      r.customercreditlimit                                                                                                   as EffectiveTotalCreditLimitAmt,
      //      cast( o.AmountInCompanyCodeCurrency as abap.dec(21,2))                                                                      as CreditLimitAmt,
      //      cast( p.Netamount as abap.dec(21,2))                                                                                        as CreditLimitAmt,

      //            cast( cl.netvalue as abap.dec(21,2))                                                                                    as CreditLimitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      r.customercreditlimit                                                                                                       as CreditLimitAmt,
      // e.AmountInCompanyCodeCurrency * -1  as EffectiveTotalCreditLimitAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      division( cast( f.ConditionAmount as abap.dec( 21,2 ) ) * 10, 100, 2 )                                                      as ReserveValue,
      h.CompanyCodeCurrency,
      //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      // ( h.AmountInCompanyCodeCurrency  - e.AmountInCompanyCodeCurrency * -1 )                  as Receivable, //minus it from credit limit
      //      case
      //      when h.AmountInCompanyCodeCurrency is not null and e.AmountInCompanyCodeCurrency is not null
      //      then cast( h.AmountInCompanyCodeCurrency as abap.dec( 21,2 ) ) -  cast( e.AmountInCompanyCodeCurrency * -1 as abap.dec( 21,2 ) )
      //      when  h.AmountInCompanyCodeCurrency is not null and e.AmountInCompanyCodeCurrency is null
      //      then cast( h.AmountInCompanyCodeCurrency as abap.dec( 21,2 ) )
      //      when  h.AmountInCompanyCodeCurrency is null and e.AmountInCompanyCodeCurrency is not null
      //      then cast( e.AmountInCompanyCodeCurrency * -1 as abap.dec( 21,2 ) )
      //      else 0
      //      end                                                                                                                             as Receivable
      cast( e.AmountInCompanyCodeCurrency  as  abap.dec( 21,2 )) + cast(c2.AmountInCompanyCodeCurrency  as  abap.dec( 21,2 ))     as Receivable,
      i.SalesOrder                                                                                                                as sales_order_no, // ++ 27.08.25
      //      case
      //      when j.ConditionAmount is initial then 0
      //      else cast( f.ConditionRateValue as abap.dec(21,2) ) +
      //      cast( ( cast(j.ConditionAmount as abap.dec(21,3) ) / cast( c.RequestedQuantity as abap.dec(21,3) ) )    as abap.dec(21,2) )
      //      end                                                                                                                         as GrossPricePerTon,

      //      case
      //      when j.ConditionAmount is initial then 0
      //      else  cast( (cast( c.NetAmount as abap.dec(21,3) ) + cast( c.TaxAmount as abap.dec(21,3) ) ) / cast( c.RequestedQuantity as abap.dec(21,3) )
      //            as abap.dec(21,2)
      //          )
      //      end                                                                                                                         as GrossPricePerTon,

      case
      when j.ConditionAmount is initial
      or c.RequestedQuantity is initial
      or c.RequestedQuantity = 0
      then 0
      else cast(
      ( cast( c.NetAmount as abap.dec(21,3) )
      + cast( c.TaxAmount as abap.dec(21,3) ) )
      / cast( c.RequestedQuantity as abap.dec(21,3) )
      as abap.dec(21,2)
      )
      end                                                                                                                         as GrossPricePerTon,

      pt.PaymentTermsName                                                                                                         as PAYMENTTERMSDESCRIPTION, // ++ 11.09.25
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      p.TotalAmount


}
