@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit and Debit Note Item View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_ITEM_VIEW
  as select from    I_JournalEntry                as JOH
    inner join      I_JournalEntryItem            as JOI    on  JOI.AccountingDocument                  = JOH.AccountingDocument
                                                            and JOI.FiscalYear                          = JOH.FiscalYear
                                                            and JOI.CompanyCode                         = JOH.CompanyCode
                                                            and JOI.Ledger                              = '0L'
                                                            and (
                                                               (
                                                                 JOI.AccountingDocumentType             = 'KG'
                                                                 and(
                                                                   JOI.GLAccountType                    = 'P'
                                                                   and JOI.TransactionTypeDetermination is initial
                                                                 )
                                                               )
                                                               or(
                                                                 JOI.AccountingDocumentType             = 'KR'
                                                                 and(
                                                                   JOI.GLAccountType                    = 'P'
                                                                   and JOI.TransactionTypeDetermination is initial
                                                                 )
                                                               )
                                                               or(
                                                                 JOI.AccountingDocumentType             = 'RE'
                                                                 and(
                                                                   JOI.GLAccountType                    = 'X'
                                                                   and JOI.TransactionTypeDetermination = 'WRX'
                                                                 )
                                                               )
                                                             )
    left outer join I_GLAccountText               as GLText on  GLText.ChartOfAccounts = JOI.ChartOfAccounts
                                                            and GLText.GLAccount       = JOI.GLAccount
                                                            and GLText.Language        = $session.system_language
    left outer join I_OperationalAcctgDocItem     as JEI    on  JEI.AccountingDocument     = JOI.AccountingDocument
                                                            and JEI.AccountingDocumentItem = JOI.AccountingDocumentItem
                                                            and JEI.CompanyCode            = JOI.CompanyCode
                                                            and JEI.FiscalYear             = JOI.FiscalYear
  //IGST Cal
    left outer join I_OperationalAcctgDocItem     as IGST   on  IGST.AccountingDocument             = JEI.AccountingDocument
                                                            and IGST.FiscalYear                     = JEI.FiscalYear
                                                            and IGST.CompanyCode                    = JEI.CompanyCode
                                                            and IGST.TaxItemGroup                   = JEI.TaxItemGroup
                                                            and (
                                                               IGST.TransactionTypeDetermination    = 'JII'
                                                               or IGST.TransactionTypeDetermination = 'JIN'
                                                               or IGST.TransactionTypeDetermination = 'JIM'
                                                             )
    left outer join I_TaxCodeRate                 as IGSTR  on  IGSTR.TaxCode                = IGST.TaxCode
                                                            and IGSTR.AccountKeyForGLAccount = IGST.TransactionTypeDetermination
  //CGST Cal
    left outer join I_OperationalAcctgDocItem     as CGST   on  CGST.AccountingDocument             = JEI.AccountingDocument
                                                            and CGST.FiscalYear                     = JEI.FiscalYear
                                                            and CGST.CompanyCode                    = JEI.CompanyCode
                                                            and CGST.TaxItemGroup                   = JEI.TaxItemGroup
                                                            and (
                                                               CGST.TransactionTypeDetermination    = 'JIC'
                                                               or CGST.TransactionTypeDetermination = 'JCN'
                                                             )
    left outer join I_TaxCodeRate                 as CGSTR  on  CGSTR.TaxCode                = CGST.TaxCode
                                                            and CGSTR.AccountKeyForGLAccount = CGST.TransactionTypeDetermination
  //SGST Cal
    left outer join I_OperationalAcctgDocItem     as SGST   on  SGST.AccountingDocument             = JEI.AccountingDocument
                                                            and SGST.FiscalYear                     = JEI.FiscalYear
                                                            and SGST.CompanyCode                    = JEI.CompanyCode
                                                            and SGST.TaxItemGroup                   = JEI.TaxItemGroup
                                                            and (
                                                               SGST.TransactionTypeDetermination    = 'JIS'
                                                               or SGST.TransactionTypeDetermination = 'JSN'
                                                             )
    left outer join I_TaxCodeRate                 as SGSTR  on  SGSTR.TaxCode                = SGST.TaxCode
                                                            and SGSTR.AccountKeyForGLAccount = SGST.TransactionTypeDetermination
  //"""With PO Details for Credit debit note
    left outer join ZFI_PO_ITEM                   as POI    on  POI.PurchaseOrder     = JOI.PurchasingDocument
                                                            and POI.PurchaseOrderItem = JOI.PurchasingDocumentItem

    left outer join I_SuplrInvcItemPurOrdRefAPI01 as Supp   on  Supp.SupplierInvoice     = JOI.ReferenceDocument
                                                            and Supp.SupplierInvoiceItem = JOI.ReferenceDocumentItem
                                                            and Supp.FiscalYear          = JOI.FiscalYear

{
  key JOI.SourceLedger,
  key JOI.CompanyCode,
  key JOI.FiscalYear,
  key JOI.AccountingDocument,
  key JOI.LedgerGLLineItem,
      JOI.AccountingDocumentItem,
      JOI.AccountingDocumentType,
      JOI.Plant,
      JOI.GLAccount,
      GLText.GLAccountLongName,
      JOI.CompanyCodeCurrency,
      case
          when JOI.AccountingDocumentType = 'KG' then
          cast(JOI.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1
          when JOI.AccountingDocumentType = 'KR' then
          cast(JOI.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1
          when ( JOI.AccountingDocumentType = 'RE' and JOI.DebitAmountInCoCodeCrcy is initial ) then
          cast(JOI.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1

          when ( JOI.AccountingDocumentType = 'RE' and JOI.CreditAmountInCoCodeCrcy is initial ) then
          cast(JOI.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1

          else null end                                       as TaxableValue,

      //        cast(JOI.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1 as TaxableValue,
      JOI.TaxCode,
      JEI.TaxItemGroup,
      //    cast(CGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) as CgstAmt,
      // CGST
      cast(
          case
              when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
              then 0
              else cast(CGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ))
          end
          as abap.dec( 15, 2 )
      )                                                       as CgstAmt,
      //    cast(CGSTR.ConditionRateRatio as abap.dec( 15, 2 )) as CgstRate,
      cast(
          case
              when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
              then 0
              else cast(CGSTR.ConditionRateRatio as abap.dec( 15, 2 ))
          end as abap.dec( 15, 2 ))                           as CgstRate,
      //    CGSTR.ConditionRateRatioUnit as CgstRateRatio,
      case
           when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
          then cast( '' as abap.char( 3 ) )
          else CGSTR.ConditionRateRatioUnit
      end                                                     as CgstRateRatio,
      //    cast(SGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) as SgstAmt,
      cast(
          case
              when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
              then 0
              else cast(SGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ))
          end
          as abap.dec( 15, 2 )
      )                                                       as SgstAmt,
      //    cast(SGSTR.ConditionRateRatio as abap.dec( 15, 2 )) as SgstRate,
      cast(
          case
              when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
              then 0
              else cast(SGSTR.ConditionRateRatio as abap.dec( 15, 2 ))
          end as abap.dec( 15, 2 ))                           as SgstRate,
      //    SGSTR.ConditionRateRatioUnit as SgstRateRatio,
      case
           when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
          then cast( '' as abap.char( 3 ) )
          else SGSTR.ConditionRateRatioUnit
      end                                                     as SgstRateRatio,
      //    cast(IGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) as IgstAmt,
      cast(
          case
              when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
              then 0
              else cast(IGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ))
          end
          as abap.dec( 15, 2 )
      )                                                       as IgstAmt,
      //    cast(IGSTR.ConditionRateRatio as abap.dec( 15, 2 )) as IgstRate,

      cast(
          case
              when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
              then 0
              else cast(IGSTR.ConditionRateRatio as abap.dec( 15, 2 ))
          end as abap.dec( 15, 2 ))                           as IgstRate,
      //    IGSTR.ConditionRateRatioUnit as IgstRateRatio,

      case
           when JOI.TaxCode = 'J1'
                or JOI.TaxCode = 'J2'
                or JOI.TaxCode = 'J3'
                or JOI.TaxCode = 'J4'
                or JOI.TaxCode = 'J5'
                or JOI.TaxCode = 'J6'
                or JOI.TaxCode = 'R1'
                or JOI.TaxCode = 'RA'
                or JOI.TaxCode = 'RB'
                or JOI.TaxCode = 'RC'
                or JOI.TaxCode = 'RD'
                or JOI.TaxCode = 'RE'
                or JOI.TaxCode = 'RF'
                or JOI.TaxCode = 'RG'
                or JOI.TaxCode = 'RH'
                or JOI.TaxCode = 'RI'
                or JOI.TaxCode = 'RJ'
                or JOI.TaxCode = 'RN'
                or JOI.TaxCode = 'RS'
          then cast( '' as abap.char( 3 ) )
          else IGSTR.ConditionRateRatioUnit
      end                                                     as IgstRateRatio,
      JOI.InvoiceReference,
      //"""This one With PO Process
      POI.PurchaseOrder,
      POI.PurchaseOrderItem,
      POI.Material,
      POI.PurchaseOrderItemText,
      POI.HSNCode,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      POI.OrderQuantity                                       as POOrderQuantity,
      POI.BaseUnit,
      POI.Rate,
      POI.Amount                                              as POAmount,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      Supp.QuantityInPurchaseOrderUnit                        as OrderQuantity,
      Supp.DocumentCurrency,

      cast(Supp.SupplierInvoiceItemAmount as abap.dec(15,2) ) as Amount

}
//where JOI.GLAccountType = 'P'
//and JOH.AccountingDocumentType = 'KG'
