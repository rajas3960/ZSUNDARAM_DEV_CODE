CLASS lhc_zi_taxinvhdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_taxinvhdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_taxinvhdr RESULT result.

    METHODS tprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvhdr~tprint RESULT result.

ENDCLASS.

CLASS lhc_zi_taxinvhdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD tprint.

    READ ENTITIES OF zi_taxinvhdr IN LOCAL MODE
     ENTITY zi_taxinvhdr
     ALL FIELDS
     WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      <lfs_head>-tprint = 'X'.
      MODIFY ENTITIES OF zi_taxinvhdr IN LOCAL MODE
        ENTITY zi_taxinvhdr
        UPDATE
        FIELDS  ( tprint )
        WITH VALUE #(
                       ( %tky   = <lfs_head>-%tky
                         tprint = <lfs_head>-tprint
                       ) ).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvhdr IN LOCAL MODE
         ENTITY zi_taxinvhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_taxinvhdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_taxinvhdr IMPLEMENTATION.

  METHOD save_modified.
    IF update-zi_taxinvhdr IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lt_head) = update-zi_taxinvhdr.

    TRY.
        " Initialize Template Store Client
        DATA(lo_store) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_CS_ADOBE'
                                                        iv_service_instance_name = 'YY1_ADS_CF_REST' ).
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_TAXINVPRINT'
                                                              iv_root_node          = 'ZI_TAXINVHDR_PRINT' ).

        TRY.
            lo_store->get_schema_by_name( iv_form_name = 'INVOICEFORM' ).
            "   out->write( 'Schema found in form' ).
          CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
            "  out->write( 'No schema in form found' ).
            IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403.
              " Upload service definition
*              lo_store->set_schema( iv_form_name = 'INVOICEFORM'
*                                    is_data      = VALUE #( note        = ''
*                                                            schema_name = 'schema'
*                                                            xsd_schema  = lo_fdp_util->get_xsd( ) ) ).
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
        lt_keys[ name = 'SERIALINVOICENO' ]-value = lt_head[ 1 ]-serialinvoiceno.

        TRY.
            DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
            " out->write( 'Service data retrieved' ).
          CATCH cx_fp_fdp_error INTO DATA(lo_exception). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

        DATA(ls_template) = lo_store->get_template_by_name( iv_get_binary    = abap_true
                                                            iv_form_name     = 'INVOICEFORM'
                                                            iv_template_name = 'YY1_TAX_INVOICE' ).
        " out->write( 'Form Template retrieved' ).

        cl_fp_ads_util=>render_4_pq( EXPORTING iv_locale       = 'en_US'
                                               iv_pq_name      = 'YYINVOICE' "CONV zde_pqname( ls_queue-printque )" "'YYRFQ' "'PRINT_QUEUE'
                                               iv_xml_data     = lv_xml
                                               iv_xdp_layout   = ls_template-xdp_template
                                               is_options      = VALUE #( trace_level = 0 ) " Use 0 in production environment
                                     IMPORTING
                                     " TODO: variable is assigned but never used (ABAP cleaner)
                                               ev_trace_string = DATA(lv_trace)
                                               ev_pdl          = DATA(lv_pdf) ).
        " out->write( 'Output was generated' ).
        DATA lv_json TYPE string.
        DATA lv_str  TYPE string.
        DATA lv_val  TYPE string.
        DATA lv_ext  TYPE string.
        DATA lv_gid  TYPE string.

        lv_json = '{'.
        lv_json = |{ lv_json }"credentialAlias": "ServerSignature" ,|.
        lv_json = |{ lv_json }"signatureFieldName":"signature",|.
        lv_json = |{ lv_json }"reasonInfo":"approval",|.
        lv_json = |{ lv_json }"locationInfo": 'India' ,|.
        lv_json = |{ lv_json }"contactInfo"::"rajesh.kansara@rubberkingtyres.com",|.
        lv_json = |{ lv_json }"pdf"::"{ lv_pdf }"|.
        lv_json =  lv_json &&  | | &&  '}'.

        TRY.
            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                        comm_scenario = 'ZCS_SIGN'
                                        service_id    = 'ZOUTB_SIGN_REST' ).
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            DATA(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).
            lo_request->set_text( lv_json ).
            DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

        DATA lv_doc_name TYPE char120.
        lv_doc_name = |Invoice :{ lt_head[ 1 ]-serialinvoiceno }|.

        cl_print_queue_utils=>create_queue_item_by_data(
            iv_qname            = 'YYINVOICE' "CONV zde_pqname( ls_queue-printque )" "'YYRFQ'
            iv_print_data       = lv_pdf
            iv_name_of_main_doc = lv_doc_name
            iv_itemid           = cl_print_queue_utils=>create_queue_itemid( ) ).
        " out->write( 'Output was sent to print queue' ).

      CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        " out->write( 'Exception occurred.' ).
    ENDTRY.
    " out->write( 'Finished processing.' ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
