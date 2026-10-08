CLASS lhc_zpo_i_gst DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR zpo_i_gst RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zpo_i_gst RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zpo_i_gst RESULT result.

    METHODS pogst_post FOR MODIFY
       keys FOR ACTION zpo_i_gst~pogst_post RESULT result.

ENDCLASS.

CLASS lhc_zpo_i_gst IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD pogst_post.
* **********************************************************************
    DATA lv_json          TYPE string.
    DATA clientcd        TYPE string.
    DATA: clientgstin  TYPE string,
          mappingcd    TYPE string,
          templatecd   TYPE string,
          uploadtype   TYPE string,
          periodtype   TYPE string,
          invoicedate  TYPE string,
*          SModule       type string,
*          PModule       type string,
          invoicevalue TYPE string,
          taxablevalue TYPE string,
          taxrate      TYPE string,
          igstamt      TYPE string,
          cgstamt      TYPE string,
          sgstamt      TYPE string,
*          cessamt      TYPE string,
          invoicetype  TYPE string,
          self_gstin   TYPE string,
          supplytype   TYPE string.
**********************************************************************
    DATA: invoicevalue_n TYPE n LENGTH 13,
          taxablevalue_n TYPE n LENGTH 11,
          taxrate_n      TYPE n LENGTH 2,
          igstamt_n      TYPE n LENGTH 11,
          cgstamt_n      TYPE n LENGTH 11,
          sgstamt_n      TYPE n LENGTH 11.
*          cessamt_n      TYPE n LENGTH 11.

*    DATA lv_diffgstn    TYPE string.
    DATA ls_result TYPE string.
    DATA: gt_status TYPE TABLE OF zpo_gst_db,
          gs_status TYPE zpo_gst_db.
**********************************************************************

    READ ENTITIES OF zpo_i_gst IN LOCAL MODE
    ENTITY zpo_i_gst
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_head)
    FAILED DATA(lt_failed).

    DATA lv_batch_ackno TYPE string.
    CLEAR lv_batch_ackno.

    LOOP AT lt_head INTO DATA(ls_head).
      CLEAR: lv_json, clientcd, clientgstin, invoicedate, invoicevalue, taxablevalue,
             taxrate, igstamt, cgstamt, sgstamt, invoicetype, self_gstin, supplytype,
             ls_result.

      IF ls_head-documentdate IS NOT INITIAL.
        invoicedate = |{ ls_head-documentdate+6(2) }-{ ls_head-documentdate+4(2) }-{ ls_head-documentdate(4) }|.
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

      IF ls_head-cgsttype IS NOT INITIAL.
        taxrate_n = ( ls_head-cgstrate * 2 ).
*    taxrate = |{ taxrate_n ALPHA = OUT }|.
        taxrate = taxrate_n.
      ENDIF.

      IF ls_head-igsttype IS NOT INITIAL.
        taxrate_n = ls_head-igstrate.
*    taxrate = |{ taxrate_n ALPHA = OUT }|.
        taxrate = taxrate_n.
      ENDIF.

      igstamt_n = ls_head-igstamt.
      igstamt = |{ igstamt_n ALPHA = OUT }|.
      CONDENSE igstamt.

      cgstamt_n = ls_head-cgstamt.
      cgstamt = |{ cgstamt_n ALPHA = OUT }|.
      CONDENSE cgstamt.

      sgstamt_n = ls_head-sgstamt.
      sgstamt = |{ sgstamt_n ALPHA = OUT }|.
      CONDENSE sgstamt.

*        clientgstin = ls_head-selfgstin.
*        clientcd = ls_head-clientid.
      CASE ls_head-companycode.
        WHEN '1000'.
          clientgstin = '20AAMCS4941D1ZM'. clientcd = 'AAMCS4941D'. self_gstin = '20AAMCS4941D1ZM'.
        WHEN '2000'.
          clientgstin = '20AACCC3707F1ZE'. clientcd = 'AACCC3707F'. self_gstin = '20AACCC3707F1ZE'.
        WHEN '3000'.
          clientgstin = '20AACCN8200C1ZB'. clientcd = 'AACCN8200C'. self_gstin = '20AACCN8200C1ZB'.
        WHEN '4000'.
          clientgstin = '20AABCJ6505H2Z1'. clientcd = 'AABCJ6505H'. self_gstin = '20AABCJ6505H2Z1'.
      ENDCASE.

      IF ls_head-accountingdocument IS NOT INITIAL.

*//this direct value passing to JSON
        IF ls_head-transtype = 'B2B'.
          invoicetype = 'R'. supplytype = ''.
        ELSEIF ls_head-transtype = 'B2BUR'.
          invoicetype = ''. supplytype = 'INTRA'.
        ENDIF.
        CONDENSE invoicetype. CONDENSE supplytype.

        CONCATENATE
           '{' '"trans_type_code": "' ls_head-transtype '",'
           '"fp": "' ls_head-fiscalperiod '",'
           '"ack_sr_no": "1",'
           '"self_gstin": "' self_gstin '",'
           '"system_cd": "",' '"branch_cd": "",' '"vertical_cd": "",'
           '"result_flag": "' ls_head-resultflag '",'
           '"cp_gstin": "' ls_head-supgstin '",'
           '"cp_gstin_name": "' ls_head-bpsupplierfullname '",'
           '"invoice_type": "' invoicetype '",'
           '"invoice_no": "' ls_head-accountingdocument '",'
           '"invoice_dt": "' invoicedate '",'
           '"invoice_val": "' invoicevalue '",'
           '"taxable_val": "' taxablevalue '",'
           '"items_serial_no": "' ls_head-ledgergllineitem '",'
           '"rate_of_tax": "' taxrate '",'
           '"igst_amnt": "' igstamt '",'
           '"cgst_amnt": "' cgstamt '",'
           '"sgst_amnt": "' sgstamt '",'
           '"cess_amnt": "",' '"pos": "25",' '"rchrg": "N",'
           '"eligibility_of_itc": "no",' '"tot_tax_avlbl_itc_igst": "0",'
           '"tot_tax_avlbl_itc_cgst": "",' '"tot_tax_avlbl_itc_sgst": "",'
           '"total_tax_itc_cess": "0",' '"gstn_of_supplier": "",'
           '"orignal_invoice_no": "",' '"orignal_invoice_dt": "",'
           '"supply_type": "' supplytype '",'
           '"is_pur_frm_sez": "",' '"sez_gstin": "",' '"exp_suppliername": "",'
           '"port_code": "",' '"bill_entry_exprt_no": "",' '"bill_entry_exprt_dt": "",'
           '"bill_entry_exprt_val": "",' '"or_bill_entry_exprt_no": "",'
           '"or_bill_entry_exprt_dt": "",' '"dtls_imprt_srvc_no": "",'
           '"dtls_imprt_srvc_dt": "",' '"dtls_imprt_srvc_val": "",'
           '"dtls_imprt_srvc_txblval": "",' '"or_dtls_imprt_srvc_no": "",'
           '"or_dtls_imprt_srvc_dt": "",' '"type_of_note": "",'
           '"db_cr_issue_reason": "",' '"is_pre_gst_regime": "",'
           '"dbt_crdt_note_no": "",' '"dbt_crdt_note_dt": "",'
           '"dbt_crdt_note_val": "",' '"diff_value": "",'
           '"diff_igst_amnt": "",' '"diff_cgst_amnt": "",'
           '"diff_sgst_amnt": "",' '"diff_cess_amnt": "",'
           '"or_dbt_crdt_note_no": "",' '"or_dbt_crdt_note_dt": ""'
           '}'
           INTO lv_json.
*        *///

        IF clientgstin IS NOT INITIAL AND clientcd IS NOT INITIAL.


          mappingcd = 'MFHSPDTN0000004'.
          templatecd = 'PurchaseInvoiceData807'.
          uploadtype = 'json'.
*        pmodule = 'purchaseInvUpld'.   "salesInvUpld
*        smodule = 'salesInvUpld'.   "salesInvUpld
          periodtype = ls_head-fiscalperiod.

          TRY.
              FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                          comm_scenario = 'ZCOMM_POGST_INTE'
                                          service_id    = 'ZPOGST_INTE_REST' ).
              FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
              FINAL(lo_request) = lo_http_client->get_http_request( ).
              lo_request->set_content_type( content_type = |application/json| ).
              lo_request->set_header_field( i_name = 'ClientCode' i_value = clientcd ).
              lo_request->set_header_field( i_name = 'MappingCD'  i_value = mappingcd ).
              lo_request->set_header_field( i_name = 'TemplateCD' i_value = templatecd ).
              lo_request->set_header_field( i_name = 'GSTIN'      i_value = clientgstin ).
              lo_request->set_header_field( i_name = 'UpType'     i_value = uploadtype ).
              lo_request->set_header_field( i_name = 'Period'     i_value = periodtype ).
              lo_request->set_text( lv_json ).
              ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
              lo_http_client->close( ).
            CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
            CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
          ENDTRY.

        ENDIF.
      ENDIF.

*      DATA(finalstatus) = ''.
*      DATA(ackno) = ''.
*********************************************************
*            data(ls_result) = '{"Status":202,"ackNo":"25930232123"}'.

*      IF ls_result IS NOT INITIAL.
*        SPLIT ls_result AT '"Status":' INTO DATA(lv_text) DATA(lv_text1).
*        SPLIT lv_text1 AT ',"ac' INTO finalstatus DATA(lv_text2).
*        SPLIT ls_result AT '"ackNo":"' INTO DATA(lv_text3) DATA(lv_text4).
*        SPLIT lv_text4 AT '"}' INTO ackno DATA(lv_text5).
*        CONDENSE finalstatus.
*        CONDENSE ackno.
*      ENDIF.

      IF ls_result IS NOT INITIAL.

        DATA: finalstatus TYPE string,
              ackno       TYPE string.

        IF ls_result IS NOT INITIAL.

          TYPES: BEGIN OF ty_response,
                   status TYPE string,
                   ackno  TYPE string,
                 END OF ty_response.

          DATA ls_response TYPE ty_response.

          TRY.

              /ui2/cl_json=>deserialize(
                EXPORTING
                  json = ls_result
                CHANGING
                  data = ls_response
              ).

              finalstatus = ls_response-status.
              ackno       = ls_response-ackno.

              "First successful API ACK becomes the Batch ACK
              IF ackno IS NOT INITIAL
                 AND lv_batch_ackno IS INITIAL.

                lv_batch_ackno = ackno.

              ENDIF.

            CATCH cx_root INTO DATA(lx_error).

*              finalstatus = ''.
*              ackno       = ''.

              CLEAR finalstatus.
              CLEAR ackno.

          ENDTRY.

        ENDIF.

      ENDIF.

*********************************************************
*      IF ackno IS NOT INITIAL.
      IF lv_batch_ackno IS NOT INITIAL.
        GET TIME STAMP FIELD DATA(ts).
        CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
        TRY.
            DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.
        DATA(lv_cbuser) = 'CB' && lv_user.
        SELECT SINGLE userid, personfullname FROM i_businessuserbasic WITH PRIVILEGED ACCESS
          WHERE userid = @lv_cbuser
          INTO @DATA(name).

**********************************************************************
        CLEAR gs_status.
        gs_status-fiscalyear = ls_head-fiscalyear.
        gs_status-companycode = ls_head-companycode.
        gs_status-accountingdocument = ls_head-accountingdocument.
        gs_status-sourceledger = ls_head-sourceledger.
        gs_status-ledgergllineitem = ls_head-ledgergllineitem.
        gs_status-statuscode = finalstatus.
**        gs_status-ackno = ackno.

        gs_status-ackno = lv_batch_ackno.
        gs_status-createdby = lv_cbuser.
        gs_status-createdat = lv_time.
        gs_status-createdname = name-personfullname.
        APPEND gs_status TO gt_status.

**********************************************************************
*        DATA(msg) = |Posting Success "Ack"{ ackno }|.
        DATA(msg) = |Posting Success "Ack" { lv_batch_ackno }|.
        APPEND VALUE #( %tky = ls_head-%tky
                  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                  text = msg ) )
                  TO reported-zpo_i_gst.
      ELSE.
        APPEND VALUE #( %tky = ls_head-%tky
                  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                  text = 'GST Not Posted' ) )
                  TO reported-zpo_i_gst.
      ENDIF.

    ENDLOOP.

    zbp_po_i_gst=>lt_status = gt_status.

    result = VALUE #( FOR head IN lt_head
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zpo_i_gst DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zpo_i_gst IMPLEMENTATION.

  METHOD save_modified.
    IF zbp_po_i_gst=>lt_status IS NOT INITIAL.
      MODIFY zpo_gst_db FROM TABLE @zbp_po_i_gst=>lt_status.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
