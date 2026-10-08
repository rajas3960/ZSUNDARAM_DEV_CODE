CLASS zcl_debit_credit_bj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

*    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
*    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
*    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
*    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Inventory data'.
*    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DC_ALOG_03'.
*    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DC_SUB_03'.

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



CLASS ZCL_DEBIT_CREDIT_BJ IMPLEMENTATION.


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
    TRY.
        application_log = cl_bali_log=>create_with_header(
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_DC_03_LOG'
                                                                      subobject   = 'ZAPP_DC_03_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
    "no parameter
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    TYPES: BEGIN OF ty_dc_note,
             supplierinvoice             TYPE zcds_debit_credit-supplierinvoice,
             supplierinvoiceitem         TYPE zcds_debit_credit-supplierinvoiceitem,
             fiscalyear                  TYPE zcds_debit_credit-fiscalyear,
             purchaseorder               TYPE zcds_debit_credit-purchaseorder,
             purchaseorderitem           TYPE zcds_debit_credit-purchaseorderitem,
             purchaseorderitemmaterial   TYPE zcds_debit_credit-purchaseorderitemmaterial,
             purchaseorderquantityunit   TYPE zcds_debit_credit-purchaseorderquantityunit,
             quantityinpurchaseorderunit TYPE zcds_debit_credit-quantityinpurchaseorderunit,
             documentcurrency            TYPE zcds_debit_credit-documentcurrency,
             supplierinvoiceitemamount   TYPE zcds_debit_credit-supplierinvoiceitemamount,
             issubsequentdebitcredit     TYPE zcds_debit_credit-issubsequentdebitcredit,
             taxcode                     TYPE zcds_debit_credit-taxcode,
             debitcreditcode             TYPE zcds_debit_credit-debitcreditcode,
             itemtext                    TYPE zcds_debit_credit-itemtext,
             invoicereference            TYPE zcds_debit_credit-invoicereference,
             companycode                 TYPE zcds_debit_credit-companycode,
             supplier                    TYPE i_purchaseorderapi01-supplier,
             suppliername                TYPE i_businesspartner-businesspartnerfullname,
             supplieremail               TYPE i_buspartemailaddresstp_3-emailaddress,
           END OF ty_dc_note.

    DATA: lt_items_dc       TYPE STANDARD TABLE OF ty_dc_note,
          lv_html_body      TYPE string,
          lv_sub_type       TYPE string,
          lv_recipient_mail TYPE zde_email,
          lv_sender_mail    TYPE zde_email.

    " Fetch Debit/Credit + Subsequent Debit/Credit Notes
    SELECT a~supplierinvoice,
           a~supplierinvoiceitem,
           a~fiscalyear,
           a~purchaseorder,
           a~purchaseorderitem,
           a~purchaseorderitemmaterial,
           a~purchaseorderquantityunit,
           a~quantityinpurchaseorderunit,
           a~documentcurrency,
           a~supplierinvoiceitemamount,
           a~issubsequentdebitcredit,
           a~taxcode,
           a~debitcreditcode,
           a~itemtext,
           a~invoicereference,
           a~companycode AS companycode,
           b~supplier,
           d~businesspartnerfullname AS suppliername,
           c~emailaddress            AS supplieremail
      FROM zcds_debit_credit AS a
      INNER JOIN i_purchaseorderapi01 AS b
         ON a~purchaseorder = b~purchaseorder
      LEFT JOIN i_businesspartner AS d
         ON b~supplier = d~businesspartner
      LEFT JOIN i_buspartemailaddresstp_3 AS c
         ON b~supplier = c~businesspartner
     WHERE a~debitcreditcode IN ( 'H', 'S' )
       INTO TABLE @lt_items_dc.

    LOOP AT lt_items_dc INTO DATA(ls_group)
         GROUP BY ( invoice   = ls_group-supplierinvoice
                    fiscalyr  = ls_group-fiscalyear
                    supplier  = ls_group-supplier
                    supname   = ls_group-suppliername
                    supemail  = ls_group-supplieremail
                    dc_code   = ls_group-debitcreditcode
                    subseq    = ls_group-issubsequentdebitcredit ).

      " Skip if mail already sent
      SELECT SINGLE *
        FROM zmail_status_dc
       WHERE supplierinvoice = @ls_group-supplierinvoice
         AND fiscalyear      = @ls_group-fiscalyear
         AND mail_flag       = 'X'
        INTO @DATA(ls_already_sent).
      IF ls_already_sent-mail_flag IS NOT INITIAL.
        CLEAR : ls_already_sent.
        CONTINUE.
      ENDIF.

      " Decide note type
      DATA(lv_note_type) = SWITCH #(
         ls_group-issubsequentdebitcredit && ls_group-debitcreditcode
         WHEN 'H' THEN 'CREDIT'
         WHEN 'XH' THEN 'SUBC'
         WHEN 'XS' THEN 'SUBD'
         ELSE 'NONE' ).

      IF lv_note_type = 'NONE' OR ls_group-supplieremail IS INITIAL.
        CONTINUE.
      ENDIF.

*     fetch sender mail id from TMG
      SELECT SINGLE * FROM zdt_comp_mailid
       WHERE companycode = @ls_group-companycode
       INTO @DATA(ls_sender_emailid).

*     skip if email id not maintained in TMG
      IF ls_sender_emailid IS INITIAL.
        CONTINUE.
      ENDIF.

      " Build email body
      CASE lv_note_type.
        WHEN 'CREDIT'.
          lv_html_body = |<p>Dear { ls_group-suppliername },</p>| &&
                         |<p>Please find below the Credit Note details:</p>| &&
                         |<br><table border='1' cellpadding='4' cellspacing='1'>| &&
                         |<tr><th>Sl. No.</th><th>PO Ref No.</th><th>Item Text</th>| &&
                         |<th>PO Qty</th><th>Material</th><th>UOM</th>| &&
                         |<th>Credit Amount</th><th>Tax Code</th>| &&
                         |<th>Credit Qty</th><th>Invoice Ref</th><th>Invoice Doc</th></tr>|.

        WHEN 'SUBC'.
          lv_html_body = |<p>Dear { ls_group-suppliername },</p>| &&
                         |<p>Please find below the Subsequent Credit Note details:</p>| &&
                         |<br><table border='1' cellpadding='4' cellspacing='1'>| &&
                         |<tr><th>Sl. No.</th><th>PO Ref No.</th><th>Item Text</th>| &&
                         |<th>PO Qty</th><th>Material</th><th>PO Qty UOM</th>| &&
                         |<th>Sub. Credit Note Amount</th><th>Taxes</th>| &&
                         |<th>PO Sub. Credit Qty</th><th>Invoice Ref</th><th>Invoice Doc</th></tr>|.

        WHEN 'SUBD'.
          lv_html_body = |<p>Dear { ls_group-suppliername },</p>| &&
                         |<p>Please find below the Subsequent Debit Note details:</p>| &&
                         |<br><table border='1' cellpadding='4' cellspacing='1'>| &&
                         |<tr><th>Sl. No.</th><th>PO Ref No.</th><th>Item Text</th>| &&
                         |<th>PO Qty</th><th>Material</th><th>PO Qty UOM</th>| &&
                         |<th>Sub. Debit Note Amount</th><th>Taxes</th>| &&
                         |<th>PO Sub. Debit Qty</th><th>Invoice Ref</th><th>Invoice Doc</th></tr>|.

      ENDCASE.

      " Fill table rows
      DATA(lv_counter) = 1.
      LOOP AT GROUP ls_group INTO DATA(ls_dc_note).
        lv_html_body &&= |<tr><td>{ lv_counter }</td>| &&
                         |<td>{ ls_dc_note-purchaseorder }</td>| &&
                         |<td>{ ls_dc_note-itemtext }</td>| &&
                         |<td>{ ls_dc_note-quantityinpurchaseorderunit }</td>| &&
                         |<td>{ ls_dc_note-purchaseorderitemmaterial }</td>| &&
                         |<td>{ ls_dc_note-purchaseorderquantityunit }</td>| &&
                         |<td>{ ls_dc_note-supplierinvoiceitemamount } { ls_dc_note-documentcurrency }</td>| &&
                         |<td>{ ls_dc_note-taxcode }</td>| &&
                         |<td>{ ls_dc_note-quantityinpurchaseorderunit }</td>| &&
                         |<td>{ ls_dc_note-invoicereference }</td>| &&
                         |<td>{ ls_dc_note-supplierinvoice }</td></tr>|.
        lv_counter += 1.
      ENDLOOP.

      lv_html_body &&= |</table><p>Thanks & Regards,<br>SSPL</p>|.

      IF lv_note_type = 'CREDIT'.
        lv_sub_type = 'Credit'.
      ELSEIF lv_note_type = 'SUBC'.
        lv_sub_type = 'Subsequent Credit'.
      ELSEIF lv_note_type = 'SUBD'.
        lv_sub_type = 'Subsequent Debit'.
      ENDIF.

      " Recipient & Sender Email IDs
      lv_recipient_mail = ls_group-supplieremail.
      lv_sender_mail = ls_sender_emailid-accounts.

      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
          lo_mail->set_sender( lv_sender_mail ).
          lo_mail->add_recipient( lv_recipient_mail ).
          lo_mail->set_subject( |{ lv_sub_type } Note Reference| ).
          lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                               iv_content      = lv_html_body
                               iv_content_type = 'text/html' ) ).
          lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
        CATCH cx_bcs_mail INTO DATA(lx_mail).
          " TODO: log failure
      ENDTRY.

      " Update status
      LOOP AT GROUP ls_group INTO ls_dc_note.
        DATA(ls_entry) = VALUE zmail_status_dc(
                            supplierinvoice = ls_dc_note-supplierinvoice
                            fiscalyear      = ls_dc_note-fiscalyear
                            mail_flag       = 'X'
                            updated_on      = utclong_current( ) ).
        INSERT zmail_status_dc FROM @ls_entry.
      ENDLOOP.

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
