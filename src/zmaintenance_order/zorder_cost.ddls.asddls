@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'maintenance order cost value'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZORDER_COST 
as select from I_MaintenanceOrderBasic as a
inner join I_MaintOrderComponentDEX  as  b  on b.MaintenanceOrder = a.MaintenanceOrder
left outer join I_MaterialDocumentItem_2  as c on c.Reservation = b.Reservation
                                              and c.ReservationItem = b.ReservationItem
left outer join I_JournalEntryItem as d  on c.MaterialDocument = d.ReferenceDocument
                                         and c.MaterialDocumentItem = substring(d.ReferenceDocumentItem, 3, 4)
                                         and d.Ledger = '0L'
                                         and d.GLAccountType = 'P'
left outer join I_PurchaseRequisitionItemAPI01 as e on e.PurchaseRequisition     = b.PurchaseRequisition
                                                    and e.PurchaseRequisitionItem = b.PurchaseRequisitionItem                                        
{
    key a.MaintenanceOrder,
    key b.Reservation,
    key b.ReservationItem,
    key b.ReservationType,
        b.MaintenanceOrderOperation,
        c.MaterialDocument,
        c.MaterialDocumentItem,
        c.MaterialDocumentYear,
        d.CompanyCode,
        d.AccountingDocument,
        d.LedgerGLLineItem,
        d.GLAccountType,
        e.PurchaseRequisition,
        e.PurchaseRequisitionItem,
        cast(d.CreditAmountInCoCodeCrcy as abap.dec( 13, 2 )) as CreditAmt,
        cast(coalesce(e.ItemNetAmount,d.DebitAmountInCoCodeCrcy) as abap.dec(13,2)) as DebitAmt
       // cast(d.DebitAmountInCoCodeCrcy as abap.dec( 13, 2 )) as DebitAmt 
    
    
}
where c.Reservation is not initial or e.PurchaseRequisition is not initial
//or d.GLAccountType = 'P'
