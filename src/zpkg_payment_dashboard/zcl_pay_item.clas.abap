CLASS zcl_pay_item DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAY_ITEM IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA it_pay_item TYPE STANDARD TABLE OF zc_invoice_item WITH DEFAULT KEY.
    it_pay_item  = CORRESPONDING #( it_original_data ).
    LOOP AT it_pay_item  ASSIGNING FIELD-SYMBOL(<fs_pay>).
      IF <fs_pay> IS ASSIGNED.

      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( it_pay_item ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
