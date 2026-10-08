CLASS lhc_zr_print_queue DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_print_queue RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_print_queue RESULT result.
    METHODS mandatefieldsheader FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_print_queue~mandatefieldsheader.

ENDCLASS.

CLASS lhc_zr_print_queue IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD mandatefieldsheader.
   READ ENTITIES OF ZR_PRINT_QUEUE IN LOCAL MODE
         ENTITY zr_print_queue
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
  SELECT * FROM ZDT_PRINTQUEUE
  INTO TABLE @DATA(LT_DATA).
  READ TABLE LT_DATA INTO DATA(LS_DATA)
  WITH KEY cbuser = GFS_HEADER-Cbuser  printque = gfs_header-Printque.
  IF LS_data is not INITIAL.
   DATA(lv_msg) = |Same Userid and PrintQueue is already Created|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zr_print_queue.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg )
                     )
             TO reported-zr_print_queue.
  endif.

  ENDMETHOD.

ENDCLASS.
