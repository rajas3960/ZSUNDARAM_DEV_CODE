CLASS lhc_ZI_TAXINVOICE_HEADER_UPDAT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_taxinvoice_header_update RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_taxinvoice_header_update RESULT result.

    METHODS anxprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvoice_header_update~anxprint RESULT result.

    METHODS dcprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvoice_header_update~dcprint RESULT result.

    METHODS tprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvoice_header_update~tprint RESULT result.

ENDCLASS.

CLASS lhc_ZI_TAXINVOICE_HEADER_UPDAT IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD anxprint.
   READ ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
         ENTITY zi_taxinvoice_header_update
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      zbp_cds_taxinvoice_header=>gv_print3 = 'X'.
      MODIFY ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
             ENTITY zi_taxinvoice_header_update
             UPDATE
             FIELDS ( tprint  )
             WITH VALUE #( ( %tky   = <lfs_head>-%tky
                             tprint  = 'X'
                             ) ).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
         ENTITY zi_taxinvoice_header_update
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.



*ENDCLASS.
*  ENDMETHOD.

  METHOD dcprint.
  READ ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
       ENTITY zi_taxinvoice_header_update
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      zbp_cds_taxinvoice_header=>gv_print1 = 'X'.
      MODIFY ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
             ENTITY zi_taxinvoice_header_update
             UPDATE
             FIELDS ( tprint )
             WITH VALUE #( ( %tky   = <lfs_head>-%tky
                             tprint  = 'X'
                             ) ).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
         ENTITY zi_taxinvoice_header_update
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD tprint.
  READ ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
       ENTITY zi_taxinvoice_header_update
       ALL FIELDS
       WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         FAILED DATA(header_failed).


         data(ls_head) = value #( header[ 1 ] optional ).
         data : lv_bill type char10.

         SELECT single billingdocument from I_BillingDocument
         where billingdocument = @ls_head-SerialInvoiceNo
         into @lv_bill.

         lv_bill = |{ lv_bill ALPHA = IN }|.

          TYPES: begin of ty_text,
             client TYPE sy-mandt,
             BillingDocument TYPE char10,
             Language TYPE char2,
             TextID TYPE char4,
             LongText TYPE char200,
             END OF TY_TEXT.

          TYPES : tt_text TYPE TABLE of ty_text.
          data : gt_text TYPE table of ty_text.

         if lv_bill is NOT INITIAL.
           zcl_del_text_01=>get_text( EXPORTING billingdocument = lv_bill
           IMPORTING gt_text = gt_text ).
         endif.



    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      <lfs_head>-tprint = 'X'.
      zbp_cds_taxinvoice_header=>gv_print2 = 'X'.

      MODIFY ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
        ENTITY zi_taxinvoice_header_update
        UPDATE
        FIELDS  ( tprint )
        WITH VALUE #( ( %tky   = <lfs_head>-%tky
                         tprint = <lfs_head>-tprint
                          ) )
        FAILED DATA(failed_1)
        REPORTED DATA(reported_1)
        MAPPED DATA(mapped_1).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvoice_header_update IN LOCAL MODE
         ENTITY zi_taxinvoice_header_update
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_TAXINVOICE_HEADER_UPDAT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TAXINVOICE_HEADER_UPDAT IMPLEMENTATION.

  METHOD save_modified.
  TYPES: BEGIN OF ty_schema_body,
             xsd_schema  TYPE xstring,
             schema_name TYPE c LENGTH 30,
             note        TYPE c LENGTH 280,
           END OF ty_schema_body.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_xdp      TYPE ty_schema_body.
    DATA lv_json     TYPE string.
    DATA lv_doc_name TYPE char120.
    IF zbp_cds_taxinvoice_header=>gv_print2 = 'X'.
      IF update-zi_taxinvoice_header_update IS INITIAL.
        RETURN.
      ENDIF.

      FINAL(lt_head) = update-zi_taxinvoice_header_update.

      SELECT SINGLE * FROM zdt_printqueue
        WHERE cbuser = @sy-uname
         INTO @DATA(ls_queue).

      "    IF sy-subrc IS NOT INITIAL.

      "      ls_queue-printque = 'ADOBE_DEFAULT'.

      "    ENDIF.

      IF zbp_cds_taxinvoice_header=>gv_print2 = 'X'.
        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                 = 'YY1_CS_ADOBE'
              "iv_service_instance_name = 'YY1_ADS_CF_REST'
              iv_service_instance_name = 'YY1_OS_ADS_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_TAXINVPRINT1'
                                                                  iv_root_node = 'ZI_TAXINVHDR_PRINT' ).

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'INVOICEFORM' ).  "PASS THE FORM NAME
                "   out->write( 'Schema found in form' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "  out->write( 'No schema in form found' ).
                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
                  "Upload service definition
*                  lo_store->set_schema(
*                    iv_form_name = 'INVOICEFORM' " PASS THE FORM NAME
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
                ELSE.
                  "   out->write( lo_tmpl_error->get_longtext( ) ).
                ENDIF.
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'SERIALINVOICENO' ]-value = lt_head[ 1 ]-serialinvoiceno.

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
                "out->write( 'Service data retrieved' ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY..

            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'INVOICEFORM'  "PASS THE FORM NAME
              iv_template_name = 'YY1_TAX_INVOICE'    "PASS THE TEMPLATE NAME
            ).
            "out->write( 'Form Template retrieved' ).

            cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                     "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                               iv_xml_data     = lv_xml
                                               iv_xdp_layout   = ls_template-xdp_template
                                               is_options      = VALUE #( trace_level = 0 ) " Use 0 in production environment
                                     IMPORTING
                                     " TODO: variable is assigned but never used (ABAP cleaner)
                                               ev_trace_string = DATA(lv_trace)
                                               ev_pdf          = DATA(lv_pdf) ).
            " out->write( 'Output was generated' ).

            lv_doc_name = |Invoice :{ lt_head[ 1 ]-serialinvoiceno }|.

            DATA(lv_invno) = VALUE #( lt_head[ 1 ]-serialinvoiceno OPTIONAL ).

            SELECT SINGLE * FROM zdt_files
              WHERE serialinvoiceno =  @lv_invno INTO @DATA(ls_files).
            IF sy-subrc IS INITIAL.
              ls_files-attachment = lv_pdf.
              ls_files-mimetype   = 'application/pdf'.
              ls_files-filename   = lv_doc_name.
              MODIFY zdt_files FROM @ls_files.
            ELSE.
*
              CLEAR ls_files.
              ls_files-serialinvoiceno = lv_invno.
              ls_files-attachment = lv_pdf.
              ls_files-mimetype = 'application/pdf'.
              ls_files-filename = lv_doc_name.

*        ENDIF.
              MODIFY zdt_files FROM @ls_files.
            ENDIF.




            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = CONV zde_print_queue( ls_queue-printque )
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_doc_name
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).
            " out->write( 'Output was sent to print queue' ).
          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
            " out->write( 'Exception occurred.' ).

        ENDTRY.
          " out->write( 'Finished processing.' ).
      ELSEIF zbp_cds_taxinvoice_header=>gv_print1 = 'X'.
        IF update-zi_taxinvoice_header_update IS NOT INITIAL.

          DATA(lt_head1) = update-zi_taxinvoice_header_update.

          " TODO: variable is assigned but never used (ABAP cleaner)
          DATA(ls_head1) = VALUE #( lt_head1[ 1 ] OPTIONAL ).

          SELECT SINGLE * FROM zdt_printqueue
            WHERE cbuser = @sy-uname
             INTO @ls_queue.

          IF sy-subrc IS NOT INITIAL.

            ls_queue-printque = 'ADOBE_DEFAULT'.

          ENDIF.

          TRY.
              " Initialize Template Store Client
              DATA(lo_store1) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_CS_ADOBE'
                                                              iv_service_instance_name = 'YY1_ADS_CF_REST' ).

              FINAL(lo_fdp_util2) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_TAXINVPRINT'
                                                                            iv_root_node          = 'ZI_TAXINVHDR_PRINT' ).

              TRY.
                  lo_store1->get_schema_by_name( iv_form_name = 'Deliverychallan' ).  " PASS THE FORM NAME
                  "   out->write( 'Schema found in form' ).
                CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error1).
                  "  out->write( 'No schema in form found' ).
                  IF lo_tmpl_error1->mv_http_status_code = 404 OR lo_tmpl_error1->mv_http_status_code = 403.
                    " Upload service definition
                    "commented now
                    lo_store1->set_schema( iv_form_name = 'Deliverychallan' " PASS THE FORM NAME
                                          is_data      = VALUE #( note        = ''
                                                                  schema_name = 'schema'
                                                                  xsd_schema  = lo_fdp_util2->get_xsd( ) ) ).
                  ELSE.
                    "   out->write( lo_tmpl_error->get_longtext( ) ).
                  ENDIF.
              ENDTRY.
              " Get initial select keys for service
              DATA(lt_keys1) = lo_fdp_util2->get_keys( ).
              lt_keys1[ name = 'SERIALINVOICENO' ]-value = lt_head1[ 1 ]-serialinvoiceno.

              TRY.
                  DATA(lv_xml1) = lo_fdp_util2->read_to_xml( lt_keys1 ).
                  " out->write( 'Service data retrieved' ).
                CATCH cx_fp_fdp_error INTO DATA(lo_exception1). " TODO: variable is assigned but never used (ABAP cleaner)
              ENDTRY.

              DATA(ls_template1) = lo_store1->get_template_by_name( iv_get_binary    = abap_true
                                                                  iv_form_name     = 'Deliverychallan'  " PASS THE FORM NAME
                                                                  iv_template_name = 'Deliverychallan' ). " PASS THE TEMPLATE NAME
              " out->write( 'Form Template retrieved' ).

              cl_fp_ads_util=>render_4_pq( EXPORTING iv_locale       = 'en_US'
*                                                   iv_pq_name      = 'YGATEPASS'  " Queue Name
                                                     iv_pq_name      = CONV zde_print_queue( ls_queue-printque )
                                                     iv_xml_data     = lv_xml1
                                                     iv_xdp_layout   = ls_template1-xdp_template
                                                     is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                           IMPORTING
                                           " TODO: variable is assigned but never used (ABAP cleaner)
                                                     ev_trace_string = DATA(lv_trace1)
                                                     ev_pdl          = DATA(lv_pdf1) ).
              " out->write( 'Output was generated' ).
              DATA lv_doc_name1 TYPE char120.
              lv_doc_name1 = |Deliverychallan :{ lt_head1[ 1 ]-serialinvoiceno }|.

              cl_print_queue_utils=>create_queue_item_by_data(
*                iv_qname            = 'YGATEPASS'  " Queue Name
                  iv_qname            = CONV zde_print_queue( ls_queue-printque )
                  iv_print_data       = lv_pdf1
                  iv_name_of_main_doc = lv_doc_name1
                  iv_itemid           = cl_print_queue_utils=>create_queue_itemid( ) ).
              " out->write( 'Output was sent to print queue' ).
            CATCH cx_fp_fdp_error
                  zcx_fp_tmpl_store_error1
                  cx_fp_ads_util.
              " out->write( 'Exception occurred.' ).
          ENDTRY.
        ENDIF.
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      ELSEIF zbp_cds_taxinvoice_header=>gv_print3 = 'X'.
        IF update-zi_taxinvoice_header_update IS NOT INITIAL.

          DATA(lt_head2) = update-zi_taxinvoice_header_update.

          " TODO: variable is assigned but never used (ABAP cleaner)
          DATA(ls_head2) = VALUE #( lt_head1[ 1 ] OPTIONAL ).

          SELECT SINGLE * FROM zdt_printqueue
            WHERE cbuser = @sy-uname
             INTO @ls_queue.

          IF sy-subrc IS NOT INITIAL.

            ls_queue-printque = 'ADOBE_DEFAULT'.

          ENDIF.

          TRY.
              " Initialize Template Store Client
              DATA(lo_store2) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_CS_ADOBE'
                                                              iv_service_instance_name = 'YY1_ADS_CF_REST' ).

              FINAL(lo_fdp_util3) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_TAXINVPRINT'
                                                                            iv_root_node          = 'ZI_TAXINVHDR_PRINT' ).

              TRY.
                  lo_store2->get_schema_by_name( iv_form_name = 'ANNEXUREPRINT' ).  " PASS THE FORM NAME
                  "   out->write( 'Schema found in form' ).
                CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error2).
                  "  out->write( 'No schema in form found' ).
                  IF lo_tmpl_error2->mv_http_status_code = 404 OR lo_tmpl_error2->mv_http_status_code = 403.
                    " Upload service definition
                    "commented now
                    lo_store2->set_schema( iv_form_name = 'ANNEXUREPRINT' " PASS THE FORM NAME
                                          is_data      = VALUE #( note        = ''
                                                                  schema_name = 'schema'
                                                                  xsd_schema  = lo_fdp_util3->get_xsd( ) ) ).
                  ELSE.
                    "   out->write( lo_tmpl_error->get_longtext( ) ).
                  ENDIF.
              ENDTRY.
              " Get initial select keys for service
              DATA(lt_keys2) = lo_fdp_util3->get_keys( ).
              lt_keys2[ name = 'SERIALINVOICENO' ]-value = lt_head2[ 1 ]-serialinvoiceno.

              TRY.
                  DATA(lv_xml2) = lo_fdp_util3->read_to_xml( lt_keys2 ).
                  " out->write( 'Service data retrieved' ).
                CATCH cx_fp_fdp_error INTO DATA(lo_exception2). " TODO: variable is assigned but never used (ABAP cleaner)
              ENDTRY.

              DATA(ls_template2) = lo_store2->get_template_by_name( iv_get_binary    = abap_true
                                                                  iv_form_name     = 'ANNEXUREPRINT'  " PASS THE FORM NAME
                                                                  iv_template_name = 'ANNEXUREPRINT' ). " PASS THE TEMPLATE NAME
              " out->write( 'Form Template retrieved' ).

              cl_fp_ads_util=>render_4_pq( EXPORTING iv_locale       = 'en_US'
*                                                   iv_pq_name      = 'YGATEPASS'  " Queue Name
                                                     iv_pq_name      = CONV zde_print_queue( ls_queue-printque )
                                                     iv_xml_data     = lv_xml2
                                                     iv_xdp_layout   = ls_template2-xdp_template
                                                     is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                           IMPORTING
                                           " TODO: variable is assigned but never used (ABAP cleaner)
                                                     ev_trace_string = DATA(lv_trace2)
                                                     ev_pdl          = DATA(lv_pdf2) ).
              " out->write( 'Output was generated' ).
              DATA lv_doc_name2 TYPE char120.
              lv_doc_name2 = |ANNEXUREPRINT :{ lt_head2[ 1 ]-serialinvoiceno }|.

              cl_print_queue_utils=>create_queue_item_by_data(
                  iv_qname            = CONV zde_print_queue( ls_queue-printque )
                  iv_print_data       = lv_pdf2
                  iv_name_of_main_doc = lv_doc_name2
                  iv_itemid           = cl_print_queue_utils=>create_queue_itemid( ) ).
              " out->write( 'Output was sent to print queue' ).
            CATCH cx_fp_fdp_error
                  zcx_fp_tmpl_store_error1
                  cx_fp_ads_util.
              " out->write( 'Exception occurred.' ).
          ENDTRY.

        ENDIF.
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
