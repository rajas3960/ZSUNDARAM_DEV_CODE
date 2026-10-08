CLASS zcl_csq_imp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CSQ_IMP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA it_csq TYPE STANDARD TABLE OF zc_csq_item  WITH DEFAULT KEY.
    it_csq   = CORRESPONDING #( it_original_data ).

    SELECT * FROM i_supplierquotationprcelmnttp
    FOR ALL ENTRIES IN @it_csq
    WHERE supplierquotation = @it_csq-supplierquotation
    AND supplierquotationitem = @it_csq-supplierquotationitem
    INTO TABLE @DATA(lt_suppliercsq).

    CONSTANTS: c_i TYPE char10 VALUE ''''.
    LOOP AT it_csq ASSIGNING FIELD-SYMBOL(<fs_csq>).
      IF <fs_csq> IS ASSIGNED.

        LOOP AT lt_suppliercsq INTO DATA(ls_suppcsq) WHERE supplierquotation = <fs_csq>-supplierquotation
                                                     AND supplierquotationitem = <fs_csq>-supplierquotationitem.

          IF ls_suppcsq-conditiontype = 'PMP0'.
            <fs_csq>-grossprice = ls_suppcsq-conditionamount.
          ELSEIF ls_suppcsq-conditiontype = 'ZABD' OR ls_suppcsq-conditiontype = 'ZDPQ' OR ls_suppcsq-conditiontype = 'ZADV'.
            <fs_csq>-discount = <fs_csq>-discount + ls_suppcsq-conditionamount.
          ELSEIF ls_suppcsq-conditiontype = 'ZPK1' OR ls_suppcsq-conditiontype = 'ZPK2' OR ls_suppcsq-conditiontype = 'ZPK3'.
            <fs_csq>-pkgfwb = <fs_csq>-pkgfwb + ls_suppcsq-conditionamount.
          ELSEIF ls_suppcsq-conditiontype = 'ZIS1' OR ls_suppcsq-conditiontype = 'ZIS2' OR ls_suppcsq-conditiontype = 'ZIS3'.
            <fs_csq>-insurance = <fs_csq>-insurance + ls_suppcsq-conditionamount.

          ELSEIF ls_suppcsq-conditiontype = 'ZEF1' OR ls_suppcsq-conditiontype = 'ZEF2'.
            <fs_csq>-freight = <fs_csq>-freight + ls_suppcsq-conditionamount.

          ELSEIF ls_suppcsq-conditiontype = 'JCDB'.
            <fs_csq>-customduty = <fs_csq>-customduty + ls_suppcsq-conditionamount.
          ELSEIF ls_suppcsq-conditiontype = 'JSWC'.
            <fs_csq>-socialwelfare = ls_suppcsq-conditionamount.
          ELSEIF ls_suppcsq-conditiontype = 'ZLC1' OR  ls_suppcsq-conditiontype = 'ZLC2' OR  ls_suppcsq-conditiontype = 'JUC1' OR ls_suppcsq-conditiontype = 'JUC2'
          OR ls_suppcsq-conditiontype = 'JOT1' OR ls_suppcsq-conditiontype = 'JOT2' OR ls_suppcsq-conditiontype = 'JOT3' OR ls_suppcsq-conditiontype = 'ZESC'
          OR ls_suppcsq-conditiontype = 'ZMTC' .
            <fs_csq>-miscellaneouscost = <fs_csq>-miscellaneouscost + ls_suppcsq-conditionamount.
          ENDIF.
        ENDLOOP.
        <fs_csq>-total = <fs_csq>-GrossPrice + <fs_csq>-socialwelfare + <fs_csq>-pkgfwb + <fs_csq>-insurance + <fs_csq>-freight
        + <fs_csq>-discount + <fs_csq>-customduty  + <fs_csq>-Miscellaneouscost.
      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( it_csq ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
