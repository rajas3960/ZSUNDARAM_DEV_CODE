@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register PV for item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZPUR_REG_IPV as projection on ZPUR_REG_IRE
{
    key Uuid,
    key sno,
    key PurchaseOrder,
    key PurchaseOrderItem,
    key MaterialDocument,
    key MaterialDocumentItem,
    MaterialDocumentYear,
    Supplierinvoice,
    Supplierinvoiceitem,
    Supplier,
    Suppliername,
    PoCreationDate,
    Material,
    Poitemtext,
    Documentdate,
    Supplierinvoice1,
    Freightsupplier,
    Freightsuppliername,
    Invoicingparty,
    SupplierName1,
    Stransactioncurrency,
    Accountingdocument,
    Glaccount,
    Glaccountname,
    MovementType,
    Movementtypename,
    Companycode,
    Quantity,
    Materialbaseunit,
    Materialdocumentheadertext,
    Conditiontypename,
    Freightamount,
    Amountincompanycodecurrency,
    Frghtglaccount,
    Totalquantity,
    Podate,
    status,
    remain,
    /* Associations */
    _Hdr : redirected to parent ZPUR_REG_HPV
}
