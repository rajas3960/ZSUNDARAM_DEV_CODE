CLASS zcl_qal_bo_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_QAL_BO_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'ID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA rt_table TYPE TABLE OF zi_qal_print.

    LOOP AT lt_range[ name = 'ID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_id) = <ls_range>-low.
      SELECT SINGLE * FROM zdt_quality WHERE
        id = @lv_id INTO @DATA(ls_quality).

      DATA:
        lv_sum_excl_vat TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
        lv_sum_vat      TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
        lv_sum_all      TYPE p LENGTH 15 DECIMALS 2 VALUE 0,
        lv_currency     TYPE c LENGTH 5.

      DATA : lv_billdoc TYPE vbeln.
      lv_billdoc = |{ ls_quality-billingdoc ALPHA = IN }|.

      SELECT SINGLE * FROM zv_billquality
      WHERE billingdocument = @lv_billdoc
      INTO @DATA(ls_billing).


      INSERT VALUE zi_qal_print(
        id = ls_quality-id
        billingdoc = ls_quality-billingdoc
        billingitem = ls_quality-billingitem
        plant = ls_quality-plant
        vehicleno = ls_quality-vehicleno
        material = ls_quality-material
        thickness = ls_quality-thickness
        width = ls_quality-width
        quantity = ls_quality-quantity
        batch = ls_quality-batch
        grade = ls_quality-grade
        customer = ls_quality-customer
        treatment = ls_quality-treatment
        coatside = ls_quality-coatside
        filmtype = ls_quality-filmtype
        pono     = ls_quality-pono
        deliveryno = ls_quality-deliveryno
        deliveryitem = ls_quality-deliveryitem
        salesord = ls_quality-salesord
        salesitem = ls_quality-salesitem
        invdate = ls_quality-invdate
        testcertprnt = ls_quality-testcertprnt
        textbox          = ls_quality-textbox
        inspecplangroup  = ls_quality-inspecplangroup
        inspecplan       = ls_quality-inspecplan
        remarks       = ls_quality-remarks
        qc_cert_no      = ls_quality-qc_cert_no
        prod_name      = ls_quality-prod_name
        prod_group     = ls_quality-prod_group
        chem_metal     = ls_quality-chem_metal
        companycode = ls_billing-companycode
        companycodename = ls_billing-companycodename
      ) INTO TABLE rt_table.
    ENDLOOP.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
  ENDMETHOD.
ENDCLASS.
