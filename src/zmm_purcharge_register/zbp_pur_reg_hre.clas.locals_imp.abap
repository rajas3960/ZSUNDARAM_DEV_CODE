CLASS lsc_zpur_reg_hre DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zpur_reg_hre IMPLEMENTATION.
  METHOD save_modified.
**********************************************************************
    IF create-_hdr IS NOT INITIAL.
      IF zbp_pur_reg_hre=>gt_hdt IS NOT INITIAL.
        MODIFY zpur_reg_hdr FROM TABLE @zbp_pur_reg_hre=>gt_hdt.
      ENDIF.
    ENDIF.

    IF zbp_pur_reg_hre=>gt_item IS NOT INITIAL.
      MODIFY zpur_reg_itm FROM TABLE @zbp_pur_reg_hre=>gt_item.
    ENDIF.

    IF delete-_hdr IS NOT INITIAL.
      LOOP AT delete-_hdr INTO DATA(ls_del).
        DELETE FROM zpur_reg_hdr WHERE uuid = @ls_del-uuid.
        DELETE FROM zpur_reg_itm WHERE uuid = @ls_del-uuid.
      ENDLOOP.
    ENDIF.
**********************************************************************
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zpur_reg_hre DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    "!
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zpur_reg_hre RESULT result.

    "!
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zpur_reg_hre RESULT result.
    "!
    METHODS gt_data1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _hdr~gt_data1.

ENDCLASS.

CLASS lhc_zpur_reg_hre IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD gt_data1.

**********************************************************************
* Read Header
**********************************************************************
**********************************************************************
READ ENTITIES OF zpur_reg_hre
  IN LOCAL MODE ENTITY _Hdr
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(lt_hdr).

DATA: gs_hdr  TYPE zpur_reg_hdr,
      gs_item TYPE zpur_reg_itm,
      gt_item TYPE STANDARD TABLE OF zpur_reg_itm.

DATA(ls_hdr) = lt_hdr[ 1 ].
MOVE-CORRESPONDING  ls_hdr TO gs_hdr.
ls_hdr-Fromdate = gs_hdr-fromdate.
ls_hdr-Todate = gs_hdr-todate.
APPEND gs_hdr TO zbp_pur_reg_hre=>gt_hdt.

**********************************************************************
* Main Data (Your LT)
**********************************************************************
SELECT *
  FROM zpurchase_register
  WITH PRIVILEGED ACCESS
  WHERE podate BETWEEN @ls_hdr-fromdate AND @ls_hdr-todate
  INTO TABLE @DATA(lt).

**********************************************************************
* Freight Data (IMPORTANT: TABLE, not structure)
**********************************************************************
SELECT  *
  FROM zmm_pur_reg
  WITH PRIVILEGED ACCESS
  WHERE purchaseorderdate BETWEEN @ls_hdr-fromdate AND @ls_hdr-todate
  ORDER BY PurchaseOrder,PurchaseOrderItem
  INTO TABLE @DATA(lt_po).

**********************************************************************
* Sort for processing
**********************************************************************
SORT lt    BY  Purchase_Order sort_flag Material_Document.
*SORT lt_po BY   PurchaseOrderDate.

**********************************************************************
* Running Freight Logic
**********************************************************************
DATA: lv_remain_qty TYPE menge_d.
DATA: lv_po         TYPE ebeln,
      lv_item       TYPE ebelp.
DATA(lv_line) = 0.

LOOP AT lt INTO DATA(ls).

    lv_line += 1.
    CLEAR gs_item.

    IF lv_po <> ls-purchase_order OR
     lv_item <> ls-purchase_orderitem.

    lv_po   = ls-purchase_order.
    lv_item = ls-purchase_orderitem.

    " Read Freight Qty
    READ TABLE lt_po INTO DATA(ls_po)
      WITH KEY PurchaseOrder      = lv_po
               PurchaseOrderItem = lv_item
      BINARY SEARCH.

    IF sy-subrc = 0.
      lv_remain_qty = ls_po-TotalQuantity.   " <-- SAME FIELD NAME
    ELSE.
      lv_remain_qty = 0.
    ENDIF.

  ENDIF.

    " Your existing field mapping
    gs_item-uuid = gs_hdr-uuid.
    gs_item-sno = lv_line.
    gs_item-purchase_order = ls-purchase_order.
    gs_item-purchase_order_item = ls-purchase_orderitem.
    gs_item-material_document = ls-material_document.
    gs_item-material_document_item = ls-material_document_item.
    gs_item-supplierinvoice = ls-supplierinvoice.
    gs_item-supplierinvoiceitem = ls-supplierinvoiceitem.
    gs_item-supplier = ls-supplier.
    gs_item-suppliername = ls-suppliername.
    gs_item-po_creation_date = ls-po_creation_date.
    gs_item-material = ls-material.
    gs_item-poitemtext = ls-poitemtext.
    gs_item-documentdate = ls-documentdate.
    gs_item-supplierinvoice1 = ls-supplierinvoice1.
    gs_item-freightsupplier = ls-freightsupplier.
    gs_item-freightsuppliername = ls-freightsuppliername.
    gs_item-invoicingparty = ls-invoicingparty.
    gs_item-supplier_name = ls-supplier_name.
    gs_item-stransactioncurrency = ls-stransactioncurrency.
    gs_item-accountingdocument = ls-accountingdocument.
    gs_item-glaccount = ls-glaccount.
    gs_item-glaccountname = ls-glaccountname.
    gs_item-movement_type = ls-movement_type.
    gs_item-movementtypename = ls-movementtypename.
    gs_item-companycode = ls-companycode.
    gs_item-quantity = ls-quantity.
    gs_item-materialbaseunit = ls-materialbaseunit.
    gs_item-materialdocumentheadertext = ls-materialdocumentheadertext.
    gs_item-conditiontypename = ls-conditiontypename.
    gs_item-freightamount = ls-freightamount.
    gs_item-amountincompanycodecurrency = ls-amountincompanycodecurrency.
    gs_item-frghtglaccount = ls-frghtglaccount.
    gs_item-totalquantity = ls-totalquantity.
    gs_item-podate = ls-podate.

    " 👉 CORE LOGIC (Running Freight Check)
    if ls-Material_Document  IS NOT INITIAL.
    IF lv_remain_qty >= ls-quantity.
      gs_item-status = 'YES'.
      lv_remain_qty = lv_remain_qty - ls-quantity.
    ELSE.
      gs_item-status = 'NO'.
      gs_item-remain = lv_remain_qty.
    ENDIF.
    ENDIF.

    APPEND gs_item TO zbp_pur_reg_hre=>gt_item.


ENDLOOP.
**********************************************************************

  ENDMETHOD.

ENDCLASS.
