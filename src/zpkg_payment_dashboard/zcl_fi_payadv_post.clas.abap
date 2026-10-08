CLASS zcl_fi_payadv_post DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PAYADV'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Pay Status data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PAYADV_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PAYADV_ALOGS_01'.

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



CLASS ZCL_FI_PAYADV_POST IMPLEMENTATION.


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
                               header = cl_bali_header_setter=>create( object = 'ZAPP_PAYADV_01_LOG'
                                                                       subobject = 'ZAPP_PAYADV_01_SUB'
                                                                       external_id = 'PAYADV' ) ).
      CATCH cx_bali_runtime.
        "handle exception
        DATA(lv_error) = 'X'.
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA: l_mail      TYPE cl_bcs_mail_message=>ty_address,
          lt_notiflog TYPE TABLE OF zdt_pay_notif.

    SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,z~type
    FROM zdt_payment_head AS a
    LEFT OUTER JOIN zdt_pay_notif AS z
    ON ( z~accountingdoc = a~accountingdoc AND z~fiscalyear = a~FiscalYear
         AND z~companycode = a~CompanyCode AND z~type = 'M')
    "WHERE a~status = 'UTR Generated' "++ AK 19/08/2025
    INTO TABLE @DATA(lt_head).
    IF sy-subrc EQ 0.
      DELETE lt_head WHERE type = 'M'.
    ENDIF.

    LOOP AT lt_head INTO DATA(ls_head).
      TRY.
          " Initialize Template Store Client
          DATA(lo_store) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'ZCS_ADOBE'
                                                          iv_service_instance_name = 'ZCS_ADOBE' ).

          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSB_PAYADV'
                                                                iv_root_node          = 'ZC_PAYADV_HEAD' ). "'ZSD_PAYADV' "FDP_FFO_PAYM_ADVICE_SRV

          TRY.
              lo_store->get_schema_by_name( iv_form_name = 'PAYADV' ).
              "   out->write( 'Schema found in form' ).
            CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
              "  out->write( 'No schema in form found' ).
              IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403.
                " Upload service definition
                lo_store->set_schema( iv_form_name = 'PAYADV'
                                      is_data      = VALUE #( note        = ''
                                                              schema_name = 'schema'
                                                              xsd_schema  = lo_fdp_util->get_xsd( ) ) ).
              ELSE.
                "   out->write( lo_tmpl_error->get_longtext( ) ).
              ENDIF.
          ENDTRY.
          " Get initial select keys for service
          DATA(lt_keys) = lo_fdp_util->get_keys( ).
          lt_keys[ name = 'ACCOUNTINGDOC' ]-value = ls_head-accountingdoc. "ls_head-AccountingDoc.
          lt_keys[ name = 'FISCALYEAR' ]-value = ls_head-fiscalyear. "ls_head-fiscalyear
          lt_keys[ name = 'COMPANYCODE' ]-value = ls_head-companycode."ls_head-Companycode.

         "SOC BY AK 14/04/2025
         "lt_keys[ name = 'ACCOUNTINGDOC' ]-value = '2000000014'.
         "lt_keys[ name = 'FISCALYEAR' ]-value = '2025'.
         "lt_keys[ name = 'COMPANYCODE' ]-value = '2000'.
         "EOC BY AK 14/04/2025

          TRY.
              DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              " out->write( 'Service data retrieved' ).
            CATCH cx_fp_fdp_error INTO DATA(lo_exception). " TODO: variable is assigned but never used (ABAP cleaner)
          ENDTRY.

          DATA(ls_template) = lo_store->get_template_by_name( iv_get_binary    = abap_true
                                                              iv_form_name     = 'PAYADV'
                                                              iv_template_name = 'Payment_Advice' ).
          " out->write( 'Form Template retrieved' ).



          cl_fp_ads_util=>render_pdf( EXPORTING iv_locale     = 'en_US'
                                               "iv_pq_name      = 'PSLITTER' "'PRINT_QUEUE'
                                                iv_xml_data   = lv_xml
                                                iv_xdp_layout = ls_template-xdp_template
                                                is_options    = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                      IMPORTING ev_pdf        = DATA(lv_pdf00) ).
          " out->write( 'Output was sent to print queue' ).
          TRY.
              DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
              lo_mail->set_sender( 'no-reply@aspetindia.com' ).
              SELECT SINGLE EmailAddress FROM I_BusPartEmailAddressTP_3 WHERE BusinessPartner = @ls_head-supplier INTO @DATA(l_email).
              IF sy-subrc EQ 0.
                l_mail = l_email.
                lo_mail->add_recipient( l_mail ).
                "SOC BY AK 14/04/4045
                 "lo_mail->add_recipient( 'akanksha.karn@pwc.com' ).
                "EOC BY AK 14/04/2025

                " TODO: variable is assigned but never used (ABAP cleaner)
*              SELECT SINGLE * FROM I_CompanyCode WHERE CompanyCode = @ls_email-CompanyCode INTO @DATA(ls_comp).
                lo_mail->set_subject( 'Payment Advice' ).
                lo_mail->set_main(
                    cl_bcs_mail_textpart=>create_instance(
                        iv_content      = '<p>Dear Sir / Madam,</p><p></p><p>Please find attached the advice for payment made to you.</p><p></p><p>Thanking you,</p><p></p><p>Dhunseri Poly Films Pvt. Ltd.</p>'
                        iv_content_type = 'text/html' ) ).

                lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
                                             iv_content      = lv_pdf00
                                             iv_content_type = 'application/pdf'
                                             iv_filename     = 'Payment_Advice.pdf' ) ).

                " TODO: variable is assigned but never used (ABAP cleaner)
                lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
                COMMIT WORK.

                APPEND VALUE #( accountingdoc = ls_head-accountingdoc fiscalyear = ls_head-fiscalyear companycode = ls_head-companycode
                                type          = 'M'                   senton     = sy-datum           sentat      = sy-uzeit sentby = sy-uname ) TO lt_notiflog.
                MODIFY zdt_pay_notif FROM TABLE @lt_notiflog[].
                IF sy-subrc EQ 0.
                  COMMIT WORK AND WAIT.
                ENDIF.
                " TODO: variable is assigned but never used (ABAP cleaner)
                CLEAR: lt_notiflog[].
              ENDIF.
            CATCH cx_bcs_mail INTO DATA(lx_mail). " TODO: variable is assigned but never used (ABAP cleaner)
              " handle exceptions here
          ENDTRY.
        CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
          " out->write( 'Exception occurred.' ).
      ENDTRY.
*    ENDLOOP.
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
        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
