@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TDS ROOT VIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZTDS_RV as select from I_JournalEntry                     as JOE

inner join I_JournalEntryItem   as JOI     on JOI.AccountingDocument = JOE.AccountingDocument
                                                   and JOI.CompanyCode = JOE.CompanyCode
                                                   and JOI.FiscalYear = JOE.FiscalYear
                                                   and JOI.SourceLedger = '0L' 
                                                   and JOI.Ledger = '0L'
             
            left outer join I_Supplier as  SUP     on SUP.Supplier = JOI.Supplier  
                                                   and SUP.Customer = JOI.Customer                                                                                                                                                                
                                                          
            left outer join  I_Withholdingtaxitem as WHT on WHT.AccountingDocument = JOI.AccountingDocument
                                                   and WHT.CompanyCode = JOI.CompanyCode
                                                   and WHT.FiscalYear = JOI.FiscalYear 
                                                   and WHT.AccountingDocumentItem = JOI.AccountingDocumentItem  
           
          left outer join I_OperationalAcctgDocItem as IOP on IOP.AccountingDocument = JOI.AccountingDocument
                                                   and IOP.CompanyCode = JOI.CompanyCode
                                                   and IOP.FiscalYear = JOI.FiscalYear 
                                                   and IOP.AccountingDocumentItem = JOI.AccountingDocumentItem 
////          
          left outer join I_OperationalAcctgDocItem as JOC on JOC.AccountingDocument = JOI.AccountingDocument
                                                   and JOC.CompanyCode = JOI.CompanyCode
                                                   and JOC.FiscalYear = JOI.FiscalYear 
                                                   and JOC.TransactionTypeDetermination = 'JIC'
                                                   
          left outer join I_OperationalAcctgDocItem as JOS on JOS.AccountingDocument = JOI.AccountingDocument
                                                   and JOS.CompanyCode = JOI.CompanyCode
                                                   and JOS.FiscalYear = JOI.FiscalYear 
                                                   and JOS.TransactionTypeDetermination = 'JIS'
                                                     
          left outer join I_OperationalAcctgDocItem as JOG on JOG.AccountingDocument = JOI.AccountingDocument
                                                   and JOG.CompanyCode = JOI.CompanyCode
                                                   and JOG.FiscalYear = JOI.FiscalYear 
                                                   and JOG.TransactionTypeDetermination = 'JII'                                                                           
//                                                   
        left outer join I_Withholdingtaxitem as JIG on JIG.AccountingDocument = JOI.AccountingDocument
                                                   and JIG.CompanyCode = JOI.CompanyCode
                                                   and JIG.FiscalYear = JOI.FiscalYear 
                                                   and JIG.GLAccount = '0000248017'  
                                                   
         left outer join I_Withholdingtaxitem as JIC on JIC.AccountingDocument = JOI.AccountingDocument
                                                   and JIC.CompanyCode = JOI.CompanyCode
                                                   and JIC.FiscalYear = JOI.FiscalYear 
                                                   and JIC.GLAccount = '0000248007'                                                                                                                                                          


       left outer join I_Withholdingtaxitem as JIS on JIS.AccountingDocument = JOI.AccountingDocument
                                                   and JIS.CompanyCode = JOI.CompanyCode
                                                   and JIS.FiscalYear = JOI.FiscalYear 
                                                   and JIS.GLAccount = '0000248008'                                                                                                                              


                                                                                                                       
{
    key JOI.SourceLedger,
    key JOI.CompanyCode,
    key JOI.FiscalYear,
    key JOI.AccountingDocument,
    key JOI.LedgerGLLineItem, 
    key JOI.Ledger,
        JOI.TransactionCurrency,
        JOE.PostingDate,
        JOI.ReferenceDocument,
        JOI.Supplier,
        SUP.SupplierFullName,
//        CUST.CustomerFullName,
        SUP.TaxNumber3,
        SUP.BusinessPartnerPanNumber,
        
         @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'H' or JOI.DebitCreditCode = 'S'
       then  
       WHT.WhldgTaxBaseAmtInTransacCrcy * -1 
       else
       WHT.WhldgTaxBaseAmtInTransacCrcy end                 as WhldgTaxBaseAmtInTransacCrcy,
       WHT.WithholdingTaxPercent,
       
       @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'S' 
       then  
       JOG.AmountInTransactionCurrency * -1 
       else
       JOG.AmountInTransactionCurrency end                 as IGSTAMOUNT,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'S' 
       then  
       JOC.AmountInTransactionCurrency * -1 
       else
       JOC.AmountInTransactionCurrency end                 as CGSTAMOUNT,

        @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'S' 
       then   
       JOS.AmountInTransactionCurrency * -1 
       else
       JOS.AmountInTransactionCurrency end                 as SGSTAMOUNT,

     @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'H' 
       then  
       JIG.WhldgTaxAmtInTransacCrcy * -1 
       else
       JIG.WhldgTaxAmtInTransacCrcy end                 as IGSTTDSAMOUNT,
        @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'H' 
       then  
       JIC.WhldgTaxAmtInTransacCrcy * -1 
       else
       JIC.WhldgTaxAmtInTransacCrcy end                 as CGSTTDSAMOUNT,

        @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when JOI.DebitCreditCode = 'H' 
       then   
       JIS.WhldgTaxAmtInTransacCrcy * -1 
       else
       JIS.WhldgTaxAmtInTransacCrcy end                 as SGSTTDSAMOUNT,
              

@Semantics.amount.currencyCode: 'TransactionCurrency'
cast(

    + coalesce(
        cast(
          case when JOI.DebitCreditCode = 'H' 
           then
               JIC.WhldgTaxAmtInTransacCrcy * -1
            else JIC.WhldgTaxAmtInTransacCrcy
          end
          as abap.dec(23,2)
        ),
        cast( 0 as abap.dec(23,2) )
      )

    + coalesce(
        cast(
          case when JOI.DebitCreditCode = 'H' 
          then JIS.WhldgTaxAmtInTransacCrcy * -1
            else JIS.WhldgTaxAmtInTransacCrcy
          end
          as abap.dec(23,2)
        ),
        cast( 0 as abap.dec(23,2) )
      )

    + coalesce(
        cast(
          case when JOI.DebitCreditCode = 'H' 
           then JIG.WhldgTaxAmtInTransacCrcy * -1
            else JIG.WhldgTaxAmtInTransacCrcy
          end
          as abap.dec(23,2)
        ),
        cast( 0 as abap.dec(23,2) )
      )

     as abap.dec(23,2)) as TDSAmount,
     
@Semantics.amount.currencyCode: 'TransactionCurrency'
cast(

      coalesce(
          cast(
              case
                  when JOI.DebitCreditCode ='S' or JOI.DebitCreditCode ='H'
                  then WHT.WhldgTaxBaseAmtInTransacCrcy * -1
                  else WHT.WhldgTaxBaseAmtInTransacCrcy
              end as abap.dec(23,2)
          ),
          cast(0 as abap.dec(23,2))
      )

    + coalesce(
          cast(
              case
                  when JOI.DebitCreditCode = 'S'
                  then JOC.AmountInTransactionCurrency * -1
                  else JOC.AmountInTransactionCurrency
              end as abap.dec(23,2)
          ),
          cast(0 as abap.dec(23,2))
      )

    + coalesce(
          cast(
              case
                  when JOI.DebitCreditCode = 'S'
                  then JOS.AmountInTransactionCurrency * -1
                  else JOS.AmountInTransactionCurrency
              end as abap.dec(23,2)
          ),
          cast(0 as abap.dec(23,2))
      )

    + coalesce(
          cast(
              case
                  when JOI.DebitCreditCode = 'S'
                  then JOG.AmountInTransactionCurrency * -1
                  else JOG.AmountInTransactionCurrency
              end as abap.dec(23,2)
          ),
          cast(0 as abap.dec(23,2))
      )

as abap.dec(23,2)) as TotalValue
                      

   }
   where WHT.WithholdingTaxType = 'TU'
   or WHT.WithholdingTaxType = 'TV'
   or WHT.WithholdingTaxType = 'TS';
   
//    where IOP.WithholdingTaxCode = 'TU'
//   or IOP.WithholdingTaxCode = 'TV'
//   or IOP.WithholdingTaxCode = 'TS';
   
