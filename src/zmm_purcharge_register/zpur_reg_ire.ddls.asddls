@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPUR_REG_IRE
  as select from zpur_reg_itm
  association to parent ZPUR_REG_HRE as _Hdr on $projection.Uuid = _Hdr.Uuid
{
  key uuid                                               as Uuid,
  key sno,
  key purchase_order                                     as PurchaseOrder,
  key purchase_order_item                                as PurchaseOrderItem,
  key material_document                                  as MaterialDocument,
  key material_document_item                             as MaterialDocumentItem,
      case when material_document_year is null
      then '0000' else
      cast (material_document_year as abap.char(10)) end as MaterialDocumentYear,
      //    material_document_year as MaterialDocumentYear,
      //  supplierinvoice as Supplierinvoice,
      case when zpur_reg_itm.supplierinvoice is null
      then 'No Invoice Posted'
      else zpur_reg_itm.supplierinvoice end                           as Supplierinvoice,
      //    supplierinvoiceitem as Supplierinvoiceitem,
      case when supplierinvoiceitem is null
           then 'No Item' else
      cast( supplierinvoiceitem as abap.char(10)) end    as Supplierinvoiceitem,
      supplier                                           as Supplier,
      suppliername                                       as Suppliername,
      po_creation_date                                   as PoCreationDate,
      material                                           as Material,
      poitemtext                                         as Poitemtext,
      documentdate                                       as Documentdate,
      supplierinvoice1                                   as Supplierinvoice1,
      freightsupplier                                    as Freightsupplier,
      freightsuppliername                                as Freightsuppliername,
      invoicingparty                                     as Invoicingparty,
      supplier_name                                      as SupplierName1,
      stransactioncurrency                               as Stransactioncurrency,
      accountingdocument                                 as Accountingdocument,
      glaccount                                          as Glaccount,
      glaccountname                                      as Glaccountname,
      movement_type                                      as MovementType,
      movementtypename                                   as Movementtypename,
      companycode                                        as Companycode,
      quantity                                           as Quantity,
      materialbaseunit                                   as Materialbaseunit,
      materialdocumentheadertext                         as Materialdocumentheadertext,
      conditiontypename                                  as Conditiontypename,
      freightamount                                      as Freightamount,
      amountincompanycodecurrency                        as Amountincompanycodecurrency,
      frghtglaccount                                     as Frghtglaccount,
      totalquantity                                      as Totalquantity,
      podate                                             as Podate,
      status,
      remain,
      _Hdr
}
