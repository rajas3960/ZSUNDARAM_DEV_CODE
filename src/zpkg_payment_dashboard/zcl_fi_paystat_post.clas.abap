CLASS zcl_fi_paystat_post DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PAYSTAT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Pay Status data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PAYSTAT_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PAYSTAT_ALOGS_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

    METHODS constructor.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_FI_PAYSTAT_POST IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    TRY.
        application_log = cl_bali_log=>create_with_header(
                               header = cl_bali_header_setter=>create( object = 'ZAPP_PAYSTAT_01_LOG'
                                                                       subobject = 'ZAPP_PAYSTAT_01_SUB'
                                                                       external_id = 'PAYSTAT' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA lv_utr TYPE string.
    DATA:ls_head TYPE zdt_payment_head.
    TYPES: BEGIN OF ty_type,
             login_id       TYPE string,
             input_gcif     TYPE string,
             cbx_api_ref_no TYPE string,
             txndate        TYPE string,
           END OF ty_type.
    DATA: ls_paystat TYPE ty_type.
    DATA: lv_json_post TYPE string VALUE ''.
    TYPES: BEGIN OF ty_data_reject,
             input_user_no        TYPE string,
             lei_expiry_date      TYPE  string,
             od_txn_type          TYPE  string,
             od_bsn_prod          TYPE  string,
             initiatedate_time    TYPE  string,
             paymentrefno         TYPE  string,
             txn_status           TYPE  string,
             od_txn_ccy           TYPE  string,
             od_status_desc       TYPE  string,
             bene_narration       TYPE  string,
             lei_code             TYPE  string,
             od_acc_no            TYPE  string,
             od_maker_date        TYPE  string,
             od_gcif              TYPE  string,
             txn_ref_num          TYPE  string,
             status               TYPE  string,
             origin               TYPE  string,
             od_reject_reason     TYPE  string,
             od_channel_desc      TYPE  string,
             ifsc_code            TYPE  string,
             product              TYPE  string,
             od_bsn_code          TYPE  string,
             od_maker_id          TYPE  string,
             auth_allowed         TYPE  string,
             remark               TYPE  string,
             od_status            TYPE  string,
             parent_ref_no        TYPE  string,
             check_same_bene_flag TYPE  string,
             debit_acc_no         TYPE  string,
             sub_product          TYPE  string,
             od_lcy_amount        TYPE  string,
             bene_name            TYPE  string,
             od_amount            TYPE  string,
             od_value_date        TYPE  string,
             entitled             TYPE  string,
             transfer_type_desc   TYPE string,
             bene_acc_no          TYPE  string,
             action               TYPE  string,
             total_count          TYPE  string,
             od_maker_name        TYPE  string,
             transfer_type        TYPE  string,
             input_ver_no         TYPE  string,
             hold_remark_ind      TYPE  string,
             reference_no         TYPE  string,
             input_host_code      TYPE  string,
           END OF ty_data_reject.
    TYPES: BEGIN OF ty_data_success,
             host_file_ind       TYPE string,
             od_auth_date        TYPE string,
             input_user_no       TYPE string,
             initiatedate_time   TYPE string,
             paymentrefno        TYPE string,
             txn_status          TYPE string,
             credit_acc_no       TYPE string,
             business_prod_desc  TYPE string,
             txn_reference_no    TYPE string,
             lei_code            TYPE string,
             od_acc_no           TYPE string,
             origin              TYPE string,
             od_gcif             TYPE string,
             od_reject_reason    TYPE string,
             ifsc_code           TYPE string,
             nodal_approval      TYPE string,
             product             TYPE string,
             od_maker_id         TYPE string,
             handoff_code        TYPE string,
             org_pay_prod        TYPE string,
             currency            TYPE string,
             od_status           TYPE string,
             debit_acc_no        TYPE string,
             sub_product         TYPE string,
             od_auth_name        TYPE string,
             business_product_id TYPE string,
             od_amount           TYPE string,
             bene_name           TYPE string,
             maker_date          TYPE string,
             value_date          TYPE string,
             bene_nm_frm_host    TYPE string,
             batchrefno          TYPE string,
             transfer_type_desc  TYPE string,
             action              TYPE string,
             total_count         TYPE string,
             od_maker_name       TYPE string,
             transfer_type       TYPE string,
             input_ver_no        TYPE string,
             reference_no        TYPE string,
             utr_no              TYPE string,
           END OF ty_data_success.
    TYPES: BEGIN OF ty_errors,
             code       TYPE char10,
             field      TYPE char20,
             message    TYPE char255,
             resourceId TYPE char40,
           END OF ty_errors.

    DATA: ls_data TYPE ty_data_reject.
    DATA: ls_data_success TYPE ty_data_success.
    DATA: ls_errors   TYPE ty_errors,
          l_errors    TYPE flag,
          l_donothing TYPE flag.
    DATA: lt_log TYPE STANDARD TABLE OF zdt_appr_log.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA l_timestamp TYPE timestamp.

IF sy-sysid = 'AYR'.
    SELECT * FROM zdt_payment_head WHERE status = 'Sent to Bank'
    INTO TABLE @DATA(lt_head).
ELSE.
    SELECT * FROM zdt_payment_head WHERE status = 'Sent to Bank' or status = 'Failed'
    INTO TABLE @lt_head.
ENDIF.
    LOOP AT lt_head INTO DATA(l_head).
      IF l_head-appr1 = 'X'." AND l_head-appr2 = 'X' AND l_head-appr3 = 'X'.
        " get status from bank
        IF sy-sysid = 'PZJ'.
          ls_paystat-input_gcif = 'CBXMGRT4'.
          ls_paystat-login_id = 'APIUSER@CBXMGRT4'.
        ELSEIF sy-sysid = 'A1S'.
          ls_paystat-input_gcif = 'CBXMGRT4'.
          ls_paystat-login_id = 'APIUSER@CBXMGRT4'.
        ELSEIF sy-sysid = 'AYR'.
          ls_paystat-input_gcif = 'DHUNSERIPCX'.
          ls_paystat-login_id = 'APIUSER'.
        ENDIF.

        ls_paystat-cbx_api_ref_no = l_head-accountingdoc && l_head-fiscalyear && l_head-companycode.
        ls_paystat-txndate = l_head-senton+0(4) && '-' && l_head-senton+4(2) && '-' && l_head-senton+6(2).

        /ui2/cl_json=>serialize( EXPORTING data = ls_paystat RECEIVING r_json = lv_json_post ).
        TRY.
            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_PAYSTATUS'
                                                                                             service_id    = 'ZFI_PAYSTATUS_REST' ).
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            DATA(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).
            lo_request->set_text( lv_json_post ).
            DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close(  ).
            CLEAR lv_json_post.

          CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
          CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
        ENDTRY.
*
        IF ls_result CS 'valErrors'.

          SPLIT ls_result AT '[' INTO DATA(lv_e1) DATA(lv_e2).
          SPLIT lv_e2 AT ']' INTO DATA(lv_e3) DATA(lv_e4).

          /ui2/cl_json=>deserialize( EXPORTING json = lv_e3 CHANGING data = ls_errors ).
          l_errors = 'X'.
          "  ELSE. "Might be rejected,Processed,Payload = Parse into a structure and handle that
        ELSEIF ls_result CS '"TXN_STATUS":"TXCOMP"' OR
               ls_result CS '"TXN_STATUS":"3"' OR
               ls_result CS '"TXN_STATUS":"TXDSETT"' OR
               ls_result CS '"TXN_STATUS":"Processed"' OR
               ( ls_result CS '"TXN_STATUS":"Completed"' AND sy-sysid <> 'AYR' ) OR
               ( ls_result CS '"TXN_STATUS":"Inquiry Initiated"' AND sy-sysid <> 'AYR' ).

          SPLIT ls_result AT '[' INTO DATA(lv_s1) DATA(lv_s2).
          SPLIT lv_s2 AT ']' INTO DATA(lv_s3) DATA(lv_s4).

          /ui2/cl_json=>deserialize( EXPORTING json = lv_S3 CHANGING data = ls_data_success ).

          IF ls_data_success-txn_status = 'TXCOMP' OR ls_data_success-txn_status = '3' OR ls_data_success-txn_status = 'TXDSETT'
             OR ls_data_success-txn_status = 'Processed'
             OR ( ls_data_success-txn_status = 'Completed' AND sy-sysid <> 'AYR' )
             OR ( ls_data_success-txn_status = 'Inquiry Initiated' AND sy-sysid <> 'AYR' ).
            IF l_head-payeebankkey CS 'HDFC'.
              lv_utr = ls_data_success-txn_reference_no.
            ELSE.
              lv_utr = ls_data_success-utr_no.
            ENDIF.
            DATA(lv_status1) =  ls_data_success-txn_status.
          ENDIF.

        ELSE.
          SPLIT ls_result AT '[' INTO DATA(lv1) DATA(lv2).
          SPLIT lv2 AT ']' INTO DATA(lv3) DATA(lv4).

          /ui2/cl_json=>deserialize( EXPORTING json = lv3 CHANGING data = ls_data ).

          IF ls_data-txn_status = '0' OR ls_data-txn_status = 'RV' OR ls_data-txn_status = 'RR' OR ls_data-txn_status = 'PR' OR
             ls_data-txn_status = 'DR' OR ls_data-txn_status = 'AO' OR ls_data-txn_status = 'RA' OR ls_data-txn_status = 'LK' OR
             ls_data-txn_status = 'TXPDAUTH' OR ls_data-txn_status = 'TXPARK' OR ls_data-txn_status = 'TXNVIP' OR
             ls_data-txn_status = 'TXDRHD' OR ls_data-txn_status = 'TXDBPR' OR ls_data-txn_status = 'TXBVSU' OR
             ls_data-txn_status = 'TXBVSP' OR ls_data-txn_status = 'TXAWRB' OR ls_data-txn_status = 'TXAUTH' OR
             ls_data-txn_status = 'TXAICN' OR ls_data-txn_status = 'TXAGWT' OR ls_data-txn_status = 'TRBLWT' OR
             ls_data-txn_status = 'TLCWT' OR ls_data-txn_status = 'PRTXINPR' OR ls_data-txn_status = 'NDF' OR
             ls_data-txn_status = 'UNKNOWN' OR  ls_data-txn_status = 'CI' OR  ls_data-txn_status = 'IO' OR ls_data-txn_status = 'LK' OR
             ls_data-txn_status = 'TXWRHD' OR ls_data-txn_status = '70008' OR ls_data-txn_status = '70009' OR
             ls_data-txn_status = 'ENTL_ERR' OR ls_data-txn_status = 'U' OR  ls_data-txn_status = 'TXSIP' OR
             ls_data-txn_status = 'TXSETT' OR  ls_data-txn_status = 'TXPDST' OR ls_data-txn_status = 'TXTRHOLD' OR ls_data-txn_status = 'N'.
            " lv_utr = ls_data-reference_no.
            DATA(lv_status) =  ls_data-od_status_desc.
            l_donothing = 'X'.
          ELSE.
            l_errors = 'X'.
          ENDIF.

        ENDIF.

        l_timestamp = sy-datum && sy-uzeit.
        CONVERT TIME STAMP l_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

        IF lv_status IS NOT INITIAL AND l_donothing = 'X'.
          SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel
          FROM zdt_appr_log AS a
          WHERE a~accountingdoc = @l_head-accountingdoc AND a~fiscalyear = @l_head-fiscalyear AND companycode = @l_head-companycode
          INTO TABLE @DATA(lt_apprlog).
          SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
          DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
          IF lt_apprlog[] IS NOT INITIAL.
            lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                                                        companycode   = wa1-companycode   apprlevel  = ( wa1-apprlevel + 1 )
                                                        supplier      = wa1-supplier      actionedby = sy-uname actionedon = lv_date
                                                        actionedat    = lv_time           action     = 'Status Upd'
                                                        apprcomment   = lv_status ) ).

            IF lt_log[] IS NOT INITIAL.
              MODIFY zdt_appr_log FROM TABLE @lt_log.
              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSEIF l_errors = 'X'.
          SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel
          FROM zdt_appr_log AS a
          WHERE a~accountingdoc = @l_head-accountingdoc AND a~fiscalyear = @l_head-fiscalyear AND companycode = @l_head-companycode
          INTO TABLE @lt_apprlog.
          SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
          DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
          IF lt_apprlog[] IS NOT INITIAL.
            lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                          companycode = wa1-companycode apprlevel = ( wa1-apprlevel + 1 )
                          supplier = wa1-supplier actionedby = sy-uname actionedon = lv_date
                          actionedat = lv_time action = 'Status Upd'
                          apprcomment = COND #( WHEN ls_errors IS NOT INITIAL THEN ls_errors-message ELSE lv_status ) ) ).
          ENDIF.

          IF lt_log[] IS NOT INITIAL.
            MODIFY zdt_appr_log FROM TABLE @lt_log.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.

          UPDATE zdt_payment_head SET message = @ls_errors-message,status = 'Failed' WHERE accountingdoc = @l_head-accountingdoc
          AND fiscalyear = @l_head-fiscalyear AND companycode = @l_head-companycode.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.
        ELSEIF lv_utr IS NOT INITIAL.
          "accepted UTR NO received
          DATA : lv_assingment TYPE char18.
          DATA(lv_len1) = strlen( lv_utr ).
*          IF lv_len1 <= 18.
*            lv_assingment = lv_utr.
*          ELSE.
*            lv_len1 = lv_len1 - 19 .
*            lv_assingment = lv_utr+lv_len1(18).
*          ENDIF.

          IF lv_len1 GE 16.
           lv_assingment = lv_utr+3(13).
          ENDIF.

          SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel
          FROM zdt_appr_log AS a
          WHERE a~accountingdoc = @l_head-accountingdoc AND a~fiscalyear = @l_head-fiscalyear AND companycode = @l_head-companycode
          INTO TABLE @lt_apprlog.
          SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
          DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
          IF lt_apprlog[] IS NOT INITIAL.
            lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                                                        companycode   = wa1-companycode   apprlevel  = ( wa1-apprlevel + 1 )
                                                        supplier      = wa1-supplier      actionedby = sy-uname actionedon = lv_date
                                                        actionedat    = lv_time           action     = 'Status Upd'
                                                        apprcomment   = lv_utr ) ).
          ENDIF.

          IF lt_log[] IS NOT INITIAL.
            MODIFY zdt_appr_log FROM TABLE @lt_log.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.

          UPDATE zdt_payment_head SET utr = @lv_utr,status = 'UTR Generated' WHERE accountingdoc = @l_head-accountingdoc
          AND fiscalyear = @l_head-fiscalyear AND companycode = @l_head-companycode.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.

          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " acc doc entry Assignement refernce  DocumentItemText update
          DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
                lv_cid TYPE abp_behv_cid.

          APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).
* GL Item Control
          DATA lt_glitem LIKE <je>-%param-_glitems.
          DATA ls_glitem LIKE LINE OF lt_glitem.
          DATA ls_glitem_control LIKE ls_glitem-%control.
          ls_glitem_control-glaccountlineitem = if_abap_behv=>mk-on.
          ls_glitem_control-documentitemtext = if_abap_behv=>mk-on.
          ls_glitem_control-assignmentreference = if_abap_behv=>mk-on.

          SELECT SINGLE ReferenceDocumentItem
          FROM I_JournalEntryItem
          WHERE CompanyCode = @l_head-companycode AND FiscalYear = @l_head-fiscalyear AND AccountingDocument = @l_head-accountingdoc AND
          Ledger = '0L' AND Supplier IS INITIAL AND HouseBank IS NOT INITIAL
          INTO @DATA(ls_gl_item) .

*    "CHANGE BO
          <je>-companycode = l_head-companycode.
          <je>-fiscalyear  = l_head-fiscalyear.
          <je>-accountingdocument = l_head-accountingdoc.
          <je>-%param = VALUE #(
          _glitems = VALUE #( ( glaccountlineitem   = ls_gl_item
                                documentitemtext    = lv_utr
                                assignmentreference = lv_assingment
                                %control            = ls_glitem_control ) ) ).

          MODIFY ENTITIES OF i_journalentrytp
           ENTITY journalentry
           EXECUTE change FROM lt_je
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep)
           MAPPED DATA(ls_mapped_deep).
          IF ls_failed_deep IS NOT INITIAL.
            ROLLBACK ENTITIES.
          ELSE.
            COMMIT ENTITIES BEGIN
                   RESPONSE OF i_journalentrytp
                     " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED DATA(lt_commit_failed)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   REPORTED DATA(lt_commit_reported).
            COMMIT ENTITIES END.
          ENDIF.
          CLEAR: lt_je[].
        ENDIF.
      ENDIF.
      CLEAR: l_errors,l_donothing,ls_errors.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
