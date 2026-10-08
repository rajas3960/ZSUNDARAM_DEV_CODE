CLASS zcl_pay_head DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAY_HEAD IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
     DATA it_pay_head TYPE STANDARD TABLE OF zc_pay_header WITH DEFAULT KEY.
    it_pay_head   = CORRESPONDING #( it_original_data ).

    loop at it_pay_head  ASSIGNING FIELD-SYMBOL(<fs_pay>).
    if <fs_pay> is ASSIGNED.
        IF <fs_pay>-Supplier IS NOT INITIAL.
            SELECT SINGLE suppliername FROM i_supplier WHERE supplier = @<fs_pay>-Supplier
            INTO @<fs_pay>-SupplierName.
        ENDIF.
     endif.
    ENDLOOP.
     ct_calculated_data = CORRESPONDING #( it_pay_head ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
