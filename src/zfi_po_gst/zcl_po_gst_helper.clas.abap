CLASS zcl_po_gst_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
*
*    TYPES tt_gst_head TYPE STANDARD TABLE OF zpo_i_gst
*      WITH EMPTY KEY.
*
*    TYPES:
*      BEGIN OF ty_msg,
*        fiscalyear         TYPE zpo_gst_db-fiscalyear,
*        companycode        TYPE zpo_gst_db-companycode,
*        accountingdocument TYPE zpo_gst_db-accountingdocument,
*        sourceledger       TYPE zpo_gst_db-sourceledger,
*        ledgergllineitem   TYPE zpo_gst_db-ledgergllineitem,
*        severity           TYPE if_abap_behv_message=>t_severity,
*        text               TYPE string,
*      END OF ty_msg.
*
*    TYPES tt_msg TYPE STANDARD TABLE OF ty_msg
*      WITH EMPTY KEY.
*
*    TYPES tt_status TYPE STANDARD TABLE OF zpo_gst_db
*      WITH EMPTY KEY.
*
*
*    CLASS-METHODS get_next_ackno
*      RETURNING
*        VALUE(rv_ackno) TYPE zpo_gst_db-ackno.
*
*
*    CLASS-METHODS post_gst_items
*
*      IMPORTING
*        it_head        TYPE tt_gst_head
*        iv_batch_ackno TYPE zpo_gst_db-ackno
*
*      EXPORTING
*        et_msg         TYPE tt_msg
*        et_status      TYPE tt_status.
*
ENDCLASS.



CLASS ZCL_PO_GST_HELPER IMPLEMENTATION.
ENDCLASS.
