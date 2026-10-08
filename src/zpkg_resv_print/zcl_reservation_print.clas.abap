CLASS zcl_reservation_print DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RESERVATION_PRINT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        "Initialize Template Store Client
        DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
          iv_name = 'ZCS_ADOBE'
          iv_service_instance_name = 'ZCS_ADOBE'
        ).
        out->write( 'Template Store Client initialized' ).
        "Initialize class with service definition
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSERV_RESVPRNT' ).

        out->write( 'Dataservice initialized' ).

        TRY.
            lo_store->get_schema_by_name( iv_form_name = 'RESERVATIONFORM' ).
            out->write( 'Schema found in form' ).
          CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
            out->write( 'No schema in form found' ).
            IF lo_tmpl_error->mv_http_status_code = 404.
              "Upload service definition
              lo_store->set_schema(
                iv_form_name = 'RESERVATIONFORM'
                is_data = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd(  )  )
              ).
            ELSE.
              out->write( lo_tmpl_error->get_longtext(  ) ).
            ENDIF.
        ENDTRY.
        "Get initial select keys for service
        DATA(lt_keys)     = lo_fdp_util->get_keys( ).
        lt_keys[ name = 'RESERVATION' ]-value = '0000000615'.


        TRY.
            DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
            out->write( 'Service data retrieved' ).
          CATCH cx_fp_fdp_error INTO DATA(lo_exception).
        ENDTRY..

        DATA(ls_template) = lo_store->get_template_by_name(
          iv_get_binary     = abap_true
          iv_form_name      = 'RESERVATIONFORM'
          iv_template_name  = 'RESERVATIONFORM'
        ).
        out->write( 'Form Template retrieved' ).

        cl_fp_ads_util=>render_4_pq(
          EXPORTING
            iv_locale       = 'en_US'
            iv_pq_name      =  'YYRESV' "'PRINT_QUEUE'
            iv_xml_data     = lv_xml
            iv_xdp_layout   = ls_template-xdp_template
            is_options      = VALUE #(
              trace_level = 4 "Use 0 in production environment
            )
          IMPORTING
            ev_trace_string = DATA(lv_trace)
            ev_pdl          = DATA(lv_pdf)
        ).
        out->write( 'Output was generated' ).

        cl_print_queue_utils=>create_queue_item_by_data(
          iv_qname = 'YYRESV'
          iv_print_data = lv_pdf
          iv_name_of_main_doc = 'Reservation Print'
        ).
        out->write( 'Output was sent to print queue' ).

      CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        out->write( 'Exception occurred.' ).
    ENDTRY.
    out->write( 'Finished processing.' ).
  ENDMETHOD.
ENDCLASS.
