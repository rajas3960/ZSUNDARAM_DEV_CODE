CLASS zcl_contract DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CONTRACT IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
*    DATA it_contract TYPE STANDARD TABLE OF zc_contractrpt_vf WITH DEFAULT KEY.
*    it_contract   = CORRESPONDING #( it_original_data ).
*    DATA : lv_curr_val TYPE p DECIMALS 2.
*    DATA : lv_curr_val1 TYPE p DECIMALS 2.
*    DATA : lv_customer TYPE char100.
*
*    LOOP AT it_contract ASSIGNING FIELD-SYMBOL(<fs_contract>).
*      IF <fs_contract> IS ASSIGNED.
*        IF <fs_contract>-customerfullname <> lv_customer.
*          lv_customer = <fs_contract>-customerfullname.
*          CLEAR : lv_curr_val.
*          <fs_contract>-creditlimit = <fs_contract>-effectivetotalcreditlimitamt - (  <fs_contract>-grosspriceperton * <fs_contract>-pendingqty ).
*
*          IF <fs_contract>-creditlimit < 0.
*            <fs_contract>-creditlimit = 0.
*            <fs_contract>-creditlimit = <fs_contract>-EffectiveTotalCreditLimitAmt.
*          ELSE.
*            <fs_contract>-creditlimit = <fs_contract>-grosspriceperton * <fs_contract>-pendingqty .
*          ENDIF.
*            <fs_contract>-DispatchableBalance =  <fs_contract>-creditlimit - <fs_contract>-Reserve.
*            <fs_contract>-DispatchableQty = <fs_contract>-DispatchableBalance / <fs_contract>-GrossPricePerTon .
*            lv_curr_val = <fs_contract>-creditlimit.
*            if <fs_contract>-DispatchableBalance < 0.
*            <fs_contract>-DispatchableBalance = 0.
*            <fs_contract>-DispatchableQty = 0.
*            endif.
*        ELSE.
*          IF lv_curr_val < 0.
*            lv_curr_val1 = lv_curr_val * -1.
*          ELSE.
*            lv_curr_val1 = lv_curr_val.
*          ENDIF.
*          <fs_contract>-creditlimit = <fs_contract>-effectivetotalcreditlimitamt - (  <fs_contract>-grosspriceperton * <fs_contract>-pendingqty ) - lv_curr_val1.
*
*          IF <fs_contract>-creditlimit < 0.
*            <fs_contract>-creditlimit = 0.
*            <fs_contract>-creditlimit = <fs_contract>-EffectiveTotalCreditLimitAmt - lv_curr_val1.
*            if <fs_contract>-creditlimit < 0.
*            <fs_contract>-creditlimit = 0.
*            endif.
*          else.
*          <fs_contract>-creditlimit = <fs_contract>-grosspriceperton * <fs_contract>-pendingqty.
*          ENDIF.
*          <fs_contract>-DispatchableBalance = <fs_contract>-creditlimit - <fs_contract>-Reserve.
*          <fs_contract>-DispatchableQty = <fs_contract>-DispatchableBalance / <fs_contract>-GrossPricePerTon .
*          lv_curr_val = <fs_contract>-creditlimit + lv_curr_val.
*           if <fs_contract>-DispatchableBalance < 0.
*            <fs_contract>-DispatchableBalance = 0.
*            <fs_contract>-DispatchableQty = 0.
*            endif.
*
*        ENDIF.
*      ENDIF.
*
*    ENDLOOP.
*
*    ct_calculated_data = CORRESPONDING #( it_contract ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.
ENDCLASS.
