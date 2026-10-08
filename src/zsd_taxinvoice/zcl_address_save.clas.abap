CLASS zcl_address_save DEFINITION
PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Inventory data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_02'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOGS_02'.

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



CLASS ZCL_ADDRESS_SAVE IMPLEMENTATION.


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
                                header = cl_bali_header_setter=>create( object      = 'ZAPP_ADDR_02_LOG'
                                                                        subobject   = 'ZAPP_ADDR_02_SUB'
                                                                        external_id = 'External ID' ) ).
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
    DATA lt_tab TYPE STANDARD TABLE OF zdt_address.

    SELECT * FROM i_businesspartneraddresstp_3
      INTO TABLE @DATA(lt_tabl).
    SELECT * FROM i_businesspartnertp_3
      INTO TABLE @DATA(lt_tab2).
    SELECT * FROM i_buspartemailaddresstp_3
    INTO TABLE @DATA(lt_tab3).
    SELECT * FROM i_busparttelephonenumbertp_3
     INTO TABLE @DATA(lt_tab4).


    LOOP AT lt_tabl INTO DATA(ls_table).
      SELECT SINGLE regionname FROM i_regiontext
        WHERE country  = @ls_table-country AND region = @ls_table-region
          AND language = @sy-langu
        INTO @FINAL(ls_region).
      SELECT SINGLE countryname FROM i_countrytext
        WHERE country  = @ls_table-country AND country = @ls_table-country
          AND language = @sy-langu
        INTO @FINAL(ls_country).
      APPEND VALUE #(
          bp              = |{ ls_table-businesspartner }|
          addressid       = |{ ls_table-addressnumber }|
          address         = |{ ls_table-housenumber } { ls_table-streetname } { ls_table-streetprefixname }{ ls_table-additionalstreetprefixname }|
                       "     && | | && ls_table-streetsuffixname  && ls_table-additionalstreetsuffixname
                      "      && | | && ls_table-districtname && | | && ls_table-homecityname
                            && | { ls_table-cityname } { ls_table-postalcode } , |
                            && | { ls_region } , { ls_country }|
          name            = VALUE #( lt_tab2[ businesspartner = ls_table-businesspartner  ]-fullname OPTIONAL )
          completeaddress = ls_table-completeaddress
          phone  = COND #( WHEN VALUE #( lt_tab4[ businesspartner = ls_table-businesspartner addressnumber =  ls_table-addressnumber isdefaultphonenumber = 'X'  ]-phonenumber OPTIONAL ) IS INITIAL
                           OR VALUE #( lt_tab4[ businesspartner = ls_table-businesspartner addressnumber =  ls_table-addressnumber isdefaultphonenumber = 'X'  ]-phonenumber OPTIONAL ) = '-'
                           THEN ''
                           ELSE VALUE #( lt_tab4[ businesspartner = ls_table-businesspartner addressnumber =  ls_table-addressnumber isdefaultphonenumber = 'X'  ]-internationalphonenumber OPTIONAL ) )
          emailaddress =  VALUE #( lt_tab3[ businesspartner = ls_table-businesspartner addressnumber = ls_table-addressnumber  ]-emailaddress OPTIONAL )  ) TO lt_tab.

    ENDLOOP.
    IF lt_tab IS NOT INITIAL.
      COMMIT ENTITIES BEGIN.
      DELETE FROM zdt_address .
      COMMIT WORK AND WAIT.
      COMMIT ENTITIES END.
      COMMIT ENTITIES BEGIN.
      MODIFY zdt_address FROM TABLE @lt_tab.
      COMMIT WORK AND WAIT.
      COMMIT ENTITIES END.
    ENDIF.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA lt_tab TYPE STANDARD TABLE OF zdt_address.

    SELECT * FROM i_businesspartneraddresstp_3
      INTO TABLE @DATA(lt_tabl).
    SELECT * FROM i_businesspartnertp_3
      INTO TABLE @DATA(lt_tab2).
    SELECT * FROM i_buspartemailaddresstp_3
    INTO TABLE @DATA(lt_tab3).
    SELECT * FROM i_busparttelephonenumbertp_3
     INTO TABLE @DATA(lt_tab4).

    LOOP AT lt_tabl INTO DATA(ls_table).
      SELECT SINGLE regionname FROM i_regiontext
        WHERE country  = @ls_table-country AND region = @ls_table-region
          AND language = @sy-langu
        INTO @FINAL(ls_region).
      SELECT SINGLE countryname FROM i_countrytext
        WHERE country  = @ls_table-country AND country = @ls_table-country
          AND language = @sy-langu
        INTO @FINAL(ls_country).
      APPEND VALUE #(
          bp              = |{ ls_table-businesspartner }|
          addressid       = |{ ls_table-addressnumber }|
          address         = |{ ls_table-housenumber } { ls_table-streetname } { ls_table-streetprefixname }{ ls_table-additionalstreetprefixname }|
                       "     && | | && ls_table-streetsuffixname  && ls_table-additionalstreetsuffixname
                      "      && | | && ls_table-districtname && | | && ls_table-homecityname
                            && | { ls_table-cityname } { ls_table-postalcode } , |
                            && | { ls_region } , { ls_country }|
          name            = VALUE #( lt_tab2[ businesspartner = ls_table-businesspartner  ]-fullname OPTIONAL )
          completeaddress = ls_table-completeaddress
          phone  = COND #( WHEN VALUE #( lt_tab4[ businesspartner = ls_table-businesspartner addressnumber =  ls_table-addressnumber isdefaultphonenumber = 'X'  ]-phonenumber OPTIONAL ) IS INITIAL
                           OR VALUE #( lt_tab4[ businesspartner = ls_table-businesspartner addressnumber =  ls_table-addressnumber isdefaultphonenumber = 'X'  ]-phonenumber OPTIONAL ) = '-'
                           THEN ''
                           ELSE VALUE #( lt_tab4[ businesspartner = ls_table-businesspartner addressnumber =  ls_table-addressnumber isdefaultphonenumber = 'X'  ]-internationalphonenumber OPTIONAL ) )
          emailaddress =  VALUE #( lt_tab3[ businesspartner = ls_table-businesspartner addressnumber = ls_table-addressnumber  ]-emailaddress OPTIONAL )  ) TO lt_tab.

    ENDLOOP.
    IF lt_tab IS NOT INITIAL.
      COMMIT ENTITIES BEGIN.
      DELETE FROM zdt_address .
      COMMIT WORK AND WAIT.
      COMMIT ENTITIES END.
      COMMIT ENTITIES BEGIN.
      MODIFY zdt_address FROM TABLE @lt_tab.
      COMMIT WORK AND WAIT.
      COMMIT ENTITIES END.
    ENDIF.
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
