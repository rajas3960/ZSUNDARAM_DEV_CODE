CLASS zcl_rfq_mail_batch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Inventory data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_RFQ_ALOG_03'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_RFQ_SUB_03'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.

  PRIVATE SECTION.

    METHODS: add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.

ENDCLASS.



CLASS ZCL_RFQ_MAIL_BATCH IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
                                             severity = if_bali_constants=>c_severity_status
                                             text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log
*                                                 assign_to_current_appl_job = abap_true
                                                 ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    application_log = cl_bali_log=>create_with_header(
                          header = cl_bali_header_setter=>create( object      = 'ZAPP_RFQ_03_LOG'
                                                                  subobject   = 'ZAPP_RFQ_03_SUB'
                                                                  external_id = 'External ID' ) ).
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
    "no parameter
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    TYPES: BEGIN OF ty_rfq_with_email,
             rfqnumber           TYPE zi_approved_rfq_items-rfqnumber,
             rfqitemnumber       TYPE zi_approved_rfq_items-rfqitemnumber,
             prnumber            TYPE zi_approved_rfq_items-prnumber,
             pritemnumber        TYPE zi_approved_rfq_items-pritemnumber,
             bidder              TYPE zi_approved_rfq_items-bidder,
             material            TYPE zi_approved_rfq_items-material,
             materialdescription TYPE zi_approved_rfq_items-materialdescription,
             uom                 TYPE zi_approved_rfq_items-uom,
             emailaddress        TYPE i_buspartemailaddresstp_3-emailaddress,
             qty                 TYPE i_requestforquotationitemtp-schedulelineorderquantity,
           END OF ty_rfq_with_email.

    DATA: lt_rfq_items TYPE STANDARD TABLE OF ty_rfq_with_email,
          ls_rfq_item  TYPE ty_rfq_with_email,
          lv_sent_flag TYPE c,
          lv_html_body TYPE string,
          lv_email     TYPE zde_email,
          ls_zstatus   TYPE zmail_status,
          lv_counter   TYPE i VALUE 1.


    " fetch approved rfqs from cds
    SELECT a~rfqnumber,
         a~rfqitemnumber,
         a~prnumber,
         a~pritemnumber,
         a~bidder,
         a~material,
         a~materialdescription,
         a~uom,
         b~emailaddress,
         c~schedulelineorderquantity
    FROM zi_approved_rfq_items AS a
    INNER JOIN i_buspartemailaddresstp_3 AS b
      ON a~bidder = b~businesspartner
    INNER JOIN  i_requestforquotationitemtp AS c ON  a~rfqnumber     = c~requestforquotation
                                                         AND a~rfqitemnumber = c~requestforquotationitem
    INTO TABLE @lt_rfq_items.


    LOOP AT lt_rfq_items INTO ls_rfq_item.

      " check in zmail_status whether mail exists
      SELECT SINGLE mail_flag
        FROM zmail_status
        WHERE rfq = @ls_rfq_item-rfqnumber
          AND rfq_item = @ls_rfq_item-rfqitemnumber
          AND supplier = @ls_rfq_item-bidder
        INTO @lv_sent_flag.

      IF lv_sent_flag IS INITIAL.

        " email body
        "?? remarks & delivery date
        lv_html_body = |<p>Dear Sir / Madam,</p>| &&
                       |<p>We're in need the following materials for our plant</p>| &&
                       |The details of materials along with PR number, item code, Item description & quantity as under: -| &&
                       |<br><table border='1' cellpadding='4' cellspacing='1'>| &&
                       |<tr><th>Sl. No.</th><th>PR Number/Item Number</th><th>RFQ Number/Item Number</th><th>Item Code</th><th>Item Description</th><th>UOM</th><th>Qty.</th></tr>| &&
                       |<tr><td>{ lv_counter }</td><td>{ ls_rfq_item-prnumber }/{ ls_rfq_item-pritemnumber }</td><td>{ ls_rfq_item-rfqnumber }/{ ls_rfq_item-rfqitemnumber }</td><td>| &&
                       |{ ls_rfq_item-material }</td><td>{ ls_rfq_item-materialdescription }</td><td>| &&
                       |{ ls_rfq_item-uom }</td><td>{ ls_rfq_item-qty }</td></tr>| &&
                       |</table><p>So, you're requested to kindly arrange to send the offer/quotation along with the price list and catalogs and commercial terms & conditions as soon as possible.</p>| &&
                       |<p>Thanks & Regards<br>SSPL</p>|.

        " fetches bidder address
        lv_email =  ls_rfq_item-emailaddress.

        " updates serial number
        lv_counter += 1.

        " send email
        TRY.
            DATA : iv_content  TYPE string .

            iv_content = lv_html_body.
            DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
            lo_mail->set_sender( 'no-reply@sspl.in' ).
            lo_mail->add_recipient( lv_email ).

            lo_mail->set_subject( '|Request for Quotation { ls_rfq_item-rfqNumber }|' ).
            lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
              iv_content      =  iv_content
              iv_content_type = 'text/html' ) ).


            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

          CATCH cx_bcs_mail INTO DATA(lx_mail).
            "handle exceptions here
        ENDTRY.

        " updates custom table
        ls_zstatus-client     = sy-mandt.
        ls_zstatus-rfq = ls_rfq_item-rfqnumber.
        ls_zstatus-rfq_item   = ls_rfq_item-rfqitemnumber.
        ls_zstatus-supplier = ls_rfq_item-bidder.
        ls_zstatus-mail_flag       = 'X'.
        ls_zstatus-updated_on = utclong_current(  ).


        INSERT zmail_status FROM @ls_zstatus.

      ENDIF.

    ENDLOOP.


*changed logic start

*    LOOP AT lt_rfq_items INTO DATA(ls_item_group)
*      GROUP BY ( rfq = ls_item_group-rfqnumber
*                 supplier = ls_item_group-bidder
*                 email = ls_item_group-emailaddress
*                 )
*     INTO DATA(ls_key).
*
*      " ls_group contains group key and members list
*
*      " checks if mail sent already
*      SELECT SINGLE mail_flag
*        FROM zmail_status
*        WHERE rfq = @ls_key-rfq
*          AND supplier = @ls_key-supplier
*        INTO @lv_sent_flag.
*
*      " stores bidder mail
*      lv_email = ls_key-email.
*
*      IF lv_sent_flag IS INITIAL.
*        " email built with all items in this group
*        DATA(lv_rows) = VALUE string_table( ).
*        DATA(lv_sno) = 1.
*
*        LOOP AT GROUP ls_key INTO DATA(ls_member).
*          lv_rows = VALUE string_table( BASE lv_rows (
*            |<tr><td>{ lv_sno }</td><td>{ ls_member-rfqnumber }/{ ls_member-rfqitemnumber }</td>|
*             && |<td>{ ls_member-material }</td><td>{ ls_member-materialdescription }</td>|
*             && |<td>{ ls_member-uom }</td><td>{ ls_member-qty }</td></tr>| ) ).
*          lv_sno += 1.
*        ENDLOOP.
*
*        CONCATENATE LINES OF lv_rows INTO DATA(lv_rows_str) SEPARATED BY ''.
*
*
*        lv_html_body =  |<p>Dear Sir / Madam,</p>| &&
*                        |<p>We're in need the following materials for our plant:</p>| &&
*                        |The details of materials along with PR number, item code, Item description & quantity as under: -| &&
*                        |<table border="1" cellpadding='4' cellspacing='1'><tr><th>Sl.</th><th>RFQ/Item</th><th>Material</th>| &&
*                        |<th>Description</th><th>UOM</th><th>Qty</th></tr>| &&
*                        COND string( WHEN lv_rows IS INITIAL
*                          THEN |<tr><td colspan="6">No items found</td></tr>|
*                          ELSE |{ lv_rows_str }| ) &&
*                        |</table><p>Thanks & Regards,<br>SSPL</p>|.



    " send email
*        TRY.
*            DATA : iv_content  TYPE string .
*
*            iv_content = lv_html_body.
*            DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
*            lo_mail->set_sender( 'no-reply@sspl.in' ).
*            lo_mail->add_recipient( lv_email ).
*
*            lo_mail->set_subject( '|Request for Quotation { ls_rfq_item-rfqNumber }|' ).
*            lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
*              iv_content      =  iv_content
*              iv_content_type = 'text/html' ) ).
*
*
*            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
*
*          CATCH cx_bcs_mail INTO DATA(lx_mail).
*            "handle exceptions here
*        ENDTRY.
*
*        " updates custom table
*        ls_zstatus-client     = sy-mandt.
*        ls_zstatus-rfq = ls_rfq_item-rfqnumber.
*        ls_zstatus-rfq_item   = ls_rfq_item-rfqitemnumber.
*        ls_zstatus-supplier = ls_rfq_item-bidder.
*        ls_zstatus-mail_flag       = 'X'.
*        ls_zstatus-updated_on = utclong_current(  ).
*
*
*        INSERT zmail_status FROM @ls_zstatus.
*
*      ENDIF.
*
*    ENDLOOP.


*changed logic end


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
