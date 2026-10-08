CLASS zcl_email DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EMAIL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
     DATA it_pay_head TYPE STANDARD TABLE OF zc_payadv_head WITH DEFAULT KEY.
     it_pay_head   = CORRESPONDING #( it_original_data ).
     LOOP AT it_pay_head ASSIGNING FIELD-SYMBOL(<fs_pay>).
      SELECT SINGLE EmailAddress FROM I_BusPartEmailAddressTP_3
      WHERE BusinessPartner = @<fs_pay>-Supplier INTO @<fs_pay>-Email.
     ENDLOOP.
     ct_calculated_data = CORRESPONDING #( it_pay_head ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
