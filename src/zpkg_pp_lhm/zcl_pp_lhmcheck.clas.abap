CLASS zcl_pp_lhmcheck DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_co_bd_workorder_confirm .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_LHMCHECK IMPLEMENTATION.


  METHOD if_co_bd_workorder_confirm~save_confirmation.

    SELECT SINGLE manufacturingordertype
    FROM i_manufacturingorder
    WITH PRIVILEGED ACCESS
    WHERE manufacturingorder = @confirmation-ordernumber
    INTO @DATA(lv_ordertype).
    IF sy-subrc = 0.
      IF lv_ordertype = 'ZLHM' AND confirmation-yy1_furnaceno_cfm IS INITIAL.
        errormessagetext = 'Please provide Furnace Detail'.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
