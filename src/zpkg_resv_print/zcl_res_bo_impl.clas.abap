CLASS zcl_res_bo_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_RES_BO_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA rt_table TYPE TABLE OF zi_res_headprint.
    DATA res(80).
    DATA resv(10).
    DATA: dd(2),mm(2),yy(4),dt(10).
    CLEAR res.
    IF NOT io_request->is_data_requested( ).
      RETURN.
    ENDIF.

    FINAL(lo_filter) = io_request->get_filter( ).
    TRY.
        FINAL(lt_range) = lo_filter->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'RESERVATION' ] ).
      " Need select parameter!
      RETURN.
    ENDIF.
    LOOP AT lt_range[ name = 'RESERVATION' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      FINAL(lv_id) = <ls_range>-low.
*      SELECT SINGLE * FROM zr_resvttph WHERE Reservation = @lv_id INTO @FINAL(ls_rev).

      SELECT SINGLE * FROM  zcds_res_head WHERE reservation = @lv_id INTO @FINAL(ls_rev).
      res = ls_rev-costcenter.
      IF ls_rev-assetsubnumber IS NOT INITIAL.
        CONCATENATE res '/'  ls_rev-assetsubnumber INTO res.
      ENDIF.
      IF ls_rev-wbselementinternalid IS NOT INITIAL.
        CONCATENATE res '/'  ls_rev-wbselementinternalid INTO res.
      ENDIF.
      SELECT SUM( avgvalue ) FROM zcds_res_final  WHERE reservation = @ls_rev-reservation INTO @DATA(avgval).
      resv = |{ ls_rev-reservation ALPHA = OUT }|.
      dd = ls_rev-reservationdate+6(2). mm = ls_rev-reservationdate+4(2). yy = ls_rev-reservationdate+0(4).
      CONCATENATE dd '.' mm '.' yy INTO dt. SHIFT res LEFT DELETING LEADING '0'.
      SELECT SINGLE * FROM i_reservationdocumenttp
      WHERE reservation =  @lv_id
      INTO @DATA(ls_resv).

      select single * from I_BusinessUserBasic
      where Userid = @ls_resv-UserID
      into @data(ls_uname).

      SELECT SINGLE * FROM i_costcentertext
      WHERE costcenter = @ls_resv-costcenter
      INTO @DATA(ls_costcenter).

      SELECT SINGLE * FROM i_reservationdocumentitemtp
      WHERE reservation = @lv_id
      INTO @DATA(ls_recvplant).

      select single * from zdt_plantaddress
      where bukrs = '1000'
      into @data(ls_plantaddr).
      data(ls_addr) = |{ ls_plantaddr-address1 }{ ls_plantaddr-address2 } { ls_plantaddr-city } { ls_plantaddr-statecode } { ls_plantaddr-pincode }|.

      INSERT VALUE zi_res_headprint( reservation                  = resv "ls_rev-reservation
                                     orderid                      = ls_resv-orderid "ls_rev-orderid
                                     goodsmovementtype            = ls_rev-goodsmovementtype
                                     costcenter                   = ls_resv-costcenter
                                     profitcenter                 = ls_rev-profitcenter
                                     goodsrecipientname           = ls_rev-goodsrecipientname
                                     customer                     = res
                                     wbselementinternalid         = ls_rev-wbselementinternalid
                                     issuingorreceivingplant      = ls_resv-issuingorreceivingplant
                                     issuingorreceivingstorageloc = ls_resv-issuingorreceivingstorageloc
                                     resvnverificationcompanycode = ls_rev-resvnverificationcompanycode
                                     userid                       = ls_rev-userid
                                     creationdatetime             = ls_resv-reservationdate
                                     lastchangedbyuser            = ls_rev-personfullname
                                     lastchangedatetime           = ls_rev-lastchangedatetime
                                     status                       = avgval
                                     departmentname               = ls_costcenter-costcentername
                                     companycode                  = ls_resv-resvnverificationcompanycode
                                     issuingplant                 = ls_resv-issuingorreceivingplant
                                     receivingplant               = ls_recvplant-Plant
                                     address                      = ls_addr
                                     UserName                     = ls_uname-PersonFullName
                                      )
             INTO TABLE rt_table.
    ENDLOOP.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
  ENDMETHOD.
ENDCLASS.
