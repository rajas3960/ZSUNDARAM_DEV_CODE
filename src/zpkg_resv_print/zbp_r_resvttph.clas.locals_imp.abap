CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS appr FOR MODIFY
      IMPORTING keys FOR ACTION head~appr RESULT result.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.

    FINAL(lv_key) = VALUE #( keys[ 1 ] OPTIONAL ).
    IF lv_key IS INITIAL.
      RETURN.
    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    SELECT SINGLE * FROM zmm_tt_resv_appr WHERE resvno = @lv_key-reservation INTO @FINAL(ls_re).
    IF sy-subrc IS INITIAL AND ls_re-approved IS NOT INITIAL.
      FINAL(lv_subrc) = 'X'.
    ENDIF.

*    APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<lfs_result>).
*    <lfs_result>-%tky = lv_key-%key.
*    <lfs_result>-%action-appr = COND #( WHEN lv_subrc = 'X'
*                                        THEN if_abap_behv=>fc-o-enabled
*                                        ELSE if_abap_behv=>fc-o-disabled ).
*



  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD appr.

    READ ENTITIES OF zr_resvttph IN LOCAL MODE
          ENTITY head
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED DATA(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      <lfs_head>-tprint = 'X'.
*      MODIFY ENTITIES OF zr_resvttph IN LOCAL MODE
*             ENTITY head
*             UPDATE
*             FIELDS ( tprint )
*             WITH VALUE #( ( %tky   = <lfs_head>-%tky
*                             tprint = <lfs_head>-tprint ) ).
    ENDLOOP.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
    SELECT SINGLE * FROM zdt_printqueue
      WHERE cbuser                 = @sy-uname
       " AND configdeprecationcode IS INITIAL
      INTO @DATA(ls_queue).


    IF sy-subrc IS NOT INITIAL.

      "ls_queue-printque = 'ADOBE_DEFAULT'.
      ls_queue-printque = 'DEFAULT'.
    ENDIF.

    " TRY.
    " Initialize Template Store Client
    DATA(lo_store) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_CS_ADOBE'
                                                    iv_service_instance_name = 'YY1_ADS_CF_REST' ).
    DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSERV_RESVPRNT'
                                                          iv_root_node          = 'ZI_RES_HEADPRINT' ).

    TRY.
        lo_store->get_schema_by_name( iv_form_name = 'RESERVATIONFORM' ).
        "   out->write( 'Schema found in form' ).
      CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
        "  out->write( 'No schema in form found' ).
        IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403.
          " Upload service definition
          lo_store->set_schema( iv_form_name = 'RESERVATIONFORM'
                                is_data      = VALUE #( note        = ''
                                                        schema_name = 'schema'
                                                        xsd_schema  = lo_fdp_util->get_xsd( ) ) ).
        ELSE.
*              "   out->write( lo_tmpl_error->get_longtext( ) ).
        ENDIF.
    ENDTRY.
    TYPES: BEGIN OF ty_schema_body,
             xsd_schema  TYPE xstring,
             schema_name TYPE c LENGTH 30,
             note        TYPE c LENGTH 280,
           END OF ty_schema_body.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_xdp TYPE ty_schema_body.
    lv_xdp = VALUE #( note        = ''
                      schema_name = 'schema'
                      xsd_schema  = lo_fdp_util->get_xsd( ) ).
    " Get initial select keys for service
    DATA(lt_keys) = lo_fdp_util->get_keys( ).
    lt_keys[ name = 'RESERVATION' ]-value = <lfs_head>-reservation.

    TRY.
        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
        " out->write( 'Service data retrieved' ).
      CATCH cx_fp_fdp_error INTO DATA(lo_exception). " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

    DATA(ls_template) = lo_store->get_template_by_name( iv_get_binary    = abap_true
                                                        iv_form_name     = 'RESERVATIONFORM'
                                                        iv_template_name = 'RESERVATIONFORM' ).
    " out->write( 'Form Template retrieved' ).

    cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                          iv_xml_data     = lv_xml
                                          iv_xdp_layout   = ls_template-xdp_template
                                          is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                IMPORTING
                                " TODO: variable is assigned but never used (ABAP cleaner)
                                          ev_trace_string = DATA(lv_trace)
                                          ev_pdf          = DATA(lv_pdf) ).
    " out->write( 'Output was generated' ).

    DATA lv_doc_name TYPE char120.
    lv_doc_name = |Reservation :{ <lfs_head>-reservation }|.

    SELECT SINGLE * FROM zreservation_h
      WHERE reservation = @<lfs_head>-reservation
      INTO @DATA(ls_res).
    IF sy-subrc IS INITIAL.
      ls_res-attachment = lv_pdf.
      ls_res-mimetype   = 'application/pdf'.
      ls_res-filename   = lv_doc_name.
      MODIFY zreservation_h FROM @ls_res.
      else.
      ls_res-attachment = lv_pdf.
      ls_res-mimetype   = 'application/pdf'.
      ls_res-filename   = lv_doc_name.
      ls_res-reservation = <lfs_head>-Reservation.
      MODIFY zreservation_h FROM @ls_res.
    ENDIF.

*        cl_print_queue_utils=>create_queue_item_by_data(
*            iv_qname            = CONV zde_pqname( ls_queue-printque ) "'YYRESV'
*            iv_print_data       = lv_pdf
*            iv_name_of_main_doc = lv_doc_name
*            iv_itemid           = cl_print_queue_utils=>create_queue_itemid( ) ).
*        " out->write( 'Output was sent to print queue' ).

    " CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
    " out->write( 'Exception occurred.' ).
    "ENDTRY.
    " out->write( 'Finished processing.' ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    READ ENTITIES OF zr_resvttph IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_resvttph DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_resvttph IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
