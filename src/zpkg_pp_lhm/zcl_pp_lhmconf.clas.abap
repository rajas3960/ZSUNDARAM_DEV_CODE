CLASS zcl_pp_lhmconf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_workorder_goodsmovt_bkf_gdr .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_LHMCONF IMPLEMENTATION.


  METHOD if_workorder_goodsmovt_bkf_gdr~modify_goods_movement.

    DATA: lv_001   TYPE zde_confno VALUE 001,
          lv_999   TYPE zde_confno,
          lv_batch TYPE charg_d.

    TRY.
        GET TIME STAMP FIELD DATA(lv_utctimestamp).
        CONVERT TIME STAMP lv_utctimestamp  TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
        lv_batch = confirmation-yy1_furnaceno_cfm && lv_date+2(2) && lv_date+4(2) && |%|.
      CATCH cx_abap_context_info_error.
    ENDTRY.

    SELECT SINGLE manufacturingorder,
                  companycode
    FROM i_manufacturingorder
    WITH PRIVILEGED ACCESS
    WHERE manufacturingorder = @order_header-ordernumber
    INTO @DATA(ls_orderheader).

    SELECT  materialdocument,
            materialdocumentyear,
            materialdocumentitem,
            manufacturingorder,
            batch
    FROM i_materialdocumentitem_2
    WITH PRIVILEGED ACCESS
    WHERE goodsmovementtype = '101'
    AND companycode = @ls_orderheader-companycode
    AND batch LIKE @lv_batch
    INTO TABLE @DATA(lt_matdocitem).
    IF sy-subrc = 0.
      SORT lt_matdocitem BY batch DESCENDING.
    ENDIF.

    IF order_header-manufacturingordertype = 'ZLHM'.
      DATA(ls_matdocitem) = VALUE #( lt_matdocitem[ 1 ] OPTIONAL ).
      IF ls_matdocitem IS INITIAL.
        LOOP AT goods_movements ASSIGNING FIELD-SYMBOL(<lfs_goodsmovement>) WHERE goodsmovementtype = '101'.
          <lfs_goodsmovement>-batch = confirmation-yy1_furnaceno_cfm && lv_date+2(2) && lv_date+4(2) && lv_001.
        ENDLOOP.
      ELSE.
        lv_999 = ls_matdocitem-batch+5(3). lv_999 = lv_999 + 1.
        LOOP AT goods_movements ASSIGNING <lfs_goodsmovement> WHERE goodsmovementtype = '101'.
          <lfs_goodsmovement>-batch = confirmation-yy1_furnaceno_cfm && lv_date+2(2) && lv_date+4(2) && lv_999.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
