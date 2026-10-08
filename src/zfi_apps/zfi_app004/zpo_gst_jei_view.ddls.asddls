@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_GST_JEI_VIEW as select from  I_JournalEntry            as a
    inner join      I_JournalEntryItem        as b     on  b.AccountingDocument                  = a.AccountingDocument
                                                       and b.FiscalYear                          = a.FiscalYear
                                                       and b.CompanyCode                         = a.CompanyCode
                                                       and b.Ledger                              = '0L'
                                                       and (
                                                          ( b.AccountingDocumentType             = 'KG'
                                                            and( b.GLAccountType                    = 'P'
                                                              and b.TransactionTypeDetermination is initial ) )
                                                          or ( b.AccountingDocumentType             = 'KR'
                                                            and( b.GLAccountType                    = 'P'
                                                              and b.TransactionTypeDetermination is initial ) )
                                                          or ( b.AccountingDocumentType             = 'KA'
                                                            and( b.GLAccountType                    = 'P'
                                                              and b.TransactionTypeDetermination is initial ) )                                                              
                                                          or( b.AccountingDocumentType             = 'RE'
                                                            and( ( b.GLAccountType = 'X' or b.GLAccountType = 'P' )
                                                              and ( b.TransactionTypeDetermination = 'WRX' or b.TransactionTypeDetermination = 'FR1' 
                                                                    or b.TransactionTypeDetermination = 'FR2' or b.TransactionTypeDetermination = 'ANL' 
                                                                    or b.TransactionTypeDetermination = 'FR3' or b.TransactionTypeDetermination = 'BSX' ) ) )
                                                        )
  //GST Cal
    left outer join I_OperationalAcctgDocItem as JEI   on  JEI.AccountingDocument     = b.AccountingDocument
                                                       and JEI.AccountingDocumentItem = b.AccountingDocumentItem
                                                       and JEI.CompanyCode            = b.CompanyCode
                                                       and JEI.FiscalYear             = b.FiscalYear
  //IGST Cal
    left outer join I_OperationalAcctgDocItem as IGST  on  IGST.AccountingDocument             = JEI.AccountingDocument
                                                       and IGST.FiscalYear                     = JEI.FiscalYear
                                                       and IGST.CompanyCode                    = JEI.CompanyCode
                                                       and IGST.TaxItemGroup                   = JEI.TaxItemGroup
                                                       and (
                                                          IGST.TransactionTypeDetermination    = 'JII'
                                                          or IGST.TransactionTypeDetermination = 'JIN'
                                                          or IGST.TransactionTypeDetermination = 'JIM'
                                                        )
    left outer join ZTAXCODE            as IGSTR on  IGSTR.TaxCode                = IGST.TaxCode
                                                       and IGSTR.AccountKeyForGLAccount = IGST.TransactionTypeDetermination
  //CGST Cal
    left outer join I_OperationalAcctgDocItem as CGST  on  CGST.AccountingDocument             = JEI.AccountingDocument
                                                       and CGST.FiscalYear                     = JEI.FiscalYear
                                                       and CGST.CompanyCode                    = JEI.CompanyCode
                                                       and CGST.TaxItemGroup                   = JEI.TaxItemGroup
                                                       and (
                                                          CGST.TransactionTypeDetermination    = 'JIC'
                                                          or CGST.TransactionTypeDetermination = 'JCN'
                                                        )
    left outer join ZTAXCODE             as CGSTR on  CGSTR.TaxCode                = CGST.TaxCode
                                                       and CGSTR.AccountKeyForGLAccount = CGST.TransactionTypeDetermination
  //SGST Cal
    left outer join I_OperationalAcctgDocItem as SGST  on  SGST.AccountingDocument             = JEI.AccountingDocument
                                                       and SGST.FiscalYear                     = JEI.FiscalYear
                                                       and SGST.CompanyCode                    = JEI.CompanyCode
                                                       and SGST.TaxItemGroup                   = JEI.TaxItemGroup
                                                       and (
                                                          SGST.TransactionTypeDetermination    = 'JIS'
                                                          or SGST.TransactionTypeDetermination = 'JSN'
                                                        )
    left outer join ZTAXCODE             as SGSTR on  SGSTR.TaxCode                = SGST.TaxCode
                                                       and SGSTR.AccountKeyForGLAccount = SGST.TransactionTypeDetermination
{
  key b.FiscalYear,
  key b.SourceLedger,
  key b.CompanyCode,
  key b.AccountingDocument,
  key b.LedgerGLLineItem,
      b.AccountingDocumentType,
      b.TaxCode,
      case
//              when b.AccountingDocumentType = 'KG' then
//              cast(b.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1
//              when b.AccountingDocumentType = 'KR' then
//              cast(b.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1

      when ( b.AccountingDocumentType = 'KG' and b.DebitAmountInCoCodeCrcy is initial ) then
      cast(b.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1
      when ( b.AccountingDocumentType = 'KG' and b.CreditAmountInCoCodeCrcy is initial ) then
      cast(b.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1
      
      when ( b.AccountingDocumentType = 'KR' and b.DebitAmountInCoCodeCrcy is initial ) then
      cast(b.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1
      when ( b.AccountingDocumentType = 'KR' and b.CreditAmountInCoCodeCrcy is initial ) then
      cast(b.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1      

      when ( b.AccountingDocumentType = 'KA' and b.DebitAmountInCoCodeCrcy is initial ) then
      cast(b.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1
      when ( b.AccountingDocumentType = 'KA' and b.CreditAmountInCoCodeCrcy is initial ) then
      cast(b.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1            

      when ( b.AccountingDocumentType = 'RE' and b.DebitAmountInCoCodeCrcy is initial ) then
      cast(b.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1
      when ( b.AccountingDocumentType = 'RE' and b.CreditAmountInCoCodeCrcy is initial ) then
      cast(b.DebitAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * +1

      else null end                                                 as InvoiceValue,

      cast(CGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) as CgstAmt,
      cast(CGSTR.ConditionRateRatio as abap.dec( 15, 2 ))           as CgstRate,
      CGST.TransactionTypeDetermination                             as CgstType,

      cast(SGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) as SgstAmt,
      cast(SGSTR.ConditionRateRatio as abap.dec( 15, 2 ))           as SgstRate,
      SGST.TransactionTypeDetermination                             as SgstType,

      cast(IGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) as IgstAmt,
      cast(IGSTR.ConditionRateRatio as abap.dec( 15, 2 ))           as IgstRate,
      IGST.TransactionTypeDetermination                             as IgstType
}
where b.TaxCode is not initial
