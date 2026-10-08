CLASS zcl_dept_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ty_gt_value_help_entry TYPE STANDARD TABLE OF zr_dept_f4 WITH DEFAULT KEY.

    TYPES: ty_gp TYPE RANGE OF zr_dept_f4-dept_name.

    METHODS get_provided_ranges
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_gp      TYPE ty_gp.

ENDCLASS.



CLASS ZCL_DEPT_F4 IMPLEMENTATION.


  METHOD get_provided_ranges.
    TRY.
        DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'DEPT_NAME'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_gp.
              ENDLOOP.
          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_previous).
        "Exception handling needed - not implemented yet
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_value_help_entries TYPE STANDARD TABLE OF zr_dept_f4.
    DATA ls_value_help_entry   TYPE zr_dept_f4.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lo_paging) = io_request->get_paging( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lt_sort_elements) = io_request->get_sort_elements( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lv_search_expression) = io_request->get_search_expression( ). " Basic search term

    get_provided_ranges( EXPORTING io_request = io_request
                         IMPORTING et_gp      = DATA(lt_gp) ).

*    IF  lt_gp IS NOT INITIAL.

      SELECT DISTINCT * FROM zdt_dept_value
         Where dept_name in @lt_gp
         INTO TABLE @DATA(lt_gate).

*    ENDIF.

*    IF lt_gp IS NOT INITIAL.

      LOOP AT lt_gate REFERENCE INTO DATA(lr_reason_codes).
        MOVE-CORRESPONDING lr_reason_codes->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.
*    ENDIF.
    io_response->set_data( lt_value_help_entries ).
    io_response->set_total_number_of_records( lines( lt_value_help_entries ) ).
  ENDMETHOD.
ENDCLASS.
