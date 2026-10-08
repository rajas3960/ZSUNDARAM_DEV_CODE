CLASS lhc_zi_taxinvoice_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_taxinvoice_header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_taxinvoice_header RESULT result.

    METHODS tprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvoice_header~tprint RESULT result.
    METHODS dcprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvoice_header~dcprint RESULT result.
    METHODS anxprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxinvoice_header~anxprint RESULT result.
*    METHODS email FOR MODIFY
*      IMPORTING keys FOR ACTION zi_taxinvoice_header~email RESULT result.

ENDCLASS.


CLASS lhc_zi_taxinvoice_header IMPLEMENTATION.
  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD tprint.
    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
       ENTITY zi_taxinvoice_header
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

      MODIFY ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
        ENTITY zi_taxinvoice_header
        UPDATE
        FIELDS  ( tprint )
        WITH VALUE #( ( %tky   = <lfs_head>-%tky
                         tprint = <lfs_head>-tprint
                          ) )
        FAILED DATA(failed_1)
        REPORTED DATA(reported_1)
        MAPPED DATA(mapped_1).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
         ENTITY zi_taxinvoice_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

*  new logic added by SAR tech team on 14.04.2026

            select * from ZV_TAXINV_ITEMP WITH PRIVILEGED ACCESS
            where billingdocument = @ls_head-SerialInvoiceNo
            into table @DATA(lt_taxitem).

            if lt_taxitem is not initial.
            data: lt_taxitem_db type zsd_taxitemprint.

            sort lt_taxitem ASCENDING BY billingdocumentitem.

            loop at lt_taxitem ASSIGNING FIELD-SYMBOL(<ls_taxitem>).
                if <ls_taxitem> is ASSIGNED.
                    MOVE-CORRESPONDING <ls_taxitem> TO lt_taxitem_db.
                    lt_taxitem_db-orderunit1 = <ls_taxitem>-OrderUnit.
                    modify zsd_taxitemprint from @lt_taxitem_db.
                endif.
            endloop.

            endif.

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).



*    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
*         ENTITY zi_taxinvoice_header
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(header)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(header_failed).
*
*    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
*      <lfs_head>-tprint = 'X'.
*      zbp_cds_taxinvoice_header=>gv_print2 = 'X'.
*      MODIFY ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
*             ENTITY zi_taxinvoice_header
*             UPDATE
*             FIELDS ( tprint )
*             WITH VALUE #( ( %tky   = <lfs_head>-%tky
*                             tprint = <lfs_head>-tprint ) ).
*    ENDLOOP.
*
*    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
*         ENTITY zi_taxinvoice_header
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(header_1).
*
*    result = VALUE #( FOR ls_header IN header_1
*                      ( %tky   = ls_header-%tky
*                        %param = ls_header ) ).

****************************************************************************
          select AddressID,AddressPersonID,EmailAddress
            from ZI_CUST_ADDR1 wiTH PRIVILEGED ACCESS
            where AddressID = @ls_head-Pyraddrid
            and EmailAddress is not iNITIAL
            into table @dATA(lt_email).
****************************************************************************

        if lt_email is INITIAL.

*            APPEND VALUE #(
*                            %tky = ls_head-%tky
*                            ) TO failed-zi_taxinvoice_header.

            APPEND VALUE #(
                            %tky = ls_head-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-warning
                        text     = 'Maintain the Email in Customer Master Level' )
            ) TO reported-zi_taxinvoice_header.

        ENDIF.


  ENDMETHOD.
  METHOD dcprint.
    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
       ENTITY zi_taxinvoice_header
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      zbp_cds_taxinvoice_header=>gv_print1 = 'X'.
      MODIFY ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
             ENTITY zi_taxinvoice_header
             UPDATE
             FIELDS ( tprint )
             WITH VALUE #( ( %tky   = <lfs_head>-%tky
                             tprint  = 'X'
                             ) ).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
         ENTITY zi_taxinvoice_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD anxprint.
    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
         ENTITY zi_taxinvoice_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
      zbp_cds_taxinvoice_header=>gv_print3 = 'X'.
      MODIFY ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
             ENTITY zi_taxinvoice_header
             UPDATE
             FIELDS ( tprint  )
             WITH VALUE #( ( %tky   = <lfs_head>-%tky
                             tprint  = 'X'
                             ) ).
    ENDLOOP.

    READ ENTITIES OF zi_taxinvoice_header IN LOCAL MODE
         ENTITY zi_taxinvoice_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.


ENDCLASS.


CLASS lsc_zi_taxinvoice_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified    REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_zi_taxinvoice_header IMPLEMENTATION.
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
      IF update-zi_taxinvoice_header IS INITIAL.
        RETURN.
      ENDIF.

      FINAL(lt_head) = update-zi_taxinvoice_header.
      FINAL(lt_item) = update-zi_taxinvoice_item.

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

****************************************************************
******------Automatic Email Triger Part-----Start Process
****************************************************************
if lv_pdf is not INITIAL.

            data: lv_sender type c LENGTH 512,
                  lv_recemail type c length 512,
                  lv_reciever type c length 512.
            data: gt_email type table of zdt_files,
                  gs_email TYPE zdt_files.
****************************************************************************
******---Email Validation----***********************************************
            data(lt_key) = update-zi_taxinvoice_header.
            data(ls_key) = VALUE #( lt_head[ 1 ] OPTIONAL ).
****************************************************************************
            select AddressID,AddressPersonID,EmailAddress
            from ZI_CUST_ADDR1 wiTH PRIVILEGED ACCESS
            where AddressID = @ls_key-Pyraddrid
            and EmailAddress is not iNITIAL
            into table @dATA(lt_email).

            select BillingDocument,RatePerUnit,CGST,SGST,IGST,TaxableAmount,Roundoff
            from zi_taxinvoice_item wiTH PRIVILEGED ACCESS
            where BillingDocument = @ls_key-SerialInvoiceNo
            and BillingDocument is not iNITIAL
            into table @dATA(lt_emaT).

****************************************************************************
if lt_email is not INITIAL.

    "-----------------------------------------------------------
    " Add body Content
    "-----------------------------------------------------------
    data(lv_date) = |{ ls_key-DateOfInvoice+6(2) }-{ SWITCH string( ls_key-DateOfInvoice+4(2)
                            WHEN '01' THEN 'Jan'
                            WHEN '02' THEN 'Feb'
                            WHEN '03' THEN 'Mar'
                            WHEN '04' THEN 'Apr'
                            WHEN '05' THEN 'May'
                            WHEN '06' THEN 'Jun'
                            WHEN '07' THEN 'Jul'
                            WHEN '08' THEN 'Aug'
                            WHEN '09' THEN 'Sep'
                            WHEN '10' THEN 'Oct'
                            WHEN '11' THEN 'Nov'
                            WHEN '12' THEN 'Dec' ) }-{ ls_key-DateOfInvoice(4) }|.
    data(lv_text) = ' Sale invoice is generated with an invoice number'.
    data(lv_invre) = |{ ls_key-SerialInvoiceNo } |.
    data(lv_invdate) = |{ lv_date } |.
    data(lv_slorder) = |{ ls_key-SalesOrder } |.

  DATA: lv_rate   TYPE p LENGTH 16 DECIMALS 2,
      lv_amount TYPE string,
      lv_rate_rounded TYPE i.

      CLEAR lv_rate.

   LOOP AT lt_emat INTO DATA(ls_emat).
   lv_rate = lv_rate
          + ls_emat-TaxableAmount
          + ls_emat-CGST
          + ls_emat-SGST
          + ls_emat-IGST.
   ENDLOOP.

   lv_rate_rounded = CONV i( lv_rate ).
   lv_amount = |{ lv_rate_rounded }|.

    data(lv_text2) = 'Kindly ensure timely payment as per the agreed terms.'.
    data(lv_text3) = 'This is a system-generated email. Please do not reply to this message.'.
    data ccname tYPE c LENGTH 100.
    data ccname1 tYPE c LENGTH 100.
*    if ( ls_key-CompanyCode = '1000' or ls_key-CompanyCode = '3000' ).
    if ls_key-CompanyCode = '1000'.
    ccname = 'Sundaram Steels Pvt. Ltd.'.
    lv_sender = 'accounts.support@sundaramsteels.in'.
    elseif ls_key-CompanyCode = '2000'.
    ccname = 'Chintpurni Steels Pvt. Ltd. '.
    lv_sender = 'accounts@chintpurnisteel.com'.
    endif.

    DATA : iv_content      TYPE string .
    data(iv_content1) = |<p>Dear Customer,</p><p></p><p>{ lv_text } { lv_invre }date { lv_invdate }value INR { lv_amount } against sales order { lv_slorder }. |.
    data(iv_content2) = | <p></p>Regards,</p><p>{ ccname }</p>|.
    iv_content = iv_content1 && iv_content2 .
    "-----------------------------------------------------------
    " Add Sender Mail
    "-----------------------------------------------------------
*    lv_sender = 'accounts.support@sundaramsteels.in'.
*                lv_reciever = gs_emailhd-EmailAddress.
*    lv_reciever = ''.
*    data: lt_receivers TYPE STANDARD TABLE OF string.
*    SPLIT lv_reciever AT ';' INTO TABLE lt_receivers.

    "-----------------------------------------------------------
    " Add Sender Mail
    "-----------------------------------------------------------
    try.
    data(lo_mail) = cl_bcs_mail_message=>create_instance(  ).
    lo_mail->set_sender( lv_sender ).
*    lo_mail->set_subject( 'Invoice' ) .
    lo_mail->set_subject( |Invoice - { ls_key-SerialInvoiceNo }| ).
    "-----------------------------------------------------------
    "Add multiple recipients
    "-----------------------------------------------------------
    LOOP AT lt_email INTO DATA(lv_email).
    CONDENSE lv_email-EmailAddress NO-GAPS.
    IF lv_email-EmailAddress IS NOT INITIAL.
    lv_recemail = lv_email-EmailAddress.
    lo_mail->add_recipient( lv_recemail ).
    ENDIF.
    ENDLOOP.

    "-----------------------------------------------------------
    " Add HTML body
    "-----------------------------------------------------------
    lo_mail->set_main(
        cl_bcs_mail_textpart=>create_instance(
            iv_content      = iv_content
            iv_content_type = 'text/html'
        )
    ).
    "---------------------------------------------------------------
    " Add PDF attachment from Base64
    "---------------------------------------------------------------
    lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
*                            iv_content = lv_print_data   " PDF Base64 from ADS
                            iv_content = lv_pdf   " PDF Base64 from ADS
                            iv_content_type = 'application/pdf'
                            iv_filename     = 'Invoice.pdf' ) ).
    "-----------------------------------------------------------
    " Send Email & Capture Status
    "-----------------------------------------------------------
    lo_mail->send(
        IMPORTING et_status = DATA(lt_status)
    ).
    "--------------------------------------------------
    " Validate Send Status
    "--------------------------------------------------
        CATCH cx_bcs_mail INTO data(lx_mail1).
            data(lv_cxemail) = 1.
          " TODO: log failure
      ENDTRY.

ELSE.
**      APPEND VALUE #( %tky = ls_key-%key ) TO failed-zi_taxinvoice_header.
**      APPEND VALUE #( %tky = ls_key-%key
**      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
**                                                              text = 'Maintain the Email in Customer Master Level' )
**                               ) TO reported-zi_taxinvoice_header.
*
*APPEND VALUE #(
*  %tky = ls_key-%tky
*) TO failed-zi_taxinvoice_header.
*
*APPEND VALUE #(
*  %tky = ls_key-%tky
*  %msg = new_message_with_text(
*            severity = if_abap_behv_message=>severity-error
*            text     = 'Maintain the Email in Customer Master Level' )
*) TO reported-zi_taxinvoice_header.
ENDIF.

endif.
**************************************************************



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

****************************************************************************************************************************************
*      "if zbp_cds_taxinvoice_header=>gv_print2 = 'X'.
*      "-----------------------Comment YC--------------------------------------------------------------
**      TRY.
**          " Initialize Template Store Client
**          FINAL(lo_store) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_CS_ADOBE'
**                                                           iv_service_instance_name = 'YY1_ADS_CF_REST' ).
*      "-----------------------Comment YC--------------------------------------------------------------
*          FINAL(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_TAXINVPRINT'
*                                                                 iv_root_node          = 'ZI_TAXINVHDR_PRINT' ).
*
**          TRY.
**              lo_store->get_schema_by_name( iv_form_name = 'INVOICEFORM' ).
**            CATCH zcx_fp_tmpl_store_error1 INTO FINAL(lo_tmpl_error).
**              IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403.
**                lo_store->set_schema( iv_form_name = 'INVOICEFORM'
**                                      is_data      = VALUE #( note        = ''
**                                                              schema_name = 'schema'
**                                                              xsd_schema  = lo_fdp_util->get_xsd( ) ) ).
**              ENDIF.
**          ENDTRY.
*
**          lv_xdp = VALUE #( note        = ''
**                            schema_name = 'schema'
**                            xsd_schema  = lo_fdp_util->get_xsd( ) ).
*
*          " Get initial select keys for service
*          DATA() = lo_fdp_util->get_keys( ).
*          [ name = 'SERIALINVOICENO' ]-value = lt_head[ 1 ]-serialinvoiceno.
*
*          TRY.
*              FINAL(lv_xml) = lo_fdp_util->read_to_xml(  ).
*            CATCH cx_fp_fdp_error INTO FINAL(lo_exception). " TODO: variable is assigned but never used (ABAP cleaner)
*          ENDTRY.
*
*          " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
**          FINAL(ls_template) = lo_store->get_template_by_name( iv_get_binary    = abap_true
**                                                               iv_form_name     = 'INVOICEFORM'
**                                                               iv_template_name = 'YY1_TAX_INVOICE' ).
**        ------------------------------------------Commented-----------------------------------------------------
**          cl_fp_ads_util=>render_4_pq( EXPORTING iv_locale       = 'en_US'
**                                                 iv_pq_name      = CONV zde_print_queue( ls_queue-printque )"'YYINVOICE'
**                                                 iv_xml_data     = lv_xml
**                                                 iv_xdp_layout   = ls_template-xdp_template
**                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
**                                       IMPORTING
**                                                 ev_trace_string = FINAL(lv_trace)
**                                                 ev_pdl          = FINAL(lv_pdf) ).
**
**          cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
**                                                iv_xml_data     = lv_xml
**                                                iv_xdp_layout   = ls_template-xdp_template
**                                                is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
**                                      IMPORTING
**                                                ev_trace_string = FINAL(lv_trace00)
**                                                ev_pdf          = FINAL(lv_pdf00) ).
**        ------------------------------------------Commented-----------------------------------------------------
*          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Tax Invoice""""""""""""""""""""""
*          lv_json = '{'.
*          lv_json = |{ lv_json }"embedFont": "0" ,|.
*          lv_json = |{ lv_json }"formLocale":"en_US",|.
*          lv_json = |{ lv_json }"formType":"interactive",|.
*          lv_json = |{ lv_json }"taggedPdf": "1" ,|.
*          lv_json = |{ lv_json }"xdpTemplate":"INVOICEFORM/YY1_TAX_INVOICE",|.
*          lv_json = |{ lv_json }"xmlData":"{ cl_web_http_utility=>encode_x_base64( lv_xml ) }"|.
*          lv_json = |{ lv_json } \}|.
*
*          TRY.
*              FINAL(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                           comm_scenario = 'ZCS_PDFGET'
*                                           service_id    = 'ZOS_PDFGET_REST' ).
*              FINAL(lo_http_client1) = cl_web_http_client_manager=>create_by_http_destination( lo_destination1 ).
*              FINAL(lo_request1) = lo_http_client1->get_http_request( ).
*              lo_request1->set_content_type( content_type = |application/json| ).
*              lo_request1->set_text( lv_json ).
*              FINAL(ls_result1) = lo_http_client1->execute( if_web_http_client=>post )->get_text( ).
**            out->write( ls_result ).
*              lo_http_client1->close( ).
*              CLEAR lv_json.
*            CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error1). " TODO: variable is assigned but never used (ABAP cleaner)
*            CATCH cx_web_http_client_error INTO FINAL(web_http_client_error1). " TODO: variable is assigned but never used (ABAP cleaner)
*          ENDTRY.
*          SPLIT ls_result1 AT '"fileContent":"' INTO TABLE DATA(lt_tab).
*          DATA(ls_str) = VALUE #( lt_tab[ 2 ] OPTIONAL ).
*          SPLIT ls_str AT '"' INTO TABLE DATA(lt_tab1).
*          DATA(ls_str1) = VALUE #( lt_tab1[ 1 ] OPTIONAL ).
**        ------------------------------------------Commented-----------------------------------------------------
*          "FINAL(lv_pdf_base64) = cl_web_http_utility=>encode_x_base64( lv_pdf00 ).
**        ------------------------------------------Commented-----------------------------------------------------
**
*          lv_json = '{'.
*          lv_json = |{ lv_json }"credentialAlias": "ServerSignature2" ,|.
*          lv_json = |{ lv_json }"signatureFieldName":"SignatureField1",|.
*          lv_json = |{ lv_json }"reasonInfo":"approval",|.
*          lv_json = |{ lv_json }"locationInfo": "India" ,|.
*          lv_json = |{ lv_json }"contactInfo":"rajesh.kansara@rubberkingtyres.com",|.
*          lv_json = |{ lv_json }"pdf":"{ ls_str1 }"|." lv_pdf_base64 Tax Invoice
*          lv_json = |{ lv_json } \}|.
*
*          TRY.
*              FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                          comm_scenario = 'ZCS_SIGN'
*                                          service_id    = 'ZOUTB_SIGN_REST' ).
*              FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*              FINAL(lo_request) = lo_http_client->get_http_request( ).
*              lo_request->set_content_type( content_type = |application/json| ).
*              lo_request->set_text( lv_json ).
*              FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
**            out->write( ls_result ).
*              lo_http_client->close( ).
*              CLEAR lv_json.
*            CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
*            CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
*          ENDTRY.
*          SPLIT ls_result AT '"fileContent":"' INTO TABLE DATA(lt_tab2).
*          DATA(ls_str3) = VALUE #( lt_tab2[ 2 ] OPTIONAL ).
*          SPLIT ls_str3 AT '"' INTO TABLE DATA(lt_tab4).
*          DATA(ls_str4) = VALUE #( lt_tab4[ 1 ] OPTIONAL ).
*          lv_doc_name = |Invoice :{ lt_head[ 1 ]-serialinvoiceno }|.
*          DATA lv_string TYPE xstring.
*          "  lv_string = ls_str4.
*          lv_string = cl_web_http_utility=>decode_x_base64( ls_str4 ).
**          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'Tax Invoice""""""""""""""""""""""""""""""""""
**          cl_print_queue_utils=>create_queue_item_by_data(
***          EXPORTING iv_qname            = 'YYINVOICE' " CONV zde_pqname( ls_queue-printque )" "'YYRFQ'
**            EXPORTING iv_qname            = CONV zde_print_queue( ls_queue-printque )
**                      iv_print_data       = lv_string "lv_pdf
**                      iv_name_of_main_doc = lv_doc_name
**                      iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
**            IMPORTING
**            " TODO: variable is assigned but never used (ABAP cleaner)
**                      ev_err_msg          = DATA(lv_msg) ).
*          " out->write( 'Output was sent to print queue' ).
**
**        CATCH cx_fp_fdp_error
**              zcx_fp_tmpl_store_error1
**              cx_fp_ads_util.
**          " out->write( 'Exception occurred.' ).
**      ENDTRY.
*      DATA(lv_invno) = VALUE #( lt_head[ 1 ]-serialinvoiceno OPTIONAL ).
*
*      IF lv_invno IS NOT INITIAL.
*        SELECT SINGLE * FROM zdt_files WHERE serialinvoiceno = @lv_invno INTO @DATA(ls_files).
*
*        IF sy-subrc IS INITIAL.
*
*          ls_files-attachment = lv_string.
*          ls_files-mimetype = 'application/pdf'.
*          ls_files-filename = lv_doc_name.
*
*        ELSE.
*
*          CLEAR ls_files.
*          ls_files-serialinvoiceno = lv_invno.
*          ls_files-attachment = lv_string.
*          ls_files-mimetype = 'application/pdf'.
*          ls_files-filename = lv_doc_name.
*
*        ENDIF.
*
*        MODIFY zdt_files
*          FROM @ls_files.
*      ENDIF.
**************************************************************************************************************************************


        " out->write( 'Finished processing.' ).
      ELSEIF zbp_cds_taxinvoice_header=>gv_print1 = 'X'.
        IF update-zi_taxinvoice_header IS NOT INITIAL.

          DATA(lt_head1) = update-zi_taxinvoice_header.

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
        IF update-zi_taxinvoice_header IS NOT INITIAL.

          DATA(lt_head2) = update-zi_taxinvoice_header.

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
