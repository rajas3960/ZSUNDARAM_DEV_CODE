CLASS lhc_zpo_i_gstrun DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features
      FOR INSTANCE FEATURES
      keys REQUEST requested_features
      FOR zpo_i_gstrun
      RESULT result.


    METHODS get_instance_authorizations
      FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations
      FOR zpo_i_gstrun
      RESULT result.


    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations
      FOR zpo_i_gstrun
      RESULT result.


    METHODS setdaterange
      FOR MODIFY
      keys FOR ACTION zpo_i_gstrun~setdaterange
      RESULT result.


    METHODS getpost
      FOR MODIFY
      keys FOR ACTION zpo_i_gstrun~getpost
      RESULT result.

ENDCLASS.

CLASS lhc_zpo_i_gstrun IMPLEMENTATION.


  METHOD get_instance_features.
  ENDMETHOD.


  METHOD get_instance_authorizations.
*   IF requested_authorizations-%create = if_abap_behv=>mk-on.
*
*      result-%create =
*        if_abap_behv=>auth-allowed.
  ENDMETHOD.


  METHOD get_global_authorizations.

    IF requested_authorizations-%create =
       if_abap_behv=>mk-on.

      result-%create =
        if_abap_behv=>auth-allowed.

    ENDIF.

  ENDMETHOD.



  METHOD setdaterange.

*    MODIFY ENTITIES OF zpo_i_gstrun
*      IN LOCAL MODE
*
*      ENTITY zpo_i_gstrun
*
*      UPDATE FIELDS (
*        companycode
*        fromdate
*        todate
*      )
*
*      WITH VALUE #(
*
*        FOR ls_key IN keys
*
*        (
*          %tky        = ls_key-%tky
*          companycode = ls_key-%param-companycode
*          fromdate    = ls_key-%param-fromdate
*          todate      = ls_key-%param-todate
*        )
*
*      ).
*
*
*    READ ENTITIES OF zpo_i_gstrun
*      IN LOCAL MODE
*
*      ENTITY zpo_i_gstrun
*
*      ALL FIELDS WITH
*      CORRESPONDING #( keys )
*
*      RESULT DATA(lt_result).
*
*
*    result = VALUE #(
*
*      FOR ls_result IN lt_result
*
*      (
*        %tky   = ls_result-%tky
*        %param = ls_result
*      )
*
*    ).


  MODIFY ENTITIES OF zpo_i_gstrun IN LOCAL MODE
      ENTITY zpo_i_gstrun
      UPDATE FIELDS ( companycode fromdate todate )
      WITH VALUE #(
        FOR ls_key IN keys
        (
          %tky        = ls_key-%tky
          companycode = ls_key-%param-companycode
          fromdate    = ls_key-%param-fromdate
          todate      = ls_key-%param-todate
        )
      ).

    READ ENTITIES OF zpo_i_gstrun IN LOCAL MODE
      ENTITY zpo_i_gstrun
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #(
      FOR ls_result IN lt_result
      (
        %tky   = ls_result-%tky
        %param = ls_result
      )
    ).


  ENDMETHOD.



  METHOD getpost.

**--------------------------------------------------------------------*
** 1. Read GST Run
**--------------------------------------------------------------------*
*
*    READ ENTITIES OF zpo_i_gstrun
*      IN LOCAL MODE
*
*      ENTITY zpo_i_gstrun
*
*      ALL FIELDS WITH
*      CORRESPONDING #( keys )
*
*      RESULT DATA(lt_run).
*
*
*    IF lt_run IS INITIAL.
*      RETURN.
*    ENDIF.
*
*
*    READ TABLE lt_run
*      INTO DATA(ls_run)
*      INDEX 1.
*
*
**--------------------------------------------------------------------*
** 2. Validate Company Code + Dates
**--------------------------------------------------------------------*
*
*    IF ls_run-companycode IS INITIAL.
*
*      APPEND VALUE #(
*
*        %tky = keys[ 1 ]-%tky
*
*        %msg =
*          new_message_with_text(
*            severity =
*              if_abap_behv_message=>severity-error
*
*            text =
*              'Please select Company Code'
*          )
*
*      ) TO reported-zpo_i_gstrun.
*
*      RETURN.
*
*    ENDIF.
*
*
*    IF ls_run-fromdate IS INITIAL
*       OR ls_run-todate IS INITIAL.
*
*      APPEND VALUE #(
*
*        %tky = keys[ 1 ]-%tky
*
*        %msg =
*          new_message_with_text(
*            severity =
*              if_abap_behv_message=>severity-error
*
*            text =
*              'Please enter From Date and To Date'
*          )
*
*      ) TO reported-zpo_i_gstrun.
*
*      RETURN.
*
*    ENDIF.
*
*
*    IF ls_run-fromdate > ls_run-todate.
*
*      APPEND VALUE #(
*
*        %tky = keys[ 1 ]-%tky
*
*        %msg =
*          new_message_with_text(
*            severity =
*              if_abap_behv_message=>severity-error
*
*            text =
*              'From Date cannot be greater than To Date'
*          )
*
*      ) TO reported-zpo_i_gstrun.
*
*      RETURN.
*
*    ENDIF.
*
*
**--------------------------------------------------------------------*
** 3. Read only:
**    - selected
**    - selected company
**    - selected date range
**--------------------------------------------------------------------*
*
*    DATA lt_items TYPE
*      zcl_po_gst_helper=>tt_gst_head.
*
*
*    SELECT FROM zpo_i_gst
*
*      FIELDS *
*
*      WHERE companycode  = @ls_run-companycode
*
*        AND documentdate >= @ls_run-fromdate
*
*        AND documentdate <= @ls_run-todate
*
*        AND selected     = @abap_true
*
*      INTO TABLE @lt_items.
*
*
**--------------------------------------------------------------------*
** 4. No selected records
**--------------------------------------------------------------------*
*
*    IF lt_items IS INITIAL.
*
*      APPEND VALUE #(
*
*        %tky = keys[ 1 ]-%tky
*
*        %msg =
*          new_message_with_text(
*            severity =
*              if_abap_behv_message=>severity-information
*
*            text =
*              'No selected records found for Company Code and Date Range'
*          )
*
*      ) TO reported-zpo_i_gstrun.
*
*      RETURN.
*
*    ENDIF.
*
*
**--------------------------------------------------------------------*
** 5. Generate ACK - READ ONLY here
**--------------------------------------------------------------------*
*
*    DATA(lv_ackno) =
*      zcl_po_gst_helper=>get_next_ackno( ).
*
*
**--------------------------------------------------------------------*
** 6. Call helper
**--------------------------------------------------------------------*
*
*    zcl_po_gst_helper=>post_gst_items(
*
*      EXPORTING
*        it_head        = lt_items
*        iv_batch_ackno = lv_ackno
*
*      IMPORTING
*        et_msg         = DATA(lt_msg)
*        et_status      = DATA(lt_status)
*
*    ).
*
*
**--------------------------------------------------------------------*
** 7. Count errors
**--------------------------------------------------------------------*
*
*    DATA(lv_errors) =
*      REDUCE i(
*
*        INIT lv_count = 0
*
*        FOR ls_msg IN lt_msg
*
*        NEXT lv_count =
*          lv_count +
*          COND #(
*            WHEN ls_msg-severity =
*                 if_abap_behv_message=>severity-error
*
*            THEN 1
*            ELSE 0
*          )
*
*      ).
*
*
*    DATA(lv_success) =
*      lines( lt_msg ) - lv_errors.
*
*
**--------------------------------------------------------------------*
** 8. Buffer DB changes for SAVE phase
**--------------------------------------------------------------------*
*
*    IF lt_status IS NOT INITIAL.
*
*      zbp_po_i_gstrun=>gt_status =
*        lt_status.
*
*      zbp_po_i_gstrun=>gv_ackno =
*        CONV zpo_gst_ackcnt-last_ackno(
*          lv_ackno
*        ).
*
*    ENDIF.
*
*
**--------------------------------------------------------------------*
** 9. Update current GST Run through EML
**--------------------------------------------------------------------*
*
*    MODIFY ENTITIES OF zpo_i_gstrun
*      IN LOCAL MODE
*
*      ENTITY zpo_i_gstrun
*
*      UPDATE FIELDS (
*        status
*        postedcount
*      )
*
*      WITH VALUE #(
*
*        FOR ls_key IN keys
*
*        (
*          %tky = ls_key-%tky
*
*          status =
*            COND #(
*              WHEN lv_errors = 0
*              THEN 'POSTED'
*              ELSE 'PARTIAL'
*            )
*
*          postedcount =
*            lv_success
*        )
*
*      )
*
*      REPORTED DATA(lt_reported_update).
*
*
**--------------------------------------------------------------------*
** 10. Messages
**--------------------------------------------------------------------*
*
*    LOOP AT lt_msg INTO DATA(ls_post_msg).
*
*      APPEND VALUE #(
*
*        %tky = keys[ 1 ]-%tky
*
*        %msg =
*          new_message_with_text(
*            severity = ls_post_msg-severity
*            text     = ls_post_msg-text
*          )
*
*      ) TO reported-zpo_i_gstrun.
*
*    ENDLOOP.
*
*
**--------------------------------------------------------------------*
** 11. Summary message
**--------------------------------------------------------------------*
*
*    APPEND VALUE #(
*
*      %tky = keys[ 1 ]-%tky
*
*      %msg =
*        new_message_with_text(
*
*          severity =
*            COND #(
*              WHEN lv_errors = 0
*              THEN if_abap_behv_message=>severity-success
*              ELSE if_abap_behv_message=>severity-warning
*            )
*
*          text =
*            |Ack { lv_ackno }: { lv_success } of { lines( lt_items ) } records processed|
*
*        )
*
*    ) TO reported-zpo_i_gstrun.
*
*
**--------------------------------------------------------------------*
** 12. Return run
**--------------------------------------------------------------------*
*
*    READ ENTITIES OF zpo_i_gstrun
*      IN LOCAL MODE
*
*      ENTITY zpo_i_gstrun
*
*      ALL FIELDS WITH
*      CORRESPONDING #( keys )
*
*      RESULT DATA(lt_final).
*
*
*    result = VALUE #(
*
*      FOR ls_final IN lt_final
*
*      (
*        %tky   = ls_final-%tky
*        %param = ls_final
*      )
*
*    ).
*
  ENDMETHOD.

ENDCLASS.

