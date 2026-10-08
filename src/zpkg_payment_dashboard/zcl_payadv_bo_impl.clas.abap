CLASS zcl_payadv_bo_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAYADV_BO_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'ACCOUNTINGDOC' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA: rt_table TYPE TABLE OF zce_payadv.

    LOOP AT lt_range[ name = 'ACCOUNTINGDOC' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_accountingdoc) = <ls_range>-low.
    ENDLOOP.

    LOOP AT lt_range[ name = 'FISCALYEAR' ]-range ASSIGNING FIELD-SYMBOL(<ls_range1>).
      DATA(LV_FISCALYEAR) = <ls_range1>-low.
    ENDLOOP.

    LOOP AT lt_range[ name = 'COMPANYCODE' ]-range ASSIGNING FIELD-SYMBOL(<ls_range2>).
      DATA(lv_COMAPNYCODE) = <ls_range2>-low.
    ENDLOOP.

    lv_accountingdoc = |{ lv_accountingdoc ALPHA = IN }|.

      SELECT SINGLE * FROM zi_payadv_head WHERE
        accountingdoc = @lv_accountingdoc
       AND FISCALYEAR = @LV_FISCALYEAR
       AND COMPANYCODE = @lv_comapnycode
       INTO @DATA(ls_quality).

      DATA:
        lv_sum_excl_vat TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
        lv_sum_vat      TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
        lv_sum_all      TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
        lv_currency     TYPE c LENGTH 5.


      INSERT VALUE zce_payadv(
        accountingdoc               = ls_quality-accountingdoc
        fiscalyear                  = ls_quality-fiscalyear
        companycode                 = ls_quality-companycode
        paymentrunid                = ls_quality-paymentrunid
        documentdate                = ls_quality-documentdate
        postingdate                 = ls_quality-postingdate
        valuedate                   = ls_quality-valuedate
        supplier                    = ls_quality-supplier
        suppliername                = ls_quality-suppliername
        streetname                  = ls_quality-streetname
        cityname                    = ls_quality-cityname
        districtname                = ls_quality-districtname
        phonenumber1                = ls_quality-phonenumber1
        taxnumber3                  = ls_quality-taxnumber3
        email                       = ls_quality-email
        amountincompanycodecurrency = ls_quality-amountincompanycodecurrency
        companycodecurrency         = ls_quality-companycodecurrency
        paymentmethod               = ls_quality-paymentmethod
        housebank                   = ls_quality-housebank
        housebankaccount            = ls_quality-housebankaccount
        bankname                    = ls_quality-BankName
        bankaccountnumber           = ls_quality-Bankaccountnumber
        payeebankaccount            = ls_quality-Payeebankaccount
        payeebankkey                = ls_quality-Payeebankkey
        status                      = ls_quality-Status
        utr                         = ls_quality-Utr
      ) INTO TABLE rt_table.


    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
  ENDMETHOD.
ENDCLASS.
