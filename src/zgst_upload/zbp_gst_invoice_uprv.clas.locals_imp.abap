CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR header RESULT result.

    METHODS gstupload FOR MODIFY
      IMPORTING keys FOR ACTION header~gstupload RESULT result.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD gstupload.

**********************************************************************
    DATA lv_json          TYPE string.
    DATA clientcd        TYPE string.
    DATA: clientgstin  TYPE string,
          mappingcd    TYPE string,
          templatecd   TYPE string,
          uploadtype   TYPE string,
          periodtype   TYPE string,
          invoicedate  TYPE string,
          SModule       type string,
          PModule       type string,
          invoicevalue TYPE string,
          taxablevalue TYPE string,
          taxrate      TYPE string,
          igstamt      TYPE string,
          cgstamt      TYPE string,
          sgstamt      TYPE string,
          cessamt      TYPE string.
**********************************************************************
    DATA: invoicevalue_n TYPE n LENGTH 13,
          taxablevalue_n TYPE n LENGTH 11,
          taxrate_n      TYPE n LENGTH 2,
          igstamt_n      TYPE n LENGTH 11,
          cgstamt_n      TYPE n LENGTH 11,
          sgstamt_n      TYPE n LENGTH 11,
          cessamt_n      TYPE n LENGTH 11.

    DATA lv_diffgstn    TYPE string.
    DATA: gt_status TYPE TABLE OF zgst_up_statusdb,
          gs_status TYPE zgst_up_statusdb.
**********************************************************************

    READ ENTITIES OF zgst_invoice_uprv IN LOCAL MODE
    ENTITY header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_head)
    FAILED DATA(lt_failed).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head-invoicedt IS NOT INITIAL.
      invoicedate = |{ ls_head-invoicedt+6(2) }-{ ls_head-invoicedt+4(2) }-{ ls_head-invoicedt(4) }|.
    ENDIF.

    IF ls_head-invoicevalue IS NOT INITIAL.
      invoicevalue_n = ls_head-invoicevalue.
      invoicevalue = |{ invoicevalue_n ALPHA = OUT }|.
      CONDENSE invoicevalue.
    ENDIF.
    IF ls_head-taxablevalue IS NOT INITIAL.
      taxablevalue_n = ls_head-taxablevalue.
      taxablevalue = |{ taxablevalue_n ALPHA = OUT }|.
      CONDENSE taxablevalue.
    ENDIF.

    taxrate_n = ls_head-taxrate.
    taxrate = |{ taxrate_n ALPHA = OUT }|.

    igstamt_n = ls_head-igstamount.
    igstamt = |{ igstamt_n ALPHA = OUT }|.
    CONDENSE igstamt.

    cgstamt_n = ls_head-cgstamount.
    cgstamt = |{ cgstamt_n ALPHA = OUT }|.
    CONDENSE cgstamt.

    sgstamt_n = ls_head-sgstamount.
    sgstamt = |{ sgstamt_n ALPHA = OUT }|.
    CONDENSE sgstamt.

    clientgstin = ls_head-selfgstin.
    clientcd = ls_head-clientid.

    IF ls_head-invoiceno IS NOT INITIAL.

*      CONCATENATE
*
*                  ' { '
*                  '"trans_type_code": "B2B",'
*                     '"fp": "032025", '
*                     '"ack_sr_no": "1",'
*                     '"self_gstin": "20AACCC3707F1ZE",'
*                  '"system_cd": "",'
*                  '"branch_cd": "",'
*                  '"vertical_cd": "",'
*                  '"resultflag": "A",'
*                  '"invoice_type": "R",'
*                  '"cp_gstin": "06ASECO9245J5Z4",'
*                  '"cp_gstin_name": "Kamath Foods Pvt. Ltd.",'
*                  '"invoice_no": "TESTSAR125",'
*                  '"invoice_dt": "21-03-2025",'
*                  '"diff_percent": "0.65",'
*                  '"invoice_val": "112",'
*                  '"taxable_val": "100",'
*                  '"items_serial_no": "1",'
*                  '"rate_of_tax": "12",'
*                  '"igst_amnt": "120",'
*                  '"cgst_amnt": "",'
*                  '"sgst_amnt": "",'
*                  '"cess_amnt": "",'
*                  '"pos": "06",'
*                  '"rchrg": "N",'
*                  '"is_gstn_for_ecom_app": "N",'
*                  '"gstn_for_ecom_app": "",'
*                  '"or_cp_gstin": "",'
*                  '"orignal_invoice_no": "",'
*                  '"orignal_invoice_dt": "",'
*                  '"type_of_note": "",'
*                  '"reason_code": "",'
*                  '"is_pre_gst_regime": "",'
*                  '"dbt_crdt_note_no": "",'
*                  '"dbt_crdt_note_dt": "",'
*                  '"dbt_crdt_note_val": "",'
*                  '"diff_value": "",'
*                  '"diff_igst_amnt": "",'
*                  '"diff_cgst_amnt": "",'
*                  '"diff_sgst_amnt": "",'
*                  '"diff_cess_amnt": "",'
*                  '"or_dbt_crdt_note_no": "",'
*                  '"or_dbt_crdt_note_dt": "",'
*                  '"export_type_desc": "",'
*                  '"port_code": "",'
*                  '"export_shipping_bill_no": "",'
*                  '"export_shipping_bill_dt": "",'
*                  '"trans_cat_type": "" '
*                  '}'
*
*                  INTO lv_json.

*//this direct value passing to JSON
      CONCATENATE

                  ' { '
                  '"trans_type_code": "B2B",'
                     '"fp": "' ls_head-monthyear '", '
                     '"ack_sr_no": "' ls_head-accountingdocument '",'
                     '"self_gstin": "' ls_head-selfgstin '",'
                  '"system_cd": "",'
                  '"branch_cd": "",'
                  '"vertical_cd": "",'
                  '"resultflag": "' ls_head-resultflag '",'
                  '"invoice_type": "R",'
                  '"cp_gstin": "' ls_head-cpgstin '",'
                  '"cp_gstin_name": "' ls_head-cpgstinname '",'
                  '"invoice_no": "' ls_head-invoiceno '",'
                  '"invoice_dt": "' invoicedate '",'
                  '"diff_percent": "",'
                  '"invoice_val": "' invoicevalue '",'
                  '"taxable_val": "' taxablevalue '",'
                  '"items_serial_no": "' ls_head-billingdocumentitem '",'
                  '"rate_of_tax": "' taxrate '",'
                  '"igst_amnt": "' igstamt '",'
                  '"cgst_amnt": "' cgstamt '",'
                  '"sgst_amnt": "' sgstamt '",'
                  '"cess_amnt": "",'
                  '"pos": "",'
                  '"rchrg": "N",'
                  '"is_gstn_for_ecom_app": "",'
                  '"gstn_for_ecom_app": "",'
                  '"or_cp_gstin": "",'
                  '"orignal_invoice_no": "",'
                  '"orignal_invoice_dt": "",'
                  '"type_of_note": "",'
                  '"reason_code": "",'
                  '"is_pre_gst_regime": "",'
                  '"dbt_crdt_note_no": "",'
                  '"dbt_crdt_note_dt": "",'
                  '"dbt_crdt_note_val": "",'
                  '"diff_value": "",'
                  '"diff_igst_amnt": "",'
                  '"diff_cgst_amnt": "",'
                  '"diff_sgst_amnt": "",'
                  '"diff_cess_amnt": "",'
                  '"or_dbt_crdt_note_no": "",'
                  '"or_dbt_crdt_note_dt": "",'
                  '"export_type_desc": "",'
                  '"port_code": "",'
                  '"export_shipping_bill_no": "",'
                  '"export_shipping_bill_dt": "",'
                  '"trans_cat_type": "" '
                  '}'

                  INTO lv_json.
*///

      IF clientgstin IS NOT INITIAL AND clientcd IS NOT INITIAL.

        mappingcd = 'MFHSIDTN0000715'.
        templatecd = 'GSTR1SingleExcel855'.
        uploadtype = 'json'.
        pmodule = 'purchaseInvUpld'.   "salesInvUpld
        smodule = 'salesInvUpld'.   "salesInvUpld
        periodtype = ls_head-monthyear.

        TRY.
            FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                        comm_scenario = 'ZCOMM_GST_INTE'
                                        service_id    = 'ZGST_INTE_OS_REST' ).
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).

            "Client CD
            lo_request->set_header_field( i_name  = 'ClientCode'
                                        i_value = clientcd ).
            "Mapping CD
            lo_request->set_header_field( i_name  = 'MappingCD'
                                        i_value = mappingcd ).
            "Template CD
            lo_request->set_header_field( i_name  = 'TemplateCD'
                                        i_value = templatecd ).
            "Client GSTIN
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = clientgstin ).
            "Upload Type
            lo_request->set_header_field( i_name  = 'UpType'
                                          i_value = uploadtype ).
            "Period
            lo_request->set_header_field( i_name  = 'Period'
                                          i_value = periodtype ).

            lo_request->set_text( lv_json ).
            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

      ENDIF.
    ENDIF.
*********************************************************
*            data(ls_result) = '{"Status":202,"ackNo":"25930232123"}'.

    IF ls_result IS NOT INITIAL.
      SPLIT ls_result AT '"Status":' INTO DATA(lv_text) DATA(lv_text1).
      SPLIT lv_text1 AT ',"ac' INTO DATA(finalstatus) DATA(lv_text2).
      SPLIT ls_result AT '"ackNo":"' INTO DATA(lv_text3) DATA(lv_text4).
      SPLIT lv_text4 AT '"}' INTO DATA(ackno) DATA(lv_text5).
      CONDENSE finalstatus.
      CONDENSE ackno.
    ENDIF.
*********************************************************
    IF ackno IS NOT INITIAL.
**********************************************************************
      GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).

      TRY.
          DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
        CATCH cx_abap_context_info_error.
          DATA(ls_x1) = 1.
      ENDTRY.
      DATA(lv_cbuser) = 'CB' && lv_user.

**********************************************************************
      gs_status-invoiceno = ls_head-invoiceno.
      gs_status-billingdocumentitem = ls_head-billingdocumentitem.
      gs_status-accountingdocument = ls_head-accountingdocument.
      gs_status-accountingdocumentitem = ls_head-accountingdocumentitem.

      gs_status-statuscode = finalstatus.
      gs_status-ackno = ackno.
      gs_status-createdby = lv_cbuser.
      gs_status-createdat = lv_time.


      APPEND gs_status TO gt_status.
      zbp_gst_invoice_uprv=>lt_status = gt_status.
**********************************************************************
      data(msg) = |Posting Success "Ack"{ ackno }|.
      APPEND VALUE #( %tky = ls_head-%tky
                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                text = msg ) )
                TO reported-header.
    ELSE.

      APPEND VALUE #( %tky = ls_head-%tky
                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                text = 'GST Not Posted ' ) )
                TO reported-header.
    ENDIF.

**********************************************************************

    result = VALUE #( FOR head IN lt_head
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zgst_invoice_uprv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zgst_invoice_uprv IMPLEMENTATION.

  METHOD save_modified.
    IF zbp_gst_invoice_uprv=>lt_status IS NOT INITIAL.
      MODIFY zgst_up_statusdb FROM TABLE @zbp_gst_invoice_uprv=>lt_status.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
