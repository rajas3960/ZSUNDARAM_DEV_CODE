
CLASS zcl_zinghr_posting DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
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



CLASS ZCL_ZINGHR_POSTING IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_ZINGHR_01_LOG'
                                                                      subobject   = 'ZAPP_ZINGHR_01_SUB'
                                                                      external_id = 'ZINGHR Posting' ) ).
      CATCH cx_bali_runtime.
        " handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA: lt_je_deep  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lt_cust_tbl TYPE STANDARD TABLE OF zdt_zinghr_hdr.

    SELECT h~companycode, h~payrollrunid, h~payrollrundate, h~payrollrunremarks,h~postingstatus,h~last_changed_at,
           i~glid, i~costcenter, i~profitcenter, i~amt, i~glname, i~costcenterdesc
    FROM zdt_zinghr_hdr AS h
    INNER JOIN zdt_zinghr_itm AS i ON i~companycode = h~companycode
    AND i~payrollrunid = h~payrollrunid
    AND i~payrollrundate = h~payrollrundate
    WHERE h~postingstatus IS INITIAL
    ORDER BY h~companycode, h~payrollrunid, h~payrollrundate
    INTO TABLE @DATA(lt_data).
    IF sy-subrc IS INITIAL.
      DATA(lt_hdr) = lt_data.
      DELETE ADJACENT DUPLICATES FROM lt_hdr COMPARING companycode payrollrunid payrollrundate.
      LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<lfs_hdr>).
        DATA(lv_gllineitemno) = 000.
        APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
        <je_deep>-%cid = |{ <lfs_hdr>-companycode }{ <lfs_hdr>-payrollrunid }{ <lfs_hdr>-payrollrundate }|.
        <je_deep>-%param = VALUE #(
        companycode = <lfs_hdr>-companycode
        documentreferenceid = 'BKPFF'
        createdbyuser = <lfs_hdr>-payrollrunremarks
        businesstransactiontype = 'RFBU'
        accountingdocumenttype = 'SA'
        documentdate = <lfs_hdr>-payrollrundate
        postingdate = <lfs_hdr>-payrollrundate
        accountingdocumentheadertext = <lfs_hdr>-payrollrunremarks ).

        LOOP AT lt_data INTO DATA(ls_itm) WHERE companycode = <lfs_hdr>-companycode
                                            AND payrollrunid = <lfs_hdr>-payrollrunid
                                            AND payrollrundate = <lfs_hdr>-payrollrundate.
          lv_gllineitemno += 1.

          APPEND INITIAL LINE TO <je_deep>-%param-_glitems ASSIGNING FIELD-SYMBOL(<lfs_glitems>).
          <lfs_glitems>-GLAccountLineItem = lv_gllineitemno.
          <lfs_glitems>-GLAccount = ls_itm-glid.
          <lfs_glitems>-CostCenter = ls_itm-costcenter.
          <lfs_glitems>-ProfitCenter = ls_itm-profitcenter.
          <lfs_glitems>-_currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = ls_itm-amt currency = 'INR' ) ).


        ENDLOOP.

        MODIFY ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE post FROM lt_je_deep
         FAILED DATA(ls_failed_deep)
         REPORTED DATA(ls_reported_deep)
         MAPPED DATA(ls_mapped_deep).

        IF ls_failed_deep IS NOT INITIAL.

          LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
            DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
            add_text_to_app_log_or_console( i_text = CONV #( lv_result ) ).
          ENDLOOP.
        ELSE.

          COMMIT ENTITIES BEGIN
          RESPONSE OF i_journalentrytp
          FAILED DATA(lt_commit_failed)
          REPORTED DATA(lt_commit_reported).

          COMMIT ENTITIES END.

          <lfs_hdr>-postingstatus = 'X'.
        ENDIF.

        FREE : lt_je_deep.
      ENDLOOP.
      lt_cust_tbl = CORRESPONDING #( lt_hdr ).
      MODIFY zdt_zinghr_hdr FROM TABLE @lt_cust_tbl.
    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.

    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
