CLASS lhc_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Head RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Head RESULT result.

    METHODS pdf FOR MODIFY
      IMPORTING keys FOR ACTION Head~pdf RESULT result.
    METHODS Email FOR MODIFY
      keys FOR ACTION Head~Email RESULT result.

ENDCLASS.

CLASS lhc_Head IMPLEMENTATION.

  METHOD get_instance_features.
******************************************************************
            READ ENTITIES OF zfi_head_rv IN LOCAL MODE
            ENTITY Head
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
            FAILED DATA(lt_failed).

******************************************************************
            DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
******************************************************************
        result = VALUE #( for ls_key in keys
                     ( %tky = ls_key-%tky

                     %action = VALUE #( Email = COND #( WHEN ls_head-attachment  is not INITIAL
                                            then if_abap_behv=>fc-o-enabled
                                            ELSE if_abap_behv=>fc-o-disabled )
                                            )
                                         ) ) .
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD pdf.
*******************************************************************
        data: lt_upform type table of zfi_form_db,
              ls_upform type zfi_form_db,
              formtype type c lENGTH 50.
*******************************************************************
        READ ENTITIES OF zfi_head_rv IN LOCAL MODE
        ENTITY Head
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(gt_head)
        ENTITY Head BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_item)
        FAILED FINAL(gt_failed).
*******************************************************************
        DATA(ls_header) = VALUE #( gt_head[ 1 ] optional ).
        DATA(ls_item) = VALUE #( gt_item[ 1 ] OPTIONAL ).
        DATA(gt_keys) = keys.
        DATA(gs_keys) = VALUE #( gt_keys[ 1 ] OPTIONAL ).
        DATA: lv_name TYPE c LENGTH 120.
        data: lv_taxcode type c LENGTH 2.
*******************************************************************
        formtype = gs_keys-%param-FormType.
*******************************************************************
    ""RCM Self Invoice Tax code
CASE ls_item-TaxCode.
  WHEN 'R1'.
    lv_taxcode = 'R1'.
  WHEN 'RA'.
    lv_taxcode = 'RA'.
  WHEN 'RB'.
    lv_taxcode = 'RB'.
  WHEN 'RC'.
    lv_taxcode = 'RC'.
  WHEN 'RD'.
    lv_taxcode = 'RD'.
  WHEN 'RE'.
    lv_taxcode = 'RE'.
  WHEN 'RF'.
    lv_taxcode = 'RF'.
  WHEN 'RG'.
    lv_taxcode = 'RG'.
  WHEN 'RH'.
    lv_taxcode = 'RH'.
  WHEN 'RI'.
    lv_taxcode = 'RI'.
  WHEN 'RJ'.
    lv_taxcode = 'RJ'.
  WHEN 'RN'.
    lv_taxcode = 'RN'.
  WHEN 'RS'.
    lv_taxcode = 'RS'.
  WHEN 'J1'.
    lv_taxcode = 'J1'.
  WHEN 'J2'.
    lv_taxcode = 'J2'.
  WHEN 'J3'.
    lv_taxcode = 'J3'.
  WHEN 'J4'.
    lv_taxcode = 'J4'.
  WHEN 'J5'.
    lv_taxcode = 'J5'.
  WHEN 'J6'.
    lv_taxcode = 'J6'.
  WHEN OTHERS.
    CLEAR lv_taxcode.
ENDCASE.
*******************************************************************
        if ls_header-AccountingDocument is not INITIAL.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'ZADS_CS'
             iv_service_instance_name = 'ZADS_OUT_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZFI_FORM_SD'
                                                                  iv_root_node = 'ZFI_FORM_OUTPUT' ) .

            data: printque type c LENGTH 32.

              printque = 'ADOBE_DEFAULT'.

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'CREDITNOTE' ).
                "   out->write( 'Schema found in form' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "  out->write( 'No schema in form found' ).
                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
                  "Upload service definition
*                  lo_store->set_schema(
*                    iv_form_name = 'GATEFORM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
                ELSE.

                ENDIF.
            ENDTRY.
**********************************************************************
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
**********************************************************************

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'ACCOUNTINGDOCUMENT' ]-value = gt_head[ 1 ]-AccountingDocument.
            lt_keys[ name = 'FISCALYEAR' ]-value = gt_head[ 1 ]-FiscalYear.
            lt_keys[ name = 'COMPANYCODE' ]-value = gt_head[ 1 ]-CompanyCode.
**********************************************************************
            data(lt_xsd) = lo_fdp_util->get_xsd( ).
**********************************************************************

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
                "out->write( 'Service data retrieved' ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY..


*******************************************************************
            "Form Validation procress--
            "this one for Without Purchase Order
            if ( ls_header-AccountingDocumentType = 'KG' or ls_header-AccountingDocumentType = 'KR' ) and formtype = 'Credit-Debit Note FI'.
*****************************************************************************
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'CREDITNOTE_FI'
              iv_template_name = 'CREDITNOTE'
            ).
*****************************************************************************
            cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                       "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                                 iv_xml_data     = lv_xml
                                                 iv_xdp_layout   = ls_template-xdp_template
                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                       IMPORTING
                                       " TODO: variable is assigned but never used (ABAP cleaner)
                                                 ev_trace_string = DATA(lv_trace)
                                                 ev_pdf          = DATA(lv_pdf) ).

            lv_name = |Credit/Debit-{ gt_head[ 1 ]-AccountingDocument }|.
*****************************************************************************
            "this one for With Purchase Order"
            elseif ls_header-AccountingDocumentType = 'RE' and formtype = 'Credit-Debit Note MM'.   ""MM credit and debit not form
*****************************************************************************
            ls_template = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'CREDITNOTE_MM'
              iv_template_name = 'CREDITNOTE'
            ).
*****************************************************************************
            cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                       "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                                 iv_xml_data     = lv_xml
                                                 iv_xdp_layout   = ls_template-xdp_template
                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                       IMPORTING
                                       " TODO: variable is assigned but never used (ABAP cleaner)
                                                 ev_trace_string = lv_trace
                                                 ev_pdf          = lv_pdf  ).

            lv_name = |Credit/Debit-{ gt_head[ 1 ]-AccountingDocument }|.
*****************************************************************************
             elseif formtype = 'RCM Self Invoice' and ls_item-TaxCode = lv_taxcode.    ""RCM Self invoice form
*****************************************************************************
            ls_template = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'RCM_INVOICE'
              iv_template_name = 'RCM'
            ).
*****************************************************************************
            cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                       "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                                 iv_xml_data     = lv_xml
                                                 iv_xdp_layout   = ls_template-xdp_template
                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                       IMPORTING
                                       " TODO: variable is assigned but never used (ABAP cleaner)
                                                 ev_trace_string = lv_trace
                                                 ev_pdf          = lv_pdf  ).

            lv_name = |RCM Self Invoice-{ gt_head[ 1 ]-AccountingDocument }|.
*****************************************************************************
                else.
                    APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
                    APPEND VALUE #( %tky = ls_header-%tky
                    %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Form Type is Wrong' )
                               ) TO reported-head.
            endif.
*****************************************************************************


*****************************************************************************
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = printque
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_name
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
            " out->write( 'Exception occurred.' ).
        ENDTRY.
*****************************************************************************
        "out->write( 'Finished processing.' ).
          data: gt_att type table of zfi_form_db,
                gs_att type zfi_form_db.
*****************************************************************************
                if lv_pdf is not iNITIAL.

                 GET TIME STAMP FIELD DATA(ts).
                    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
                TRY.
                    DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
                CATCH cx_abap_context_info_error.
                DATA(ls_x1) = 1.
                ENDTRY.
                    DATA(lv_cbuser) = 'CB' && lv_user.

*****************************************************************************
                    gs_att-accountingdocument = ls_header-AccountingDocument.
                    gs_att-fiscalyear = ls_header-FiscalYear.
                    gs_att-companycode = ls_header-CompanyCode.
                    gs_att-accountingdocumenttype = ls_header-AccountingDocumentType.
                    gs_att-formtype = gs_keys-%param-FormType.
                    gs_att-createdby = lv_cbuser.
                    gs_att-createdat = lv_time.
                    gs_att-attachment = lv_pdf.
                    gs_att-filename = lv_name.
                    gs_att-mimetype = 'application/pdf'.

                 APPEND gs_att to gt_att.
                 zbp_fi_head_rv=>upform = gt_att.
                endif.

        endif.
**********************************************************************
    result = VALUE #( FOR ls_ord IN gt_head
                         ( %tky   = ls_ord-%tky
                           %param = ls_ord ) ).



  ENDMETHOD.

  METHOD Email.
****************************************************************
******------Email Triger Part-----Start Process
****************************************************************
            data: lv_sender type c LENGTH 512,
                  lv_recemail type c length 512,
                  lv_reciever type c length 512.
            data ccname tYPE c LENGTH 100.
****************************************************************
            READ ENTITIES OF zfi_head_rv IN LOCAL MODE
            ENTITY Head
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(gt_head)
            FAILED DATA(gt_failed).
****************************************************************
            DATA(ls_header) = VALUE #( gt_head[ 1 ] OPTIONAL ).
****************************************************************

            SELECT * FROM ZFI_SUPP_ADD WITH PRIVILEGED ACCESS
            WHERE Supplier = @ls_header-Supplier
            INTo TABLE @DATA(gt_email).

            data(ls_email) = VALUE #( gt_email[ 1 ] OPTIONAL ).

    if ls_email-EmailAddress is NOT INITIAL.

            data(lv_body) = 'Dear Sir or Madam,'.
            DATA(lv_cont) = |Please find attached the Credit/Debit Note form { ls_header-AccountingDocument }|.

    "-----------------------------------------------------------
    " Add Sender Mail
    "-----------------------------------------------------------
    if ls_header-CompanyCode = '1000'.
    ccname = 'Sundaram Steels Pvt. Ltd.'.
    lv_sender = 'accounts.support@sundaramsteels.in'.
    elseif ls_header-CompanyCode = '2000'.
    ccname = 'Chintpurni Steels Pvt. Ltd. '.
    lv_sender = 'accounts@chintpurnisteel.com'.
    endif.

    "-----------------------------------------------------------
    " Add Sender Mail
    "-----------------------------------------------------------
    try.
    data(lo_mail) = cl_bcs_mail_message=>create_instance(  ).
    lo_mail->set_sender( lv_sender ).
*    lo_mail->set_subject( 'Invoice' ) .
    lo_mail->set_subject( |Notification of Credit/Debit Note - { ls_header-AccountingDocument }| ).

    "-----------------------------------------------------------
    " Add Content to Mail
    "-----------------------------------------------------------

    DATA : iv_content      TYPE string .
    data(iv_content1) = |<p>Dear Sir or Madam,</p><p></p><p>{ lv_cont }.|.
    data(iv_content2) = | <p></p>Best Regards,</p><p>{ ccname }</p>|.
    iv_content = iv_content1 && iv_content2 .

    "-----------------------------------------------------------
    "Add multiple recipients
    "-----------------------------------------------------------
    LOOP AT gt_email INTO DATA(lv_email).
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
                            iv_content = ls_header-attachment   " PDF Base64 from ADS
                            iv_content_type = 'application/pdf'
                            iv_filename     = 'Credit/Debit.pdf' ) ).

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

    "--------------------------------------------------
    " Validate Send Status
    "--------------------------------------------------
    data(wa_em) = lt_status[ 1 ].
            if wa_em-status = 'S'.
				APPEND VALUE #( %tky = ls_header-%tky
				%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-success
														  text = 'Email Sent Successfully' )
						   ) TO reported-head.
			ELSE.
				APPEND VALUE #( %tky = ls_header-%tky
				%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
														  text = 'Email Sending Failed' )
						   ) TO reported-head.
			ENDIF.			

    ELSE.

		APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
		APPEND VALUE #( %tky = ls_header-%tky
		%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
														  text = 'Email ID is not maintained for this Supplier' )
				   ) TO reported-head.

    ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_ord IN gt_head
                         ( %tky   = ls_ord-%tky
                           %param = ls_ord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZFI_HEAD_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZFI_HEAD_RV IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
        if zbp_fi_head_rv=>upform is NOT INITIAL.
            MODIFY zfi_form_db from table @zbp_fi_head_rv=>upform.
        endif.
**********************************************************************
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
