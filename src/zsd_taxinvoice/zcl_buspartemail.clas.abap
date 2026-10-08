CLASS zcl_buspartemail DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PAY'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'PAY DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_BUSPARTEM'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_BUSPARTEM'.

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



CLASS ZCL_BUSPARTEMAIL IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_BUS_02_LOG'
                                                                      subobject   = 'ZAPP_BUS_02_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        " handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA lt_buspartemail   TYPE STANDARD TABLE OF zdt_buspartemail.
    DATA lt_phnnumber1      TYPE STANDARD TABLE OF zdt_buspartnrphn.
    DATA lt_resvprint TYPE STANDARD TABLE OF zdt_serv_item.
    " ---------------------------------------------------------------------

    SELECT
                       a~businesspartner,
                       b~completetelephonenumber,
                       c~emailaddress
        FROM  i_businessuservh AS a LEFT OUTER JOIN
        i_buspartmobilephonenumbertp_3 AS b ON a~businesspartner = b~businesspartner
        LEFT OUTER JOIN i_buspartemailaddresstp_3 AS c ON a~businesspartner = c~businesspartner
        INTO TABLE @DATA(lt_phnnumber).
    IF sy-subrc = 0.
      SORT lt_phnnumber BY businesspartner.

    ENDIF.
    LOOP AT lt_phnnumber INTO FINAL(ls_phnnumber).
      APPEND INITIAL LINE TO lt_phnnumber1  ASSIGNING FIELD-SYMBOL(<lfs_phnnumber1>).
      <lfs_phnnumber1>-businesspartner = ls_phnnumber-businesspartner.
      <lfs_phnnumber1>-emailaddress    = ls_phnnumber-emailaddress.
      <lfs_phnnumber1>-completetelephonenumber = ls_phnnumber-completetelephonenumber.
    ENDLOOP.

    MODIFY zdt_buspartnrphn FROM TABLE @lt_phnnumber1 .
    COMMIT WORK AND WAIT.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    SELECT a~reservation,
          a~reservationitem,
          a~product,
    a~entryunit,
    a~resvnitmrequiredqtyinentryunit,
    a~goodsrecipientname,
    a~reservationitemtext,
    b~productdescription
    FROM i_reservationdocumentitemtp AS a
    LEFT OUTER JOIN i_productdescription AS b ON a~product = b~product
                                              AND b~language = 'E'
    INTO TABLE @DATA(lt_resv_print).
    IF sy-subrc = 0.
      SORT lt_resv_print BY reservation.

    ENDIF.
    LOOP AT lt_resv_print INTO FINAL(ls_resv_print).
      APPEND INITIAL LINE TO lt_resvprint ASSIGNING FIELD-SYMBOL(<lfs_resv>).
      <lfs_resv>-entryunit = ls_resv_print-entryunit.
      <lfs_resv>-goodsrecipientname    = ls_resv_print-goodsrecipientname.
      <lfs_resv>-product    = ls_resv_print-product.
      <lfs_resv>-productdescription    = ls_resv_print-productdescription.
      <lfs_resv>-reservation    = ls_resv_print-reservation.
      <lfs_resv>-reservationitem    = ls_resv_print-reservationitem.
      <lfs_resv>-reservationitemtext    = ls_resv_print-reservationitemtext.
      <lfs_resv>-resvnitmrequiredqtyinentryunit    = ls_resv_print-resvnitmrequiredqtyinentryunit.

    ENDLOOP.

    MODIFY zdt_serv_item FROM TABLE @lt_resvprint.
    COMMIT WORK AND WAIT.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    " Update Business Partner Email
    SELECT businesspartner,
           emailaddress
      FROM i_buspartemailaddresstp_3
      WHERE emailaddress IS NOT INITIAL
      INTO TABLE @DATA(lt_buspartemailaddress).
    IF sy-subrc = 0.
      SORT lt_buspartemailaddress BY businesspartner.

    ENDIF.

    LOOP AT lt_buspartemailaddress INTO FINAL(ls_buspartemailaddress).
      APPEND INITIAL LINE TO lt_buspartemail ASSIGNING FIELD-SYMBOL(<lfs_buspartemail>).
      <lfs_buspartemail>-businesspartner = ls_buspartemailaddress-businesspartner.
      <lfs_buspartemail>-emailaddress    = ls_buspartemailaddress-emailaddress.
    ENDLOOP.

    MODIFY zdt_buspartemail FROM TABLE @lt_buspartemail.
    COMMIT WORK AND WAIT.

  ENDMETHOD.
ENDCLASS.
